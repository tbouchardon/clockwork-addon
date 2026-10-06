-- Ramassage du butin après un combat, piloté par le Java (mode « Ramassage » du menu, désactivé par défaut).
--
-- Case (8, 1) du bloc 1 : R = mode ramassage, G = la cible est un cadavre qui a du butin pour le joueur (CanLootUnit).
-- Le Java avance alors vers le cadavre (il est devant : le personnage faisait face à sa cible pour la tuer) en appuyant
-- sur Alt+Maj+L, posé en surcharge sur « Interagir avec la cible » (INTERACTTARGET, bindings.lua), jusqu'à ouvrir le
-- butin. Aucun réglage du joueur n'est modifié.

Clockwork.LOOT_MOD = false

function Clockwork:initLootCell()
    self.lootCell = self:createDot("loot", 8, -1)
end

--- La cible est un cadavre avec du butin pour le joueur.
function Clockwork.targetLootable()
    if not UnitExists("target") or not UnitIsDead("target") then return false end
    local ok, hasLoot, canLoot = pcall(CanLootUnit, UnitGUID("target"))
    return ok and hasLoot == true and canLoot == true
end

function Clockwork:updateLootCell()
    local lootable = Clockwork.LOOT_MOD and not UnitAffectingCombat("player") and Clockwork.targetLootable()
    self.lootCell.texture:SetColorTexture(Clockwork.LOOT_MOD and 1 or 0, lootable and 1 or 0, 0, 1)
end

function Clockwork:clickLoot()
    Clockwork.LOOT_MOD = not Clockwork.LOOT_MOD
    Clockwork.log.notice("Ramassage : " .. (Clockwork.LOOT_MOD and "On" or "Off"))
end
