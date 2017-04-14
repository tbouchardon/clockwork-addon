--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 14/04/2017
-- Time: 14:52
-- To change this template use File | Settings | File Templates.
--
--

function ksuto.createLocalizedText(english, french)

    local localization;

    localization.english = english;
    localization.french = french;

    function localization.locale()

        if GetLocale() == "frFR" then
            return this.french
        else
            return this.english
        end
    end

    return localization
end

ksuto.lightningShield = ksuto.createLocalizedText("Lightning Shield", "Bouclier de foudre")
