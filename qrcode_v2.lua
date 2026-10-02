-- QR code v2 : état des touches et du combat pour que le Java décide lui-même (règles YAML).
-- Tout est lisible en 12.x : les valeurs secrètes (temps de recharge) passent directement à SetColorTexture,
-- les autres sont calculées ici (temps depuis le dernier lancement, à partir de UNIT_SPELLCAST_SUCCEEDED).
--
-- Cases (x, y), couleurs de 0 à 1 :
--   ligne 6, sous chaque touche 1..= (x 2..13) et ligne 12 x 2..7 (Q D R T F G) : état de la touche
--       R = temps de recharge restant / 60 s, G = utilisable (1/0), B = à portée (1), hors de portée (0), sans portée (0,5)
--   ligne 9, sous chaque touche 1..= (x 2..13) et ligne 12 x 8..13 (Q D R T F G) : historique du sort de la touche
--       R = temps depuis le dernier lancement sur la cible actuelle / 60 s (1 = jamais ou plus de 60 s)
--       G = proc (bouton en surbrillance), B = temps depuis le dernier lancement, toutes cibles / 60 s
--   (6, 2) : touche recommandée par Blizzard, R = indice dans KEY_ORDER / 255 (0 = aucune)
--   (7, 2) : direction du personnage sur 16 bits, R = octet fort, G = octet faible (0..65535 pour 0..2π)
--   (2, 3) : nombre d'ennemis en combat (barres de vie), R = nombre / 255
--   (8, 13) : version de la grille, R = 2 / 255

Clockwork.QR_VERSION = 2

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

function Clockwork:initQrCodeV2()
    self.keyState = {}
    self.keyHistory = {}
    for index, key in ipairs(NUMBER_KEYS) do
        self.keyState[key] = self:createDot("keyState_" .. key, index + 1, -6)
        self.keyHistory[key] = self:createDot("keyHistory_" .. key, index + 1, -9)
    end
    for index, key in ipairs(LETTER_KEYS) do
        self.keyState[key] = self:createDot("keyState_" .. key, index + 1, -12)
        self.keyHistory[key] = self:createDot("keyHistory_" .. key, index + 7, -12)
    end
    self.recommendedKey = self:createDot("recommendedKey", 6, -2)
    self.facing = self:createDot("facing", 7, -2)
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

--- Table touche (sans modificateur) -> emplacement de barre, reconstruite à chaque mise à jour
--- (les barres changent avec les formes, les pages, les talents).
function Clockwork:buildKeySlotMap()
    local map = {}
    if not self.commandBindingMap then return map end
    for slot = 1, 180 do
        local command = Clockwork.getActionSlotCommand(slot)
        local binding = command and self.commandBindingMap[command]
        if binding and not binding.shift and not binding.alt and not binding.ctrl and HasAction(slot)
            and map[binding.key] == nil then
            map[binding.key] = slot
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

    for _, key in ipairs(Clockwork.KEY_ORDER) do
        Clockwork.guard("key " .. key, function() self:updateKeyState(key) end)
    end

    Clockwork.guard("recommendedKey", function()
        local index = 0
        local spellID = C_AssistedCombat and C_AssistedCombat.GetNextCastSpell and C_AssistedCombat.GetNextCastSpell()
        if spellID then
            local action = self:getActionSlotAndBindingForSpell(spellID)
            if action and not action.shift and not action.alt and not action.ctrl then
                for position, key in ipairs(Clockwork.KEY_ORDER) do
                    if key == action.key then index = position end
                end
            end
        end
        self.recommendedKey.texture:SetColorTexture(index / 255, 0, 0, 1)
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
