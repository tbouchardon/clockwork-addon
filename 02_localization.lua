--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 14/04/2017
-- Time: 14:52
-- To change this template use File | Settings | File Templates.
--
--

BINDING_HEADER_CLOCKWORK = "ClockWork"
BINDING_NAME_TEST_BINDING = "Test Bindings"

function ksuto.createLocalizedText(english, french)

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

function ksuto.initLocalization()

    ksuto.lightningShield = ksuto.createLocalizedText("Lightning Shield", "Bouclier de foudre")
end
