-- Rotation assistée : suit la recommandation de Blizzard (C_AssistedCombat, système « Assisted Combat » de la 11.1.7).
-- En 12.x, les auras et les temps de recharge sont secrets pour les addons, mais le sort recommandé ne l'est pas :
-- Blizzard le calcule en tenant compte des auras, des procs et des temps de recharge.
--
-- Elle tourne en plus de la rotation écrite à la main : chaque rotation allume la touche de son sort avec une priorité,
-- le Java appuie sur la plus haute. Une règle écrite plus prioritaire (buff, exécution...) l'emporte ; la rotation de
-- base (priorité 1) passe derrière la recommandation.

Clockwork.ASSISTED_ENABLED = true
Clockwork.ASSISTED_PRIORITY = 50

--- Allume la touche du sort recommandé par Blizzard, s'il est sur une barre d'action, utilisable et à portée.
--- @return nil
function Clockwork:assistedRotation()
    if not Clockwork.ASSISTED_ENABLED then return end
    if not (C_AssistedCombat and C_AssistedCombat.IsAvailable and C_AssistedCombat.IsAvailable()) then return end
    if not Clockwork.unitExistCanAndShouldDie() then return end

    local spellID = C_AssistedCombat.GetNextCastSpell()
    if not spellID then return end

    self:castSpellIfPossible({
        spell = { id = spellID },
        priority = Clockwork.ASSISTED_PRIORITY,
    })
end

function Clockwork:clickAssisted()
    Clockwork.ASSISTED_ENABLED = not Clockwork.ASSISTED_ENABLED
    Clockwork.log.notice("Rotation assistée : " .. (Clockwork.ASSISTED_ENABLED and "On" or "Off"))
end
