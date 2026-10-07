-- Ramassage du butin après un combat, piloté par le Java (mode « Ramassage » du menu, désactivé par défaut).
--
-- La cible morte ne reste pas forcément ciblée (elle disparaît souvent à sa mort, avant que son butin soit prêt) : l'addon
-- retient l'identifiant (GUID) des derniers ennemis ciblés, et CanLootUnit dit, même sans les cibler, si l'un d'eux est
-- un cadavre avec du butin pour le joueur.
--
-- Case (8, 1) du bloc 1 : R = mode ramassage, G = un ennemi récent a du butin, B = touche d'interaction de WoW active
-- (option « Activer la touche d'interaction », CVar softTargetInteract). Le Java appuie alors sur place sur Alt+Maj+X,
-- posé en surcharge sur INTERACTTARGET (bindings.lua) : sans cible, c'est la touche d'interaction, qui agit sur le
-- cadavre à portée devant le personnage. Aucun réglage du joueur n'est modifié.

Clockwork.LOOT_MOD = false

local REMEMBERED = 60 -- secondes pendant lesquelles un ennemi ciblé est retenu
local recentEnemies = {} -- GUID -> GetTime() du dernier moment où il était ciblé

function Clockwork:initLootCell()
    self.lootCell = self:createDot("loot", 8, -1)
end

--- Retient la cible si c'est un ennemi (le GUID peut être secret en JcJ : il ne sert alors pas de clé).
local function rememberTarget()
    pcall(function()
        if UnitExists("target") and UnitCanAttack("player", "target") then
            local guid = UnitGUID("target")
            if guid then recentEnemies[guid] = GetTime() end
        end
    end)
end

--- Un ennemi ciblé récemment est un cadavre avec du butin pour le joueur ; oublie les plus anciens.
function Clockwork.recentEnemyLootable()
    local now, lootable = GetTime(), false
    for guid, seen in pairs(recentEnemies) do
        if now - seen > REMEMBERED then
            recentEnemies[guid] = nil
        else
            local ok, hasLoot, canLoot = pcall(CanLootUnit, guid)
            if ok and hasLoot and canLoot then lootable = true end
        end
    end
    return lootable
end

--- Touche d'interaction de WoW active : sans elle, Interagir avec la cible ne fait rien quand il n'y a pas de cible.
local function interactKeyEnabled()
    return tonumber(GetCVar("softTargetInteract")) == Enum.SoftTargetEnableFlags.Any
end

function Clockwork:updateLootCell()
    rememberTarget()
    local lootable = Clockwork.LOOT_MOD and Clockwork.recentEnemyLootable()
    self.lootCell.texture:SetColorTexture(Clockwork.LOOT_MOD and 1 or 0, lootable and 1 or 0, interactKeyEnabled() and 1 or 0, 1)
end

--- Une version précédente activait le déplacement par clic pendant le ramassage, en mémorisant le réglage du joueur :
--- s'il est resté mémorisé, on le rétablit une fois pour toutes.
function Clockwork.restoreLegacyAutoInteract()
    if CLOCKWORK_SETTINGS and CLOCKWORK_SETTINGS.savedAutoInteract ~= nil and not InCombatLockdown() then
        SetCVar("autointeract", CLOCKWORK_SETTINGS.savedAutoInteract)
        CLOCKWORK_SETTINGS.savedAutoInteract = nil
        Clockwork.log.notice("Déplacement par clic rétabli à ton réglage d'origine")
    end
end

function Clockwork:clickLoot()
    Clockwork.LOOT_MOD = not Clockwork.LOOT_MOD
    Clockwork.log.notice("Ramassage : " .. (Clockwork.LOOT_MOD and "On" or "Off"))
    if Clockwork.LOOT_MOD and not interactKeyEnabled() then
        Clockwork.log.notice("Ramassage : cocher « Activer la touche d'interaction » (Options > Contrôles) pour ramasser sans cible")
    end
end
