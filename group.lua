-- Groupe et raid (grille v4) : une case par membre dans le bloc 2, le mode soigneur, et le ciblage des membres.
--
-- Membres : emplacement 1..40. En raid, emplacement n = raidN ; sinon (groupe ou seul), 1 = le joueur, 2..5 = party1..4.
-- Cases (bloc 2, décalé de (16, 0)) : membres 1..14 en ligne 1 (x 1..14), 15..28 en ligne 4, 29..40 en ligne 5 (x 1..12).
--   R = vie en % (valeur secrète, transmise telle quelle), G = à portée de soin (1), hors de portée (0), inconnu (0,5)
--   B = drapeaux / 255 : 1 existe, 2 mort, 4 déconnecté, 8 c'est le joueur, rôle en 16 x (0 aucun, 1 tank, 2 soigneur, 3 dégâts)
-- (3, 1) du bloc 1 (ancien bord des PV du groupe, libéré) : R = mode soigneur, G = en raid.
--
-- Ciblage : TargetUnit est protégé, le Java appuie donc sur des raccourcis reliés à des boutons sécurisés
-- (SecureActionButtonTemplate, type target) : membres 1..20 sur Alt+Maj+A..T, 21..40 sur Alt+Ctrl+A..T, et
-- Alt+Maj+U pour revenir à la cible précédente (/targetlasttarget). Les raccourcis sont des surcharges (non
-- enregistrées dans la configuration du joueur) ; boutons et raccourcis ne se modifient que hors combat.

Clockwork.HEALER_MOD = false

local MEMBERS = 40
local TARGET_KEYS = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T" }
local LAST_TARGET_KEY = "ALT-SHIFT-U"
local ROLE_CODES = { TANK = 1, HEALER = 2, DAMAGER = 3 }

--- Case d'un membre dans le bloc 2 (coordonnées de createDot).
local function memberCell(slot)
    if slot <= 14 then return 16 + slot, -1 end
    if slot <= 28 then return 16 + slot - 14, -4 end
    return 16 + slot - 28, -5
end

--- Unité de l'emplacement : raidN en raid, sinon le joueur puis party1..4.
function Clockwork.memberUnit(slot)
    if IsInRaid() then return "raid" .. slot end
    if slot == 1 then return "player" end
    if slot <= 5 then return "party" .. (slot - 1) end
    return nil
end

--- Raccourci qui cible l'emplacement, identique côté Java (GroupTargeting).
function Clockwork.memberTargetKey(slot)
    if slot <= 20 then return "ALT-SHIFT-" .. TARGET_KEYS[slot] end
    return "ALT-CTRL-" .. TARGET_KEYS[slot - 20]
end

function Clockwork:initGroupCells()
    self.members = {}
    for slot = 1, MEMBERS do
        self.members[slot] = self:createDot("member" .. slot, memberCell(slot))
    end
    self.healerMode = self:createDot("healerMode", 3, -1)
end

--- L'unité est le joueur (UnitIsUnit peut être secret : un if l'accepte, un échec vaut non).
function Clockwork.isPlayerUnit(unit)
    if unit == "player" then return true end
    local ok, same = pcall(function()
        if UnitIsUnit(unit, "player") then return true end
        return false
    end)
    return ok and same
end

--- Drapeaux d'un membre (aucune valeur secrète : existence, mort, connexion, rôle).
local function memberFlags(unit)
    local flags = 1
    if UnitIsDeadOrGhost(unit) then flags = flags + 2 end
    if not UnitIsConnected(unit) then flags = flags + 4 end
    if Clockwork.isPlayerUnit(unit) then flags = flags + 8 end
    -- Le rôle peut devenir secret (identités restreintes, JcJ) : il ne sert alors pas de clé de table, on l'ignore
    local ok, code = pcall(function() return ROLE_CODES[UnitGroupRolesAssigned(unit)] end)
    return flags + 16 * (ok and code or 0)
end

