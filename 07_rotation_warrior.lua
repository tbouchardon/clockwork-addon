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

    if (ksuto.unitExistCanAndShouldDie()) and not (ksuto.enemyPlayer()) then

        ksuto.shouldHitKey(ksuto.keyH, nil, 21) --, not ksuto.targetInRange(ksuto.DUEL)) -- Arc
        ksuto.shouldHitKey(ksuto.key8, not ksuto.targetHasDebuff("Rend"), 77) -- dot
        --ksuto.shouldHitKey(ksuto.key5, not ksuto.playerHasBuff("buff bouclier")) -- bouclier
        --ksuto.shouldHitKey(ksuto.key4) -- revanche
        ksuto.shouldHitKey(ksuto.key5, ksuto.playerManaPct() > 40, 13) -- frappe héroïque
        ksuto.shouldHitKey(ksuto.key9, ksuto.playerManaPct() > 5, 78) -- overpower
        ksuto.shouldHitKey(ksuto.key4, not ksuto.playerHasBuff("Battle Shout"), 24) -- mon buff
        ksuto.shouldHitKey(ksuto.key6, not ksuto.targetHasDebuff("Demoralizing Shout"), 75) -- mon debuff
        ksuto.shouldHitKey(ksuto.key1, not IsCurrentAction(18) and ksuto.targetInRange(ksuto.DUEL), 18) -- activate Attack

    else

        ksuto.resetKeys()
        ksuto.shouldHitKey(ksuto.key3, ksuto.playerHealthPct() < 30 and not ksuto.playerHasBuff("Food"), 36) -- regen
        ksuto.shouldHitKey(ksuto.key2, ksuto.playerHealthPct() > 31 and ksuto.playerHealthPct() < 60 and not ksuto.playerHasBuff("Bandage") and not ksuto.playerHasAnyDebuff(), 38) -- regen
    end
end

