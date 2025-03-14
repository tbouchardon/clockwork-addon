--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 17/02/2017
-- Time: 11:46
-- To change this template use File | Settings | File Templates.
--

function Clockwork.updateActionButtons()
    local className, classFilename, classID = UnitClass("player")

    if classID == Clockwork.Enum.Class.WARLOCK then
        Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.AGONIE_980, 5)
        Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.CORRUPTION_172, 4)
        Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.IMMOLATION_348, 3)
        Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.TRAIT_DE_L_OMBRE_686, 1)
    elseif classID == Clockwork.Enum.Class.MAGE then
        Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Mage.ECLAIR_DE_GIVRE_116, 1)
    end
end
