--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial()        -- no Sp
end
local function initialActions() -- no Sp
end

---------------------------------------------------------------------------------------------------
local function affliction()
    if (Clockwork.unitExistCanAndShouldDie() and not Clockwork.isCasting()) then
        local hasDebuff, hasAnyDebuff, remainingTime

        hasDebuff, remainingTime = Clockwork.targetHasDebuff(Clockwork.Enum.Spell.Warlock.AFFLICTION_INSTABLE_316099.name)
        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warlock.AFFLICTION_INSTABLE_316099,
            condition = not hasDebuff,
            priority = 100
        })

        hasDebuff, remainingTime = Clockwork.targetHasDebuff(Clockwork.Enum.Spell.Warlock.AGONIE_980.name)
        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warlock.AGONIE_980,
            condition = not hasDebuff or remainingTime < 4,
            priority = 90
        })

        hasDebuff, remainingTime = Clockwork.targetHasDebuff(Clockwork.Enum.Spell.Warlock.CORRUPTION_172.name)
        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warlock.CORRUPTION_172,
            condition = not hasDebuff or remainingTime < 2,
            priority = 85
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warlock.TRAIT_DE_L_OMBRE_686
        })
    end
end
local function afflictionActions()
    --    Clockwork.dropSpellInShortcut(Clockwork.Enum.Spell.Warlock.AGONIE_980, { key = 5 })
    --    Clockwork.dropSpellInShortcut(Clockwork.Enum.Spell.Warlock.CORRUPTION_172, { key = 4 })
    --    Clockwork.dropSpellInShortcut(Clockwork.Enum.Spell.Warlock.TRAIT_DE_L_OMBRE_686, { key = 1 })
end

---------------------------------------------------------------------------------------------------
local function demonology()
end
local function demonologyActions()
end

---------------------------------------------------------------------------------------------------
local function destruction()
    if (Clockwork.unitExistCanAndShouldDie() and not Clockwork.isCasting()) then
        local hasDebuff, hasAnyDebuff, remainingTime

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warlock.CONFLAGRATION_17962,
            priority = 90
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warlock.INCINERER_29722,
            priority = 70
        })

        hasDebuff, remainingTime = Clockwork.targetHasDebuff(Clockwork.Enum.Spell.Warlock.IMMOLATION_348.name)
        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warlock.IMMOLATION_348,
            condition = not hasDebuff or remainingTime < 2,
            priority = 100
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warlock.TRAIT_DU_CHAOS_116858,
            priority = 80
        })
    end
end
local function destructionActions()
    --    Clockwork.dropSpellInShortcut(Clockwork.Enum.Spell.Warlock.AGONIE_980, { key = 5 })
    --    Clockwork.dropSpellInShortcut(Clockwork.Enum.Spell.Warlock.IMMOLATION_348, { key = 4 })
    --    Clockwork.dropSpellInShortcut(Clockwork.Enum.Spell.Warlock.TRAIT_DE_L_OMBRE_686, { key = 1 })
end

Clockwork.rotations[Clockwork.Enum.Specialization.Warlock.Affliction] = affliction
Clockwork.rotations[Clockwork.Enum.Specialization.Warlock.Demonology] = demonology
Clockwork.rotations[Clockwork.Enum.Specialization.Warlock.Destruction] = destruction
Clockwork.rotations[Clockwork.Enum.Specialization.Warlock.Initial] = initial

Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warlock.Affliction] = afflictionActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warlock.Demonology] = demonologyActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warlock.Destruction] = destructionActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warlock.Initial] = initialActions
