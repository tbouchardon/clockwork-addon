--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial()
    if (Clockwork.unitExistCanAndShouldDie() and not Clockwork.isCasting()) then
        local hasDebuff, hasAnyDebuff, remainingTime

        local stance = GetShapeshiftForm()

        if stance == Clockwork.Enum.Stance.NONE or stance == Clockwork.Enum.Stance.MOONKIN then
            hasDebuff, remainingTime = Clockwork.targetHasDebuff(Clockwork.Enum.Spell.Druid.ECLAT_LUNAIRE_8921.name)
            Clockwork:castSpellIfPossible({
                spell = Clockwork.Enum.Spell.Druid.ECLAT_LUNAIRE_8921,
                condition = not hasDebuff or remainingTime < 2,
                priority = 100
            })

            Clockwork:castSpellIfPossible({
                spell = Clockwork.Enum.Spell.Druid.COLERE_190984,
                priority = 80
            })
        end

        if stance == Clockwork.Enum.Stance.BEAR then
            Clockwork:castSpellIfPossible({
                spell = Clockwork.Enum.Spell.Druid.MUTILATION_33917,
                priority = 80
            })
        end

        if stance == Clockwork.Enum.Stance.CAT then
            Clockwork:castSpellIfPossible({
                spell = Clockwork.Enum.Spell.Druid.LAMBEAU_5221,
                priority = 80
            })

            Clockwork:castSpellIfPossible({
                spell = Clockwork.Enum.Spell.Druid.MORSURE_FEROCE_22568,
                condition = UnitPower("player", Enum.PowerType.ComboPoints) > 2,
                priority = 100
            })
        end
        if stance == Clockwork.Enum.Stance.MOONKIN then end
    end
end

---------------------------------------------------------------------------------------------------
local function balance()
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function feral()
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function restoration()
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function guardian()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Balance] = balance
Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Feral] = feral
Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Guardian] = guardian
Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Restoration] = restoration
Clockwork.rotations[Clockwork.Enum.Specialization.Druid.Initial] = initial
