--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

function ksuto.warlockAfflictionRotation()

    -- ksuto.printDebug("warlockRotation()")

    ksuto.updatePositionCoordinates()

    if (ksuto.DEBUG_MOD) then ksuto.unitHasBuff("player", "for debug purpose") end

    if UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player")
            and UnitIsEnemy("player", "target") then
        -- and UnitCanAttack("player", "target")
        -- and not UnitIsTapped("target")

        AttackTarget()

        --        TODO Check Action Cast
        ksuto.shouldHitKey(ksuto.keyPar, ksuto.checkTargetDistance(ksuto.TRADE) and ksuto.checkDebuffSpellCast("Fear"))
        ksuto.shouldHitKey(ksuto.key0, UnitIsDeadOrGhost("pet"))
        ksuto.shouldHitKey(ksuto.key9, ksuto.manaPercentage("player") < 50)
        ksuto.shouldHitKey(ksuto.key6, ksuto.healthPercentage("target") < 20 and ksuto.checkDebuffSpellCast("Drain Soul"))
        ksuto.shouldHitKey(ksuto.key5, ksuto.checkDebuffSpellCast("Curse of Agony"))
        ksuto.shouldHitKey(ksuto.key4, ksuto.checkDebuffSpellCast("Corruption"))
        ksuto.shouldHitKey(ksuto.key3, ksuto.checkDebuffSpellCast("Immolate"))
        ksuto.shouldHitKey(ksuto.key1, ksuto.checkActionCast(1)) -- Shadow Bolt as of now
    else
        ksuto.resetKeys()

        ksuto.shouldHitKey(ksuto.keyEq, not ksuto.unitHasBuff("player", "Demon Skin"))
    end
end

