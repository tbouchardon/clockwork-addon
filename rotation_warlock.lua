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

    -- if (ksuto.DEBUG_MOD) then ksuto.unitHasBuff("player", "for debug purpose") end

    if UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player") and
            -- UnitCanAttack("player", "target") and
            UnitIsEnemy("player", "target") then

        -- ksuto.print("UnitCanAttack('player', 'target') : " .. UnitCanAttack("player", "target"))
        -- ksuto.print("UnitIsTapped('target') : " .. UnitIsTapped("target"))
        -- ksuto.print(tostring(UnitIsUnit("targettarget", "player")))

        if UnitIsUnit("player", "targettarget") then PetAttack() end
        AttackTarget()

        -- ksuto.shouldHitKey(ksuto.keyPar, ksuto.checkTargetDistance(ksuto.TRADE) and ksuto.checkDebuffSpellCast("Fear"))
        ksuto.shouldHitKey(ksuto.key0, not UnitExists("pet"))
        ksuto.shouldHitKey(ksuto.key9, ksuto.manaPercentage("player") < 25 and ksuto.healthPercentage("player") > 75) -- Life Tap
        -- ksuto.shouldHitKey(ksuto.key6, ksuto.healthPercentage("target") < 20 and ksuto.checkDebuffSpellCast("Drain Soul", 6))
        ksuto.shouldHitKey(ksuto.key5, ksuto.checkDebuffSpellCast("Curse of Agony", 5))
        ksuto.shouldHitKey(ksuto.key4, ksuto.checkDebuffSpellCast("Corruption", 4))
        ksuto.shouldHitKey(ksuto.key3, ksuto.checkDebuffSpellCast("Immolate", 3))
        ksuto.shouldHitKey(ksuto.key1, ksuto.checkActionCast(1) and ksuto.manaPercentage("player") > 50) -- Shadow Bolt as of now
    else
        ksuto.resetKeys()

        if not UnitIsDeadOrGhost("player") then
            ksuto.shouldHitKey(ksuto.keyEq, not ksuto.unitHasBuff("player", "Demon Skin"))
            ksuto.shouldHitKey(ksuto.key0, not UnitExists("pet"))
            ksuto.shouldHitKey(ksuto.key9, ksuto.manaPercentage("player") < 20 and ksuto.healthPercentage("player") > 75) -- Life Tap
        end
    end
end

