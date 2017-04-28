--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

function ksuto.shamanHealRotation()

    --    ksuto.printDebug("function ksuto.shamanHealRotation")

    ksuto.updatePositionCoordinates()

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff("for debug purpose") end

    if (ksuto.targetMemberIfHealthLessThan(60)) then

        ksuto.shouldHitKey(ksuto.key9, nil, 65)

    elseif (ksuto.unitExistCanAndShouldDie()) and not (ksuto.enemyPlayer()) then

        ksuto.shouldHitKey(ksuto.key9, ksuto.playerHealthPct() < 60, 65) -- je me soigne (barre d'action bas gauche, 5e icone)
        ksuto.shouldHitKey(ksuto.key8, not ksuto.playerHasBuff("Lightning Shield") and ksuto.playerManaPct() > 30, 25) -- bouclier de foudre (tout en haut barre verticale droite)
        ksuto.shouldHitKey(ksuto.key5, not IsCurrentAction(26) and ksuto.targetInRange(ksuto.DUEL), 26) -- activate Attack (juste en dessous du 25)
        ksuto.shouldHitKey(ksuto.key3, ksuto.healthPercentage('target') < 98 and ksuto.healthPercentage('target') > 10 and not ksuto.targetHasDebuff("Flame Shock") and ksuto.playerManaPct() > 20, 3) -- orion de feu
        ksuto.shouldHitKey(ksuto.key1, ksuto.playerManaPct() > 60 and ksuto.healthPercentage('target') > 50, 1) -- chaine éclaire

    else

        ksuto.resetKeys()
        ksuto.shouldHitKey(ksuto.key0, ksuto.playerManaPct() < 30 and not ksuto.playerHasBuff("Drink"), 54) -- regen (barre en bas à droite 6e icone)
    end
end
