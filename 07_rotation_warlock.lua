--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

function ksuto.warlockAfflictionRotation()

    -- ksuto.printDebug("function ksuto.warlockAfflictionRotation(")

    -- ksuto.printDebug("warlockRotation()")

    ksuto.updatePositionCoordinates()
    --    ksuto.print(tostring(ksuto.CASTING))

    if (ksuto.CASTING == true) then
        ksuto.resetKeys();
        return;
    end

    -- if (ksuto.DEBUG_MOD) then ksuto.unitHasBuff("player", "for debug purpose") end

    if (UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player") and
            (not UnitIsTapped("target") or (UnitIsTapped("target") and UnitIsTappedByPlayer("target"))) and
            UnitIsEnemy("player", "target")) then

        -- ksuto.print("UnitCanAttack('player', 'target') : " .. tostring(UnitCanAttack("player", "target")))
        --        ksuto.print("UnitIsTapped('target') : " .. tostring(UnitIsTapped("target")))
        -- ksuto.print("UnitIsUnit(' pettarget ', ' target ')" .. tostring(UnitIsUnit("pettarget", "target")))

        -- AttackTarget()

        -- DEFAULT KEYS

        ksuto.shouldHitKey(ksuto.keyT, ksuto.checkTargetDistance(ksuto.TRADE) and ksuto.checkDebuffSpellCast("Fear", ksuto.keyT.slot) and ksuto.enemyPlayer())
        ksuto.shouldHitKey(ksuto.key9, ksuto.manaPercentage("player") < 25 and ksuto.healthPercentage("player") > 75) -- Life Tap
        -- ksuto.shouldHitKey(ksuto.key6, ksuto.healthPercentage("target") < 20 and ksuto.checkDebuffSpellCast("Drain Soul", 6))
        ksuto.shouldHitKey(ksuto.key5, ksuto.checkDebuffSpellCast("Curse of Agony", 5))
        ksuto.shouldHitKey(ksuto.key4, ksuto.checkDebuffSpellCast("Corruption", 4))
        ksuto.shouldHitKey(ksuto.key3, ksuto.checkDebuffSpellCast("Immolate", 3))
        ksuto.shouldHitKey(ksuto.key2, ksuto.healthPercentage("player") < 80 and ksuto.checkDebuffSpellCast("Drain Life", 2))
        ksuto.shouldHitKey(ksuto.key1, ksuto.manaPercentage("player") > 50) -- Shadow Bolt as of now

        -- ALT KEYS
        -- SHIFT KEYS

        ksuto.shouldHitShiftKey(ksuto.keyG, not UnitExists("pet") and ksuto.checkActionCast(10))

        -- CTRL KEYS

        if UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and ksuto.checkTargetDistance(ksuto.DUEL) then ksuto.shouldHitCtrlKey(ksuto.key1, true)
        end -- Pet Attack

    else
        ksuto.resetKeys()

        if (not UnitIsDeadOrGhost("player")) then
            ksuto.printDebug("out of combat rotation")

            ksuto.shouldHitKey(ksuto.keyQ, ksuto.manaPercentage("player") < 33 and ksuto.healthPercentage("player") > 66) -- Life Tap

            ksuto.shouldHitShiftKey(ksuto.keyT, not ksuto.unitHasBuff("player", "Demon Skin"))
            ksuto.shouldHitShiftKey(ksuto.keyG, not UnitExists("pet"))
            ksuto.shouldHitShiftKey(ksuto.keyQ, ksuto.healthPercentage("player") < 25 and not ksuto.unitHasBuff("player", "Food"))
        end
    end
end

