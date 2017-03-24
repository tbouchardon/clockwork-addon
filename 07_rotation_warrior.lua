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

        AttackTarget()

        ksuto.shouldHitKey(ksuto.key1, nil, 73) -- Chargeeeeeeeeezzzzzzz !!!!!!!!!

    else

        ksuto.resetKeys()

        ksuto.shouldHitKey(ksuto.key3, ksuto.playerHealthPct() < 30 and not ksuto.playerHasBuff("Food")) -- regen
    end
end

