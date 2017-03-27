--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

function ksuto.warriorDefRotation()

    --    ksuto.printDebug("function ksuto.warriorDefRotation")

    ksuto.updatePositionCoordinates()

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff("for debug purpose") end

    if (ksuto.unitExistCanAndShouldDie()) then

        ksuto.shouldHitKey(ksuto.keyH, nil, 13) --, not ksuto.targetInRange(ksuto.DUEL)) -- Arc
        ksuto.shouldHitKey(ksuto.key8, not ksuto.targetHasDebuff("Rend"), 80) -- dot
        --ksuto.shouldHitKey(ksuto.key5, not ksuto.playerHasBuff("buff bouclier")) -- bouclier
        --ksuto.shouldHitKey(ksuto.key4) -- revanche
        ksuto.shouldHitKey(ksuto.key5, ksuto.playerManaPct() > 40, 77) -- frappe héroïque
        --        ksuto.shouldHitKey(ksuto.key4, not ksuto.playerHasBuff("Battle Shout"), 76) -- mon buff /!\ Bug chez @TBO : Une autre action est en cours...
        ksuto.shouldHitKey(ksuto.key1, not IsCurrentAction(73) and ksuto.targetInRange(ksuto.DUEL), 73) -- activate Attack

    else

        ksuto.resetKeys()
        ksuto.shouldHitKey(ksuto.key3, ksuto.playerHealthPct() < 30 and not ksuto.playerHasBuff("Food")) -- regen
    end
end

