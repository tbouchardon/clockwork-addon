-- QR code v3 : carré de 32x32 en quatre blocs de 16x16, pour que le Java décide lui-même (règles YAML).
--   bloc 1 (0, 0) : touches sans modificateur et état du combat (disposition de la v2, inchangée)
--   bloc 2 (16, 0) : Maj + touche, bloc 3 (0, 16) : Ctrl + touche, bloc 4 (16, 16) : Alt + touche
--   Les blocs 2 à 4 reprennent exactement les cases de touches du bloc 1 (état, historique, sort), décalées.
-- Tout est lisible en 12.x : les valeurs secrètes (temps de recharge) passent directement à SetColorTexture,
-- les autres sont calculées ici (temps depuis le dernier lancement, à partir de UNIT_SPELLCAST_SUCCEEDED).
--
-- Cases (x, y) relatives à un bloc, couleurs de 0 à 1 :
--   ligne 6, sous chaque touche 1..= (x 2..13) et ligne 12 x 2..7 (Q D R T F G) : état de la touche
--       R = temps de recharge restant / 60 s, G = utilisable (1/0), B = à portée (1), hors de portée (0), sans portée (0,5)
--   ligne 9, sous chaque touche 1..= (x 2..13) et ligne 12 x 8..13 (Q D R T F G) : historique du sort de la touche
--       R = temps depuis le dernier lancement sur la cible actuelle / 60 s (1 = jamais ou plus de 60 s)
--       G = proc (bouton en surbrillance), B = temps depuis le dernier lancement, toutes cibles / 60 s
--   identifiant du sort de chaque touche sur 24 bits (R octet fort, G, B octet faible), dans l'ordre de KEY_ORDER :
--       touches 1..8 en (3..10, 3), 9..12 en (2..5, 7), 13..16 en (2..5, 10), 17..18 en (8..9, 2) ; 0 = pas de sort
--   (6, 2) : identifiant du sort recommandé par Blizzard sur 24 bits (0 = aucun)
--   (7, 2) : direction du personnage sur 16 bits, R = octet fort, G = octet faible (0..65535 pour 0..2π)
--   (2, 3) : nombre d'ennemis en combat (barres de vie), R = nombre / 255
--   (8, 13) : version de la grille, R = 3 / 255
--   (11, 2) : compteur de mises à jour sur 24 bits (le Java détecte une grille figée)
--   (10, 2) : R = mode aggro (1/0), G = cible en combat (1/0)
--
-- Le dictionnaire des sorts (identifiant -> nom, sort de base) est exporté dans la SavedVariable CLOCKWORK_SPELLBOOK,
-- écrite sur le disque par WoW à chaque /reload ou déconnexion : le Java y traduit les noms des règles en identifiants.

Clockwork.QR_VERSION = 3

-- Blocs de la grille : préfixe de touche (modificateur) et décalage du bloc
Clockwork.QR_BLOCKS = {
    { prefix = "", x = 0, y = 0 },
    { prefix = "SHIFT-", x = 16, y = 0 },
    { prefix = "CTRL-", x = 0, y = 16 },
    { prefix = "ALT-", x = 16, y = 16 },
}

-- Ordre des touches pour l'indice de la touche recommandée (partagé avec le Java)
Clockwork.KEY_ORDER = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ")", "=", "Q", "D", "R", "T", "F", "G" }

local NUMBER_KEYS = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ")", "=" }
local LETTER_KEYS = { "Q", "D", "R", "T", "F", "G" }
local HORIZON = 60 -- secondes encodées dans un canal (0..1)

-- Dernier lancement par sort : { time = GetTime(), guid = cible au moment du lancement }
Clockwork.lastCasts = {}

local cooldownCurve

local function curve()
    if not cooldownCurve then
        cooldownCurve = C_CurveUtil.CreateCurve()
        cooldownCurve:AddPoint(0, 0)
        cooldownCurve:AddPoint(HORIZON, 1)
    end
    return cooldownCurve
end

local function spellIdCell(position)
    if position <= 8 then return position + 2, -3 end
    if position <= 12 then return position - 7, -7 end
    if position <= 16 then return position - 11, -10 end
    return position - 9, -2
end

--- Encode un entier sur 24 bits dans une texture (R octet fort, G, B octet faible).
local function setColor24(texture, value)
    value = math.max(0, math.min(math.floor(value or 0), 16777215))
    texture:SetColorTexture(math.floor(value / 65536) / 255, math.floor(value / 256) % 256 / 255, value % 256 / 255, 1)
end

