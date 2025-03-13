--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 14/04/2017
-- Time: 14:52
-- To change this template use File | Settings | File Templates.
--
--

BINDING_HEADER_CLOCKWORK = "Clockwork"
BINDING_NAME_TEST_BINDING = "Test Bindings"

function Clockwork.createLocalizedText(english, french)
    local localization;

    -- localization.english = english;
    -- localization.french = french;

    if GetLocale() == "frFR" then
        localization = french;
    else
        localization = english;
    end

    return localization
end

function Clockwork.initLocalization()
    Clockwork.lightningShield = Clockwork.createLocalizedText("Lightning Shield", "Bouclier de foudre")
end

-- https://warcraft.wiki.gg/wiki/API_UnitClass
Clockwork.Enum.Class = {

    WARRIOR = 1,
    PALADIN = 2,
    HUNTER = 3,
    ROGUE = 4,
    PRIEST = 5,
    DEATHKNIGHT = 6,
    SHAMAN = 7,
    MAGE = 8,
    WARLOCK = 9,
    MONK = 10,
    DRUID = 11,
    DEMONHUNTER = 12,
    EVOKER = 13
}
