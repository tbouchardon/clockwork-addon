--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()

    ksuto.printDebug("function ksuto.warlockAfflictionRotation")

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff(, "for debug purpose") end

    -- N'attaquer que si :

    if (ksuto.unitExistCanAndShouldDie()) then

        -- ksuto.print("UnitCanAttack('player', 'target') : " .. tostring(UnitCanAttack("player", "target")))

        -- AttackTarget()

        -- DEFAULT KEYS

        ksuto.shouldHitKey(ksuto.keyT, ksuto.targetInRange(ksuto.TRADE) and not ksuto.targetHasDebuff("Fear") and ksuto.enemyPlayer())
        ksuto.shouldHitKey(ksuto.key9, ksuto.playerManaPct() < 25 and ksuto.playerHealthPct() > 75) -- Life Tap
        -- ksuto.shouldHitKey(ksuto.key6, ksuto.healthPercentage("target") < 20 and not ksuto.targetHasDebuff("Drain Soul"))
        ksuto.shouldHitKey(ksuto.key5, not ksuto.targetHasDebuff("Curse of Agony"))
        ksuto.shouldHitKey(ksuto.key4, not ksuto.targetHasDebuff("Corruption"))
        ksuto.shouldHitKey(ksuto.key3, not ksuto.targetHasDebuff("Immolate"))
        ksuto.shouldHitKey(ksuto.key2, ksuto.playerHealthPct() < 80 and not ksuto.targetHasDebuff("Drain Life"))
        ksuto.shouldHitKey(ksuto.key1, ksuto.playerManaPct() > 50) -- Shadow Bolt as of now

        -- ALT KEYS
        -- SHIFT KEYS

        ksuto.shouldHitShiftKey(ksuto.keyG, not UnitExists("pet") and ksuto.actionCanBeCast(10)) -- Invoquer si le pet n'existe pas

        -- CTRL KEYS

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and ksuto.targetInRange(ksuto.DUEL) then ksuto.shouldHitCtrlKey(ksuto.key1)
        end -- Pet Attack


    elseif (ksuto.outOfCombat()) then -- hors combat

        ksuto.shouldHitKey(ksuto.keyQ, ksuto.playerManaPct() < 33 and ksuto.playerHealthPct() > 66) -- Life Tap

        ksuto.shouldHitShiftKey(ksuto.keyT, not ksuto.playerHasBuff("Demon Skin")) -- Buff
        ksuto.shouldHitShiftKey(ksuto.keyG, not UnitExists("pet") and ksuto.actionCanBeCast(10)) -- Invoquer le pet s'il n'existe pas
        ksuto.shouldHitShiftKey(ksuto.keyQ, ksuto.playerHealthPct() < 25 and not ksuto.playerHasBuff("Food")) -- Manger
    end