--- Fond d'un bloc de modificateur, identique au bloc 1 : coins verts (repérage) et intérieur noir.
function Clockwork:createQrBlock(offsetX, offsetY)
    local block = CreateFrame("FRAME", nil, self.frame)
    block:SetPoint("TOPLEFT", offsetX, -offsetY)
    block:SetSize(16, 16)
    block:SetFrameStrata("MEDIUM")
    block.texture = block:CreateTexture(nil, "BACKGROUND")
    block.texture:SetAllPoints()
    block.texture:SetColorTexture(0, 1, 0, 1)
    for _, size in ipairs({ { 14, 14 }, { 16, 8 }, { 8, 16 } }) do
        local black = CreateFrame("FRAME", nil, block)
        black:SetPoint("CENTER", 0, 0)
        black:SetSize(size[1], size[2])
        black:SetFrameStrata("MEDIUM")
        black.texture = black:CreateTexture(nil, "ARTWORK")
        black.texture:SetAllPoints()
        black.texture:SetColorTexture(0, 0, 0, 1)
    end
    return block
end

function Clockwork:initQrCodeV2()
    self.keyState = {}
    self.keyHistory = {}
    self.keySpell = {}
    self.qrBlocks = {}
    for blockIndex, block in ipairs(Clockwork.QR_BLOCKS) do
        if blockIndex > 1 then self.qrBlocks[blockIndex] = self:createQrBlock(block.x, block.y) end
        local function dot(name, x, y) return self:createDot(name, x + block.x, y - block.y) end
        for position, key in ipairs(Clockwork.KEY_ORDER) do
            local combo = block.prefix .. key
            self.keySpell[combo] = dot("keySpell_" .. combo, spellIdCell(position))
        end
        for index, key in ipairs(NUMBER_KEYS) do
            local combo = block.prefix .. key
            self.keyState[combo] = dot("keyState_" .. combo, index + 1, -6)
            self.keyHistory[combo] = dot("keyHistory_" .. combo, index + 1, -9)
        end
        for index, key in ipairs(LETTER_KEYS) do
            local combo = block.prefix .. key
            self.keyState[combo] = dot("keyState_" .. combo, index + 1, -12)
            self.keyHistory[combo] = dot("keyHistory_" .. combo, index + 7, -12)
        end
    end
    self.frameCounter = self:createDot("frameCounter", 11, -2)
    self.recommendedSpell = self:createDot("recommendedSpell", 6, -2)
    self.facing = self:createDot("facing", 7, -2)
    self.flags = self:createDot("flags", 10, -2)
    self.qrVersion = self:createDot("qrVersion", 8, -13)
    self.qrVersion.texture:SetColorTexture(Clockwork.QR_VERSION / 255, 0, 0, 1)
end

--- Enregistre un lancement réussi du joueur, sous l'identifiant du sort et sous celui de sa forme de base
--- (le bouton contient la forme de base, ex. 188389 pour la variante 470411).
function Clockwork.recordOwnCast(spellID)
    if not spellID or issecretvalue and issecretvalue(spellID) then return end
    local entry = { time = GetTime(), guid = UnitGUID("target") }
    Clockwork.lastCasts[spellID] = entry
    local base = C_Spell.GetBaseSpell and C_Spell.GetBaseSpell(spellID)
    if base and base ~= spellID then Clockwork.lastCasts[base] = entry end
end

--- Nom de combinaison d'un raccourci : "3", "SHIFT-3", "CTRL-Q", "ALT-="... ; nil pour plusieurs modificateurs.
local function comboName(binding)
    local modifiers = (binding.shift and 1 or 0) + (binding.ctrl and 1 or 0) + (binding.alt and 1 or 0)
    if modifiers > 1 then return nil end
    return (binding.shift and "SHIFT-" or binding.ctrl and "CTRL-" or binding.alt and "ALT-" or "") .. binding.key
end

--- Table combinaison -> emplacement de barre, reconstruite à chaque mise à jour
--- (les barres changent avec les formes, les pages, les talents).
function Clockwork:buildKeySlotMap()
    local map = {}
    if not self.commandBindingMap then return map end
    for slot = 1, 180 do
        local command = Clockwork.getActionSlotCommand(slot)
        local binding = command and self.commandBindingMap[command]
        local combo = binding and comboName(binding)
        if combo and self.keyState[combo] and HasAction(slot) and map[combo] == nil then
            map[combo] = slot
        end
    end
    return map
end

--- Sort et emplacement de barre associés à une touche sans modificateur, ou nil.
function Clockwork:spellForKey(key)
    local slot = self.keySlotMap and self.keySlotMap[key]
    if not slot then return nil end
    local actionType, id = GetActionInfo(slot)
    if actionType ~= "spell" then return nil, slot end
    return id, slot
end

local function elapsedRatio(entry)
    if not entry then return 1 end
    return math.min((GetTime() - entry.time) / HORIZON, 1)
end

