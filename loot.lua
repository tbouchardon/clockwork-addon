-- Ramassage du butin après un combat, piloté par le Java (mode « Ramassage » du menu, désactivé par défaut).
--
-- Case (8, 1) du bloc 1 : R = mode ramassage, G = la cible est un cadavre qui a du butin pour le joueur (CanLootUnit).
-- Le Java appuie alors sur Alt+Maj+L, posé en surcharge sur « Interagir avec la cible » (INTERACTTARGET, bindings.lua).
-- Pour que le personnage marche jusqu'au cadavre, le déplacement par clic (CVar autointeract) est activé le temps du
-- ramassage, puis le réglage du joueur est rétabli (hors ramassage, en combat, à la connexion).

Clockwork.LOOT_MOD = false

local savedAutoInteract -- réglage du joueur, tant que le ramassage l'a modifié

function Clockwork:initLootCell()
    self.lootCell = self:createDot("loot", 8, -1)
end

--- La cible est un cadavre avec du butin pour le joueur.
function Clockwork.targetLootable()
    if not UnitExists("target") or not UnitIsDead("target") then return false end
    local ok, hasLoot, canLoot = pcall(CanLootUnit, UnitGUID("target"))
    return ok and hasLoot == true and canLoot == true
end

--- Active ou rétablit le déplacement par clic : actif seulement pendant un ramassage possible, hors combat.
local function updateAutoInteract(looting)
    if InCombatLockdown() then return end
    local settings = CLOCKWORK_SETTINGS or {}
    if looting then
        if settings.savedAutoInteract == nil then
            settings.savedAutoInteract = GetCVar("autointeract")
            CLOCKWORK_SETTINGS = settings
        end
        if GetCVar("autointeract") ~= "1" then SetCVar("autointeract", "1") end
    elseif settings.savedAutoInteract ~= nil then
        SetCVar("autointeract", settings.savedAutoInteract)
        settings.savedAutoInteract = nil
    end
end

function Clockwork:updateLootCell()
    local lootable = Clockwork.LOOT_MOD and not UnitAffectingCombat("player") and Clockwork.targetLootable()
    updateAutoInteract(lootable)
    self.lootCell.texture:SetColorTexture(Clockwork.LOOT_MOD and 1 or 0, lootable and 1 or 0, 0, 1)
end

--- Connexion : rétablit un réglage resté modifié (jeu quitté pendant un ramassage).
function Clockwork.restoreAutoInteract()
    updateAutoInteract(false)
end

function Clockwork:clickLoot()
    Clockwork.LOOT_MOD = not Clockwork.LOOT_MOD
    if not Clockwork.LOOT_MOD then updateAutoInteract(false) end
    Clockwork.log.notice("Ramassage : " .. (Clockwork.LOOT_MOD and "On" or "Off"))
end
