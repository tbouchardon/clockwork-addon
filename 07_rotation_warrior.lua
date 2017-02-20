--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

function ksuto.warriorDefRotation()

    -- ksuto.printDebug("function ksuto.warriorDefRotation(")

    ksuto.printDebug("warriorRotation()")

    ksuto.updatePositionCoordinates()

    if (ksuto.DEBUG_MOD) then ksuto.unitHasBuff("player", "for debug purpose") end

    if UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player")
            and UnitIsEnemy("player", "target") then
        -- and UnitCanAttack("player", "target")
        -- and not UnitIsTapped("target")

        AttackTarget()

        --Arc
        ksuto.shouldHitKey(ksuto.key9, not ksuto.checkTargetDistance(ksuto.DUEL))
        --dot
        ksuto.shouldHitKey(ksuto.key8, ksuto.manaPercentage("player") > 10 and ksuto.checkDebuffSpellCast("Rend"))
        --bouclier
        --ksuto.shouldHitKey(ksuto.key5, ksuto.manaPercentage("player") > 10) and not ksuto.unitHasBuff("player", "buff bouclier"))
        --revenche
        --ksuto.shouldHitKey(ksuto.key4, ksuto.manaPercentage("player") > 5))
        --frappe héroïque
        ksuto.shouldHitKey(ksuto.key5, ksuto.manaPercentage("player") > 20)
        --mon buff
        ksuto.shouldHitKey(ksuto.key4, ksuto.manaPercentage("player") > 10 and not ksuto.unitHasBuff("player", "Battle Shout"))
    else
        ksuto.resetKeys()
        --regen
        ksuto.shouldHitKey(ksuto.key3, ksuto.healthPercentage("player") < 30 and not ksuto.unitHasBuff("player", "regen pv"))
    end
end

