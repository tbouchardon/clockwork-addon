-- QR code v4 : carré de 32x32 en quatre blocs de 16x16, pour que le Java décide lui-même (règles YAML).
-- v4 = v3 + groupe et raid dans les cases libres du bloc 2, et mode soigneur (voir group.lua).
--   bloc 1 (0, 0) : touches sans modificateur et état du combat (disposition de la v2, inchangée)
--   bloc 2 (16, 0) : Maj + touche, bloc 3 (0, 16) : Ctrl + touche, bloc 4 (16, 16) : Alt + touche
--   Les blocs 2 à 4 reprennent exactement les cases de touches du bloc 1 (état, historique, sort), décalées.
-- Tout est lisible en 12.x : les valeurs secrètes (temps de recharge) passent directement à SetColorTexture,
-- les autres sont calculées ici (temps depuis le dernier lancement, à partir de UNIT_SPELLCAST_SUCCEEDED).
--
-- Cases (x, y) relatives à un bloc, couleurs de 0 à 1 :
--   ligne 6, sous chaque touche 1..= (x 2..13) et ligne 12 x 2..7 (Q D R T F G) : état de la touche
--       R = temps de recharge restant / 60 s, G = utilisable (1), inutilisable (0), utilisable mais à incantation
--       pendant un déplacement (0,5 : WoW le refuserait), B = à portée (1), hors de portée (0), sans portée (0,5)
--   ligne 9, sous chaque touche 1..= (x 2..13) et ligne 12 x 8..13 (Q D R T F G) : historique du sort de la touche
--       R = temps depuis le dernier lancement sur la cible actuelle / 60 s (1 = jamais ou plus de 60 s)
--       G = proc (bouton en surbrillance) + 2 x buff actif sur le joueur, sur 3 (0, 1/3, 2/3, 1) ;
--       B = temps depuis le dernier lancement, toutes cibles / 60 s
--       Le buff n'est lisible que hors combat : en combat, c'est l'état lu juste avant d'y entrer
--   identifiant du sort de chaque touche sur 24 bits (R octet fort, G, B octet faible), dans l'ordre de KEY_ORDER :
--       touches 1..8 en (3..10, 3), 9..12 en (2..5, 7), 13..16 en (2..5, 10), 17..18 en (8..9, 2) ; 0 = pas de sort
--       Objet (potion, pierre de soins, leurre...) : 8388608 (bit 23) + identifiant de l'objet. Son historique change
--       alors de sens : R = nombre d'objets possédés / 255 (charges comprises), G = 2/3 si l'aura de son sort est
--       active sur le joueur, B = temps depuis la dernière utilisation / 60 s. Une macro est décrite par le sort ou
--       l'objet qu'elle affiche.
--   (6, 2) : identifiant du sort recommandé par Blizzard sur 24 bits (0 = aucun)
--   (7, 2) : direction du personnage sur 16 bits, R = octet fort, G = octet faible (0..65535 pour 0..2π)
--   (2, 3) : nombre d'ennemis en combat (barres de vie), R = nombre / 255
--   (8, 13) : version de la grille, R = 4 / 255
--   (11, 2) : compteur de mises à jour sur 24 bits (le Java détecte une grille figée)
--   (10, 2) : R = mode aggro (1/0), G = cible en combat (1/0), B = mode multi-cibles (1/0)
--   (8, 4) : sort de la forme active (druide : félin, ours, sélénien...) sur 24 bits, 0 = aucune forme
--   (9, 4) : R = ressource de classe / 255 : points de combo (voleur, druide), éclats d'âme (démoniste), puissance sacrée
--       (paladin), chi (moine), essence (évocateur), charges arcaniques (mage)
--   (10, 4) : R = classe / 255 (identifiant du jeu : 7 = chaman)
--   (11, 13) : R = le joueur se déplace (1/0), G = la cible incante (1/0), B = son sort est interruptible (1/0)
--   (12, 13) : sort incanté par la cible sur 24 bits (0 si aucun, ou si l'identifiant est secret)
--   (9, 13) : sort en cours d'incantation ou de canalisation sur 24 bits, 0 = aucun
--   (10, 13) : R = temps restant de l'incantation / 10 s (valeur secrète, passée par une courbe), G = canalisation (1/0)
--   (13, 4) : garde-fous, R = joueur mort (1/0), G = cible marquée par un autre joueur (1/0), B = sur une monture (1/0)
--   (11, 4) : spécialisation active sur 16 bits, R = octet fort, G = octet faible (identifiant du jeu : 262 = Élémentaire)
--   (5, 1) : résultat du dernier lancer de pêche (voir fishing.lua)
--   (8, 1) : ramassage du butin (voir loot.lua), R = mode ramassage, G = cible morte avec du butin
--   (7, 1) : R = un sort vient d'être refusé parce que la cible n'est pas devant le joueur (moins de 1,5 s), pour que
--       le Java fasse demi-tour (monstre dans le dos)
--   (6, 1) : identifiant de la cible sur 24 bits, tiré de la fin de son GUID (0 = pas de cible, ou GUID illisible) : le
--       Java reconnaît une cible déjà vue (DoT répartis entre plusieurs ennemis)
--   (4, 1) : enchantement temporaire de la main droite (leurre sur la canne à pêche...), R = actif (1/0),
--       G = temps restant / 30 min
--
-- Les noms des sorts ne passent pas par l'addon : le Java les lit dans les tables du jeu (wago.tools).

Clockwork.QR_VERSION = 4

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
local WEAPON_ENCHANT_HORIZON = 30 * 60 -- secondes encodées pour un enchantement temporaire de l'arme
-- Ressource de classe publiée en (9, 4) (points de combo par défaut : voleur, druide)
local CLASS_RESOURCES = {
    WARLOCK = Enum.PowerType.SoulShards,
    PALADIN = Enum.PowerType.HolyPower,
    MONK = Enum.PowerType.Chi,
    EVOKER = Enum.PowerType.Essence,
    MAGE = Enum.PowerType.ArcaneCharges,
}
local FACING_ERROR_DELAY = 1.5 -- secondes pendant lesquelles un refus « cible pas devant vous » est publié
local ITEM_FLAG = 8388608 -- bit 23 de la case du sort : la touche porte un objet (identifiant de sort toujours inférieur)

-- Dernier lancement par sort : { time = GetTime(), guid = cible au moment du lancement }
Clockwork.lastCasts = {}
-- Derniers lancements par cible : castsByTarget[guid][spellID] = GetTime(), pour retrouver ses DoT en revenant sur une
-- cible (répartition des DoT entre plusieurs ennemis) ; purgé au-delà de HORIZON
Clockwork.castsByTarget = {}

local cooldownCurve
local castCurve
local CAST_HORIZON = 10 -- secondes encodées pour le temps restant d'une incantation

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
    block:SetFrameStrata("TOOLTIP")
    block:SetFrameLevel(2)
    block.texture = block:CreateTexture(nil, "BACKGROUND")
    block.texture:SetAllPoints()
    block.texture:SetColorTexture(0, 1, 0, 1)
    for _, size in ipairs({ { 14, 14 }, { 16, 8 }, { 8, 16 } }) do
        local black = CreateFrame("FRAME", nil, block)
        black:SetPoint("CENTER", 0, 0)
        black:SetSize(size[1], size[2])
        black:SetFrameStrata("TOOLTIP")
        black:SetFrameLevel(3)
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
    self.shapeshiftForm = self:createDot("shapeshiftForm", 8, -4)
    self.comboPoints = self:createDot("comboPoints", 9, -4)
    self.playerClass = self:createDot("playerClass", 10, -4)
    self.playerSpec = self:createDot("playerSpec", 11, -4)
    self.safety = self:createDot("safety", 13, -4)
    self.castSpell = self:createDot("castSpell", 9, -13)
    self.castInfo = self:createDot("castInfo", 10, -13)
    self.moving = self:createDot("moving", 11, -13)
    self.targetCastSpell = self:createDot("targetCastSpell", 12, -13)
    self.qrVersion = self:createDot("qrVersion", 8, -13)
    self.weaponEnchant = self:createDot("weaponEnchant", 4, -1)
    self.targetId = self:createDot("targetId", 6, -1)
    self.notFacing = self:createDot("notFacing", 7, -1)
    self.qrVersion.texture:SetColorTexture(Clockwork.QR_VERSION / 255, 0, 0, 1)
    self:initGroupCells()
    self:initFishingCell()
    self:initLootCell()
end

--- Enregistre un lancement réussi du joueur, sous l'identifiant du sort et sous celui de sa forme de base
--- (le bouton contient la forme de base, ex. 188389 pour la variante 470411).
function Clockwork.recordOwnCast(spellID)
    if not spellID or issecretvalue and issecretvalue(spellID) then return end
    local entry = { time = GetTime(), guid = UnitGUID("target") }
    Clockwork.lastCasts[spellID] = entry
    local base = C_Spell.GetBaseSpell and C_Spell.GetBaseSpell(spellID)
    if base and base ~= spellID then Clockwork.lastCasts[base] = entry end
    -- Par cible : le GUID peut être secret (identités restreintes), il ne sert alors pas de clé
    pcall(function()
        if not entry.guid then return end
        local casts = Clockwork.castsByTarget[entry.guid] or {}
        Clockwork.castsByTarget[entry.guid] = casts
        casts[spellID] = entry.time
        if base then casts[base] = entry.time end
    end)
end

--- Dernier lancement du sort sur la cible actuelle (même après être passé sur d'autres cibles), ou nil.
local function castOnTarget(spellID)
    local ok, time = pcall(function()
        local guid = UnitGUID("target")
        local casts = guid and Clockwork.castsByTarget[guid]
        return casts and casts[spellID]
    end)
    if ok and time then return { time = time } end
    return nil
end

--- Oublie les lancements de plus de HORIZON secondes (cibles mortes ou quittées).
local function pruneCastsByTarget()
    local now = GetTime()
    for guid, casts in pairs(Clockwork.castsByTarget) do
        local recent = false
        for spellID, time in pairs(casts) do
            if now - time > HORIZON then casts[spellID] = nil else recent = true end
        end
        if not recent then Clockwork.castsByTarget[guid] = nil end
    end
end

--- Identifiant de la cible sur 24 bits : les 6 derniers chiffres hexadécimaux de son GUID (numéro d'apparition du
--- monstre, propre à chaque exemplaire). 0 sans cible ou si le GUID est illisible.
local function targetId()
    local ok, id = pcall(function()
        local guid = UnitGUID("target")
        local suffix = guid and guid:match("(%x+)$")
        return suffix and tonumber(suffix:sub(-6), 16) or 0
    end)
    return ok and id or 0
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

--- Sort lancé par l'utilisation d'un objet (potion, leurre...), ou nil.
local function itemSpell(itemID)
    local ok, _, spellID = pcall(C_Item.GetItemSpell, itemID)
    if ok then return spellID end
    return nil
end

--- Contenu d'une touche : sort, ou objet et le sort de son utilisation, et emplacement de barre ; nil sans emplacement.
--- Une macro vaut le sort ou l'objet qu'elle affiche (sous-type de GetActionInfo).
--- @return number|nil spellID, number|nil slot, number|nil itemID
function Clockwork:actionForKey(key)
    local slot = self.keySlotMap and self.keySlotMap[key]
    if not slot then return nil end
    local actionType, id, subType = GetActionInfo(slot)
    if actionType == "macro" then actionType = subType end
    if actionType == "spell" then return id, slot end
    if actionType == "item" and id then return itemSpell(id), slot, id end
    return nil, slot
end

--- Sort et emplacement de barre associés à une touche, ou nil (sort seulement : pas les objets).
function Clockwork:spellForKey(key)
    local spellID, slot, itemID = self:actionForKey(key)
    if itemID then return nil, slot end
    return spellID, slot
end

local function elapsedRatio(entry)
    if not entry then return 1 end
    return math.min((GetTime() - entry.time) / HORIZON, 1)
end

--- Incantation de la cible, pour les interruptions (événements de la cible). Interruptible sauf indication contraire :
--- l'information peut être secrète, et tenter d'interrompre un sort qui ne l'est pas échoue sans conséquence.
function Clockwork.recordTargetCast(spellID)
    local notInterruptible = false
    pcall(function()
        local flag = select(8, UnitCastingInfo("target"))
        if flag == nil then flag = select(7, UnitChannelInfo("target")) end
        notInterruptible = flag == true
    end)
    Clockwork.targetCast = { spellID = spellID, interruptible = not notInterruptible }
end

--- Nouvelle cible : elle incante peut-être déjà (événement de début manqué).
function Clockwork.recordTargetChanged()
    Clockwork.targetCast = nil
    pcall(function()
        local name, _, _, _, _, _, _, _, spellID = UnitCastingInfo("target")
        if name == nil then name, _, _, _, _, _, _, spellID = UnitChannelInfo("target") end
        if name ~= nil then Clockwork.recordTargetCast(spellID) end
    end)
end

function Clockwork.recordTargetInterruptible(unit, interruptible)
    if unit == "target" and Clockwork.targetCast then Clockwork.targetCast.interruptible = interruptible end
end

--- Message d'erreur de l'interface (UI_ERROR_MESSAGE) : sort refusé parce que la cible n'est pas devant le joueur
--- (sort ou attaque en mêlée), résultat d'un lancer de pêche.
function Clockwork.recordUiError(message)
    if message == nil then return end
    if (SPELL_FAILED_UNIT_NOT_INFRONT and message == SPELL_FAILED_UNIT_NOT_INFRONT)
        or (ERR_BADATTACKFACING and message == ERR_BADATTACKFACING) then
        Clockwork.lastFacingError = GetTime()
    end
    Clockwork.recordFishingError(message)
end

--- Le joueur se déplace : vitesse non nulle, sinon (vitesse illisible) changement de position sur la carte.
--- @return boolean
function Clockwork.isMoving()
    local ok, moving = pcall(function() return GetUnitSpeed("player") > 0 end)
    if ok then return moving end
    return Clockwork.player.isMoving == true
end

--- Sort à incantation alors que le joueur se déplace : WoW le refuserait (comme actionCanBeCast pour les rotations Lua).
--- Temps d'incantation actuel (procs compris) ; s'il est illisible, le sort n'est pas bloqué.
--- @return boolean
local function blockedByMovement(spellID)
    if not spellID or not Clockwork.isMoving() then return false end
    local ok, castTime = pcall(function() return C_Spell.GetSpellInfo(spellID).castTime > 0 end)
    return ok and castTime == true
end

-- Buffs du joueur par sort, lus hors combat (les auras sont inaccessibles en combat en 12.x) : en combat, dernier état connu
Clockwork.playerBuffs = {}

--- L'aura du sort est active sur le joueur (Cri de guerre, Bouclier de foudre...).
--- @return boolean
local function buffActive(spellID)
    if not spellID then return false end
    if not UnitAffectingCombat("player") then
        local ok, aura = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
        if ok then Clockwork.playerBuffs[spellID] = aura ~= nil end
    end
    return Clockwork.playerBuffs[spellID] == true
end

function Clockwork:updateKeyState(key)
    local spellID, slot, itemID = self:actionForKey(key)
    setColor24(self.keySpell[key].texture, itemID and ITEM_FLAG + itemID or spellID or 0)
    if not slot then
        self.keyState[key].texture:SetColorTexture(0, 0, 0, 1)
        self.keyHistory[key].texture:SetColorTexture(1, 0, 1, 1)
        return
    end

    -- Temps de recharge : valeur secrète en combat, transmise telle quelle à la texture
    local remaining = 0
    local duration = C_ActionBar.GetActionCooldownDuration and C_ActionBar.GetActionCooldownDuration(slot)
    if duration then remaining = duration:EvaluateRemainingDuration(curve()) end

    local usable = 0
    if IsUsableAction(slot) then usable = blockedByMovement(spellID) and 0.5 or 1 end
    local inRange = IsActionInRange(slot)
    local range = inRange == nil and 0.5 or (inRange and 1 or 0)
    self.keyState[key].texture:SetColorTexture(remaining, usable, range, 1)

    local entry = spellID and Clockwork.lastCasts[spellID]
    if itemID then
        -- Objet : nombre possédé (charges comprises) à la place du temps sur la cible ; pas de proc
        local count = C_Item.GetItemCount(itemID, false, true) or 0
        local buff = buffActive(spellID) and 2 / 3 or 0
        self.keyHistory[key].texture:SetColorTexture(math.min(count, 255) / 255, buff, elapsedRatio(entry), 1)
        return
    end
    local onTarget = spellID and castOnTarget(spellID)
    local proc = spellID and C_SpellActivationOverlay and C_SpellActivationOverlay.IsSpellOverlayed(spellID) and 1 or 0
    local buff = buffActive(spellID) and 1 or 0
    self.keyHistory[key].texture:SetColorTexture(elapsedRatio(onTarget), (proc + 2 * buff) / 3, elapsedRatio(entry), 1)
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
        self.flags.texture:SetColorTexture(Clockwork.AGGRO_MOD and 1 or 0, UnitAffectingCombat("target") and 1 or 0,
            Clockwork.MULTI_MOD and 1 or 0, 1)
    end)

    Clockwork.guard("shapeshiftForm", function()
        -- Le sort de la forme plutôt que son index : l'index dépend des talents, le sort non
        local index = GetShapeshiftForm() or 0
        local spellID = index > 0 and select(4, GetShapeshiftFormInfo(index)) or 0
        setColor24(self.shapeshiftForm.texture, spellID or 0)
    end)

    Clockwork.guard("comboPoints", function()
        local _, classFile = UnitClass("player")
        local powerType = CLASS_RESOURCES[classFile] or Enum.PowerType.ComboPoints
        self.comboPoints.texture:SetColorTexture(UnitPower("player", powerType) / 255, 0, 0, 1)
    end)

    Clockwork.guard("moving", function()
        local targetCast = Clockwork.targetCast
        self.moving.texture:SetColorTexture(Clockwork.isMoving() and 1 or 0, targetCast and 1 or 0,
            (targetCast and targetCast.interruptible) and 1 or 0, 1)
        -- L'identifiant du sort de la cible peut être secret : le calcul sur 24 bits échoue alors, et vaut 0
        if not (targetCast and pcall(setColor24, self.targetCastSpell.texture, targetCast.spellID)) then
            setColor24(self.targetCastSpell.texture, 0)
        end
    end)

    Clockwork.guard("cast", function()
        -- Sort en cours (événements de début d'incantation) et temps restant : l'objet durée est secret, il passe par
        -- une courbe comme les temps de recharge
        local cast = Clockwork.currentCast
        setColor24(self.castSpell.texture, cast and cast.spellID or 0)
        if not cast then
            self.castInfo.texture:SetColorTexture(0, 0, 0, 1)
            return
        end
        if not castCurve then
            castCurve = C_CurveUtil.CreateCurve()
            castCurve:AddPoint(0, 0)
            castCurve:AddPoint(CAST_HORIZON, 1)
        end
        -- L'objet durée peut être secret : on ne le teste pas, on le transmet ; s'il manque, l'appel échoue et vaut 0
        -- (pas de and/or sur une valeur secrète : seul if teste notre propre booléen)
        local ok, remaining = pcall(function()
            local duration
            if cast.channel then duration = UnitChannelDuration("player") else duration = UnitCastingDuration("player") end
            return duration:EvaluateRemainingDuration(castCurve)
        end)
        local channel = cast.channel and 1 or 0
        if ok then
            self.castInfo.texture:SetColorTexture(remaining, channel, 0, 1)
        else
            self.castInfo.texture:SetColorTexture(0, channel, 0, 1)
        end
    end)

    Clockwork.guard("safety", function()
        -- Le Java n'agit pas mort, en monture, ni contre une cible déjà marquée par un autre joueur (comme rotation())
        local dead = UnitIsDeadOrGhost("player") and 1 or 0
        local tapDenied = UnitExists("target") and UnitIsTapDenied("target") and 1 or 0
        local mounted = IsMounted() and 1 or 0
        self.safety.texture:SetColorTexture(dead, tapDenied, mounted, 1)
    end)

    Clockwork.guard("classAndSpec", function()
        -- Le Java choisit la rotation de la classe et de la spécialisation du personnage
        local classID = select(3, UnitClass("player")) or 0
        local index = GetSpecialization and GetSpecialization()
        local specID = index and GetSpecializationInfo(index) or 0
        self.playerClass.texture:SetColorTexture(classID / 255, 0, 0, 1)
        self.playerSpec.texture:SetColorTexture(math.floor(specID / 256) / 255, (specID % 256) / 255, 0, 1)
    end)

    Clockwork.guard("facing", function()
        local facing = GetPlayerFacing() or 0
        local value = math.floor(facing / (2 * math.pi) * 65535 + 0.5)
        self.facing.texture:SetColorTexture(math.floor(value / 256) / 255, (value % 256) / 255, 0, 1)
    end)

    self:updateGroupCells()

    Clockwork.guard("loot", function() self:updateLootCell() end)

    Clockwork.guard("notFacing", function()
        local recent = Clockwork.lastFacingError and GetTime() - Clockwork.lastFacingError < FACING_ERROR_DELAY
        self.notFacing.texture:SetColorTexture(recent and 1 or 0, 0, 0, 1)
    end)

    Clockwork.guard("targetId", function()
        setColor24(self.targetId.texture, targetId())
        pruneCastsByTarget()
    end)

    Clockwork.guard("weaponEnchant", function()
        local active, expiration = GetWeaponEnchantInfo()
        if active then
            self.weaponEnchant.texture:SetColorTexture(1, math.min((expiration or 0) / 1000 / WEAPON_ENCHANT_HORIZON, 1), 0, 1)
        else
            self.weaponEnchant.texture:SetColorTexture(0, 0, 0, 1)
        end
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
