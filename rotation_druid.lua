--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial() -- no Sp
    if (Clockwork.unitExistCanAndShouldDie() and not Clockwork.isCasting()) then
        local hasDebuff, hasAnyDebuff, remainingTime

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Druid.MORSURE_FEROCE_22568,
            condition = UnitPower("player", Enum.PowerType.ComboPoints) > 2,
            priority = 100
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Druid.LAMBEAU_5221,
            priority = 80
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Druid.MUTILATION_33917,
            priority = 80
        })

        hasDebuff, remainingTime = Clockwork.targetHasDebuff(Clockwork.Enum.Spell.Druid.ECLAT_LUNAIRE_8921.name)
        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Druid.ECLAT_LUNAIRE_8921,
            condition = not hasDebuff or remainingTime < 2,
            priority = 100
        })

        Clockwork:castSpellIfPossible({
            spell = Clockwork.Enum.Spell.Druid.COLERE_5176,
            priority = 80
        })
    end
end
local function initialActions() -- no Sp
end

---------------------------------------------------------------------------------------------------
local function balance()        -- Sp Feu
end
local function balanceActions() -- Sp Feu
end

---------------------------------------------------------------------------------------------------------------------
local function feral()        -- Sp Givre
end
local function feralActions() -- Sp Givre
end

---------------------------------------------------------------------------------------------------------------------
local function restoration()        -- Sp Givre
end
local function restorationActions() -- Sp Givre
end

---------------------------------------------------------------------------------------------------------------------
local function guardian()
end
local function guardianActions()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Balance] = balance
Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Feral] = feral
Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Guardian] = guardian
Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Restoration] = restoration
Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Initial] = initial

Clockwork.rotationsActions[Clockwork.Enum.Specialization.Druid.Balance] = balanceActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Druid.Feral] = feralActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Druid.Guardian] = guardianActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Druid.Restoration] = restorationActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Druid.Initial] = initialActions