--- À portée de soin : UnitInRange est secret mais un if l'accepte. Le joueur est toujours à portée de lui-même.
local function memberRange(unit)
    if Clockwork.isPlayerUnit(unit) then return 1 end
    local ok, range = pcall(function()
        if UnitInRange(unit) then return 1 end
        return 0
    end)
    if ok then return range end
    return 0.5
end

function Clockwork:updateGroupCells()
    for slot = 1, MEMBERS do
        Clockwork.guard("member", function()
            local unit = Clockwork.memberUnit(slot)
            local texture = self.members[slot].texture
            if not unit or not UnitExists(unit) then
                texture:SetColorTexture(0, 0, 0, 1)
                return
            end
            local flags = memberFlags(unit)
            local range = memberRange(unit)
            if UnitIsDeadOrGhost(unit) then
                texture:SetColorTexture(0, range, flags / 255, 1)
            else
                texture:SetColorTexture(Clockwork.healthRatio(unit), range, flags / 255, 1)
            end
        end)
    end
    self.healerMode.texture:SetColorTexture(Clockwork.HEALER_MOD and 1 or 0, IsInRaid() and 1 or 0, 0, 1)
end

--- Mode soigneur : le cerveau Java soigne aussi les autres membres. Allumé d'office pour une spécialisation de soin.
function Clockwork:clickHealer()
    Clockwork.HEALER_MOD = not Clockwork.HEALER_MOD
    Clockwork.log.notice("Mode soigneur : " .. (Clockwork.HEALER_MOD and "On" or "Off"))
end

--- Spécialisation chargée ou changée : mode soigneur selon son rôle. Seulement quand la spécialisation change (pas à
--- chaque écran de chargement), pour garder un choix fait à la main.
local roleAppliedForSpec
function Clockwork.applySpecRole()
    local index = GetSpecialization and GetSpecialization()
    local role = index and GetSpecializationRole(index)
    if role == nil or index == roleAppliedForSpec then return end
    roleAppliedForSpec = index
    local healer = role == "HEALER"
    if healer ~= Clockwork.HEALER_MOD then Clockwork:clickHealer() end
end

--[[---------------------------------------------------------------------------
Boutons sécurisés de ciblage
---------------------------------------------------------------------------]]--

local bindingOwner = CreateFrame("Frame", "ClockworkTargetBindings")
local targetButtons = {}
local pendingSecureUpdate = false

local function secureButton(name)
    local button = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate")
    button:RegisterForClicks("AnyDown", "AnyUp")
    -- Une seule action, à l'appui (sinon le clic part à l'appui ou au relâchement selon ActionButtonUseKeyDown)
    button:SetAttribute("useOnKeyDown", true)
    return button
end

--- Unités des boutons et raccourcis : hors combat seulement, sinon reporté à la sortie du combat.
function Clockwork.updateSecureTargeting()
    if InCombatLockdown() then
        pendingSecureUpdate = true
        return
    end
    pendingSecureUpdate = false

    if #targetButtons == 0 then
        for slot = 1, MEMBERS do
            local button = secureButton("ClockworkTarget" .. slot)
            button:SetAttribute("type", "target")
            targetButtons[slot] = button
        end
        local last = secureButton("ClockworkTargetLast")
        last:SetAttribute("type", "macro")
        last:SetAttribute("macrotext", "/targetlasttarget")
    end

    ClearOverrideBindings(bindingOwner)
    for slot = 1, MEMBERS do
        -- Pas d'unité (emplacement vide) : le bouton ne fait rien ("none" effacerait la cible)
        targetButtons[slot]:SetAttribute("unit", Clockwork.memberUnit(slot))
        SetOverrideBindingClick(bindingOwner, true, Clockwork.memberTargetKey(slot), "ClockworkTarget" .. slot, "LeftButton")
    end
    SetOverrideBindingClick(bindingOwner, true, LAST_TARGET_KEY, "ClockworkTargetLast", "LeftButton")
end

--- Sortie du combat : applique une mise à jour reportée (composition du groupe changée en combat).
function Clockwork.applyPendingSecureTargeting()
    if pendingSecureUpdate then Clockwork.updateSecureTargeting() end
end
