--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local regen = 53

local function initial() -- no Sp
    if (Clockwork.unitExistCanAndShouldDie() and not Clockwork.isCasting()) then
        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warrior.HEURTOIR_1464,
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warrior.CHARGE_100,
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warrior.HEURT_DE_BOUCLIER_23922,
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warrior.VOLEE_DE_COUPS_6552,
            condition = Clockwork.isUnitCasting("target")
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warrior.IVRESSE_DE_LA_VICTOIRE_34428,
            priority = 100
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Warrior.LANCER_HEROIQUE_57755,
        })
    end
end

---------------------------------------------------------------------------------------------------
local function arms()
end

---------------------------------------------------------------------------------------------------
local function fury()
end

---------------------------------------------------------------------------------------------------
local function protection()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Warrior.Arms] = arms
Clockwork.rotations[Clockwork.Enum.Specialization.Warrior.Fury] = fury
Clockwork.rotations[Clockwork.Enum.Specialization.Warrior.Protection] = protection
Clockwork.rotations[Clockwork.Enum.Specialization.Warrior.Initial] = initial