end


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
local function rotation2() --Rotation bind Oko

    ksuto.printDebug("function ksuto.warlockAfflictionRotation2")

    -- N'attaquer que si :

    if (ksuto.unitExistCanAndShouldDie()) and (not ksuto.enemyPlayer()) then

        ksuto.shouldHitKey(ksuto.key9, ksuto.playerManaPct() < 25 and ksuto.playerHealthPct() > 75) -- Life Tap
        -- ksuto.shouldHitKey(ksuto.key6, ksuto.healthPercentage("target") < 20 and not ksuto.targetHasDebuff("Drain Soul"))
        ksuto.shouldHitKey(ksuto.key8, not ksuto.targetHasDebuff("Immolate"))
        ksuto.shouldHitKey(ksuto.key7, not ksuto.targetHasDebuff("Corruption"))
        ksuto.shouldHitKey(ksuto.key6, not ksuto.targetHasDebuff("Curse of Agony"))
        ksuto.shouldHitKey(ksuto.key5, ksuto.playerHealthPct() < 80 and not ksuto.targetHasDebuff("Drain Life"))
        ksuto.shouldHitKey(ksuto.key4, ksuto.playerManaPct() > 50) -- Shadow Bolt as of now
        ksuto.shouldHitKey(ksuto.key1, not IsCurrentAction(14) and ksuto.targetInRange(ksuto.DUEL), 14) --Baguette

        -- ALT KEYS
        -- SHIFT KEYS

        ksuto.shouldHitKey(ksuto.key3, not UnitExists("pet")) -- Fear si le pet n'est pas présent

        -- CTRL KEYS

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and ksuto.targetInRange(ksuto.DUEL) then ksuto.shouldHitCtrlKey(ksuto.key1)
        end -- Pet Attack


    elseif (ksuto.outOfCombat()) then -- hors combat

        ksuto.shouldHitKey(ksuto.key9, ksuto.playerManaPct() < 33 and ksuto.playerHealthPct() > 66) -- Life Tap

        ksuto.shouldHitShiftKey(ksuto.key9, not ksuto.playerHasBuff("Demon Skin")) -- Buff
        ksuto.shouldHitShiftKey(ksuto.key8, not UnitExists("pet") and ksuto.actionCanBeCast(10)) -- Invoquer le pet s'il n'existe pas
        ksuto.shouldHitShiftKey(ksuto.key7, ksuto.playerHealthPct() < 25 and not ksuto.playerHasBuff("Food")) -- Manger
    end
end


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
local function rotation3() --Rotation bind Oko avec génération shard

    ksuto.printDebug("function ksuto.warlock génération shard")

    if (ksuto.unitExistCanAndShouldDie()) and (not ksuto.enemyPlayer()) then

        ksuto.shouldHitKey(ksuto.key9, ksuto.playerManaPct() < 25 and ksuto.playerHealthPct() > 75) -- Life Tap
        ksuto.shouldHitKey(ksuto.key8, not ksuto.targetHasDebuff("Immolate"))
        ksuto.shouldHitKey(ksuto.key7, not ksuto.targetHasDebuff("Corruption"))
        ksuto.shouldHitKey(ksuto.key6, not ksuto.targetHasDebuff("Curse of Agony"))
        ksuto.shouldHitKey(ksuto.key5, ksuto.playerHealthPct() < 80 and not ksuto.targetHasDebuff("Drain Life"))
        ksuto.shouldHitKey(ksuto.key4, ksuto.playerManaPct() > 50) -- Shadow Bolt as of now
        ksuto.shouldHitKey(ksuto.key2, ksuto.healthPercentage("target") < 20 and not ksuto.targetHasDebuff("Drain Soul"))
        ksuto.shouldHitKey(ksuto.key1, not IsCurrentAction(14) and ksuto.targetInRange(ksuto.DUEL), 14) --Baguette

        ksuto.shouldHitKey(ksuto.key3, not UnitExists("pet")) -- Fear si le pet n'est pas présent

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and ksuto.targetInRange(ksuto.DUEL) then ksuto.shouldHitCtrlKey(ksuto.key1)
        end -- Pet Attack

    elseif (ksuto.outOfCombat()) then -- hors combat

        ksuto.shouldHitKey(ksuto.key9, ksuto.playerManaPct() < 33 and ksuto.playerHealthPct() > 66) -- Life Tap
        ksuto.shouldHitShiftKey(ksuto.key9, not ksuto.playerHasBuff("Demon Skin")) -- Buff
        ksuto.shouldHitShiftKey(ksuto.key8, not UnitExists("pet") and ksuto.actionCanBeCast(10)) -- Invoquer le pet s'il n'existe pas
        ksuto.shouldHitShiftKey(ksuto.key7, ksuto.playerHealthPct() < 25 and not ksuto.playerHasBuff("Food")) -- Manger
    end
end

function ksuto.warlockRotation()

    if ksuto.spe == 1 then rotation1()
    elseif ksuto.spe == 2 then rotation2()
    elseif ksuto.spe == 3 then rotation3()
    end
end