function Clockwork:updateKeyState(key)
    local spellID, slot = self:spellForKey(key)
    setColor24(self.keySpell[key].texture, spellID or 0)
    if not slot then
        self.keyState[key].texture:SetColorTexture(0, 0, 0, 1)
        self.keyHistory[key].texture:SetColorTexture(1, 0, 1, 1)
        return
    end

    -- Temps de recharge : valeur secrète en combat, transmise telle quelle à la texture
    local remaining = 0
    local duration = C_ActionBar.GetActionCooldownDuration and C_ActionBar.GetActionCooldownDuration(slot)
    if duration then remaining = duration:EvaluateRemainingDuration(curve()) end

    local usable = IsUsableAction(slot) and 1 or 0
    local inRange = IsActionInRange(slot)
    local range = inRange == nil and 0.5 or (inRange and 1 or 0)
    self.keyState[key].texture:SetColorTexture(remaining, usable, range, 1)

    local entry = spellID and Clockwork.lastCasts[spellID]
    local onTarget = entry
    if entry and entry.guid ~= UnitGUID("target") then onTarget = nil end
    local proc = spellID and C_SpellActivationOverlay and C_SpellActivationOverlay.IsSpellOverlayed(spellID) and 1 or 0
    self.keyHistory[key].texture:SetColorTexture(elapsedRatio(onTarget), proc, elapsedRatio(entry), 1)
end

function Clockwork:updateQrCodeV2()
    Clockwork.guard("keySlotMap", function() self.keySlotMap = self:buildKeySlotMap() end)

    Clockwork.qrFrame = ((Clockwork.qrFrame or 0) + 1) % 16777216
    setColor24(self.frameCounter.texture, Clockwork.qrFrame)

    for _, block in ipairs(Clockwork.QR_BLOCKS) do
        for _, key in ipairs(Clockwork.KEY_ORDER) do
            local combo = block.prefix .. key
            Clockwork.guard("key " .. combo, function() self:updateKeyState(combo) end)
        end
    end

    Clockwork.guard("recommendedSpell", function()
        local spellID = C_AssistedCombat and C_AssistedCombat.GetNextCastSpell and C_AssistedCombat.GetNextCastSpell()
        -- Forme de base : c'est elle que contient le bouton, donc celle que le Java retrouve dans les cases des touches
        local base = spellID and C_Spell.GetBaseSpell and C_Spell.GetBaseSpell(spellID)
        setColor24(self.recommendedSpell.texture, base or spellID or 0)
    end)

    Clockwork.guard("flags", function()
        self.flags.texture:SetColorTexture(Clockwork.AGGRO_MOD and 1 or 0, UnitAffectingCombat("target") and 1 or 0, 0, 1)
    end)

    Clockwork.guard("facing", function()
        local facing = GetPlayerFacing() or 0
        local value = math.floor(facing / (2 * math.pi) * 65535 + 0.5)
        self.facing.texture:SetColorTexture(math.floor(value / 256) / 255, (value % 256) / 255, 0, 1)
    end)

    Clockwork.guard("enemies", function()
        local count = 0
        for index = 1, 40 do
            local unit = "nameplate" .. index
            if UnitExists(unit) and UnitCanAttack("player", unit) and UnitAffectingCombat(unit) then
                count = count + 1
            end
        end
        self.numberOfTargets.texture:SetColorTexture(math.min(count, 255) / 255, 0, 0, 1)
    end)
end

--- Exporte le dictionnaire des sorts des barres d'action (identifiant -> nom, sort de base, variante active) dans
--- CLOCKWORK_SPELLBOOK, que WoW écrit sur le disque au prochain /reload ou à la déconnexion.
function Clockwork.exportSpellbook()
    CLOCKWORK_SPELLBOOK = CLOCKWORK_SPELLBOOK or {}
    local book = {}
    local function add(spellID)
        if not spellID or book[spellID] then return end
        local name = C_Spell.GetSpellName(spellID)
        if not name then return end
        book[spellID] = { name = name, base = C_Spell.GetBaseSpell(spellID), override = C_Spell.GetOverrideSpell(spellID) }
    end
    for slot = 1, 180 do
        local actionType, id = GetActionInfo(slot)
        if actionType == "spell" then
            add(id)
            add(C_Spell.GetOverrideSpell(id))
        end
    end
    for spellID in pairs(Clockwork.lastCasts) do add(spellID) end

    local class = Clockwork.player.class and Clockwork.player.class.classFilename or "?"
    local spec = Clockwork.player.specialization and Clockwork.player.specialization.id or 0
    CLOCKWORK_SPELLBOOK[class .. "-" .. spec] = { updated = date("%Y-%m-%d %H:%M:%S"), spells = book }
end
