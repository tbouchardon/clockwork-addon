--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

function ksuto.warriorDefRotation()

    -- ksuto.printDebug("function ksuto.warriorDefRotation(")

    ksuto.updatePositionCoordinates()

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff("for debug purpose") end

    if UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player")
            and UnitIsEnemy("player", "target") then

        AttackTarget()

        ksuto.shouldHitKey(ksuto.key9) --, not ksuto.targetInRange(ksuto.DUEL)) -- Arc
        ksuto.shouldHitKey(ksuto.key8, not ksuto.targetHasDebuff("Rend")) -- dot
        --ksuto.shouldHitKey(ksuto.key5, not ksuto.playerHasBuff("buff bouclier")) -- bouclier
        --ksuto.shouldHitKey(ksuto.key4) -- revanche
        ksuto.shouldHitKey(ksuto.key5, ksuto.playerManaPct() > 40) -- frappe héroïque
        ksuto.shouldHitKey(ksuto.key4, not ksuto.playerHasBuff("Battle Shout")) -- mon buff

    else

        ksuto.resetKeys()

        ksuto.shouldHitKey(ksuto.key3, ksuto.playerHealthPct() < 30 and not ksuto.playerHasBuff("Food")) -- regen
    end
end

