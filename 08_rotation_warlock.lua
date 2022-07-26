--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()

    --clockWork.printDebug("function clockWork.warlockAfflictionRotation")

    -- if (clockWork.DEBUG_MOD) then clockWork.playerHasBuff(, "for debug purpose") end

    -- N'attaquer que si :

    if (clockWork.unitExistCanAndShouldDie()) then

        --clockWork.print("UnitCanAttack('player', 'target') : " .. tostring(UnitCanAttack("player", "target")))

        local hasDebuff, hasAnyDebuff, remainingTime

        -- AttackTarget()

        -- DEFAULT KEYS


        --clockWork.printDebug("UnitPower(\"player\", Enum.PowerType.SoulShards) > 2" .. tostring(UnitPower("player", Enum.PowerType.SoulShards) > 2))
        --clockWork.shouldHitKey(clockWork.key2, UnitPower("player", Enum.PowerType.SoulShards) > 2)
        --
        --clockWork.shouldHitKey(clockWork.keyD, not hasDebuff)
        --
        --if true then return end

        clockWork.shouldHitShiftKey(clockWork.keyG,
                not clockWork.outOfCombat() and
                        not clockWork.playerHasBuff("Domination gangrenée") and
                        (not UnitExists("pet") or clockWork.healthPercentage("pet") < 33))
        clockWork.shouldHitKey(clockWork.keyG,  clockWork.playerHasBuff("Domination gangrenée") and true)

        clockWork.shouldHitKey(clockWork.keyR, clockWork.targetInRange(clockWork.TRADE) and not clockWork.targetHasDebuff("Voile de mort") and clockWork.enemyPlayer())
        clockWork.shouldHitKey(clockWork.keyT, clockWork.playerHealthPct() < 60 and not clockWork.isCasting())
        clockWork.shouldHitShiftKey(clockWork.keyT, UnitExists("pet") and clockWork.healthPercentage("pet") < 33 and not clockWork.isCasting())

        clockWork.shouldHitKey(clockWork.keyF)

        clockWork.shouldHitShiftKey(clockWork.keyD, clockWork.targetsOwnDebuffCount() > 3)

        hasDebuff, remainingTime = clockWork.targetHasDebuff("Hanter")
        clockWork.shouldHitKey(clockWork.keyD, not hasDebuff or remainingTime < 3)

        hasDebuff, remainingTime = clockWork.targetHasDebuff("Affliction instable")
        if (not hasDebuff and (not clockWork.afflictionInstableEndTime or clockWork.afflictionInstableEndTime < GetTime())) then
            clockWork.shouldHitKey(clockWork.key6, true)
        end
        if hasDebuff then
            clockWork.afflictionInstableEndTime = GetTime() + remainingTime
        end

        hasDebuff, remainingTime = clockWork.targetHasDebuff("Agonie")
        clockWork.shouldHitKey(clockWork.key5, not hasDebuff or remainingTime < 4)

        hasDebuff, remainingTime = clockWork.targetHasDebuff("Siphon de vie")
        clockWork.shouldHitKey(clockWork.key4, not hasDebuff or remainingTime < 2)

        hasDebuff, remainingTime = clockWork.targetHasDebuff("Corruption")
        clockWork.shouldHitKey(clockWork.key3, not hasDebuff or remainingTime < 2)

        clockWork.shouldHitKey(clockWork.key2, UnitPower("player", Enum.PowerType.SoulShards) > 2 and clockWork.targetsOwnDebuffCount() > 3)

        clockWork.shouldHitKey(clockWork.key1, not clockWork.isCasting())

        -- ALT KEYS
        -- SHIFT KEYS

        clockWork.shouldHitKey(clockWork.keyG, not UnitExists("pet")) -- Invoquer si le pet n'existe pas

        -- CTRL KEYS

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and clockWork.targetInRange(clockWork.DUEL) then
            clockWork.shouldHitCtrlKey(clockWork.key1)
        end -- Pet Attack


    elseif (clockWork.outOfCombat()) then
        -- hors combat

        --clockWork.printDebug("clockWork.outOfCombat()")

        --clockWork.shouldHitKey(clockWork.keyQ, clockWork.playerManaPct() < 33 and clockWork.playerHealthPct() > 66) -- Life Tap

        hasDebuff, remainingTime = clockWork.playerHasBuff("Pierre d'âme")
        clockWork.shouldHitKey(clockWork.keyEq, not hasDebuff)

        --clockWork.shouldHitShiftKey(clockWork.keyT, not clockWork.playerHasBuff("Demon Skin")) -- Buff
        clockWork.shouldHitKey(clockWork.keyG, not UnitExists("pet") and not clockWork.isCasting()) -- Invoquer le pet s'il n'existe pas
        --clockWork.shouldHitShiftKey(clockWork.keyQ, clockWork.playerHealthPct() < 25 and not clockWork.playerHasBuff("Food")) -- Manger
    end
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
local function rotation2()
    --Rotation bind Oko

    clockWork.printDebug("function clockWork.warlockAfflictionRotation2")

    -- N'attaquer que si :

    if (clockWork.unitExistCanAndShouldDie()) and (not clockWork.enemyPlayer()) then

        clockWork.shouldHitKey(clockWork.key9, clockWork.playerManaPct() < 25 and clockWork.playerHealthPct() > 75, 15) -- Life Tap
        -- clockWork.shouldHitKey(clockWork.key6, clockWork.healthPercentage("target") < 20 and not clockWork.targetHasDebuff("Drain Soul"))
        clockWork.shouldHitKey(clockWork.key8, not clockWork.targetHasDebuff("Immolate"), 2)
        clockWork.shouldHitKey(clockWork.key7, not clockWork.targetHasDebuff("Corruption"), 3)
        clockWork.shouldHitKey(clockWork.key6, not clockWork.targetHasDebuff("Curse of Agony"), 4)
        --clockWork.shouldHitKey(clockWork.key5, clockWork.playerHealthPct() < 80 and not clockWork.targetHasDebuff("Drain Life"),)
        clockWork.shouldHitKey(clockWork.key4, clockWork.playerManaPct() > 50, 1) -- Shadow Bolt as of now
        --clockWork.shouldHitKey(clockWork.key1, not IsCurrentAction(14) and clockWork.targetInRange(clockWork.DUEL), 14) --Baguette

        -- ALT KEYS
        -- SHIFT KEYS

        clockWork.shouldHitKey(clockWork.key3, not UnitExists("pet"), 14) -- Fear si le pet n'est pas présent

        -- CTRL KEYS

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and clockWork.targetInRange(clockWork.DUEL) then
            clockWork.shouldHitCtrlKey(clockWork.key1)
        end -- Pet Attack


    elseif (clockWork.outOfCombat()) then
        -- hors combat

        clockWork.shouldHitKey(clockWork.key9, clockWork.playerManaPct() < 33 and clockWork.playerHealthPct() > 66, 15) -- Life Tap

        clockWork.shouldHitShiftKey(clockWork.key9, not clockWork.playerHasBuff("Demon Skin"), 24) -- Buff
        clockWork.shouldHitShiftKey(clockWork.key8, not UnitExists("pet")) -- Invoquer le pet s'il n'existe pas
        clockWork.shouldHitShiftKey(clockWork.key7, clockWork.playerHealthPct() < 25 and not clockWork.playerHasBuff("Food"), 11) -- Manger
    end
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
local function rotation3()
    --Rotation bind Oko avec génération shard

    clockWork.printDebug("function clockWork.warlock génération shard")

    if (clockWork.unitExistCanAndShouldDie()) and (not clockWork.enemyPlayer()) then

        clockWork.shouldHitKey(clockWork.key9, clockWork.playerManaPct() < 25 and clockWork.playerHealthPct() > 75) -- Life Tap
        clockWork.shouldHitKey(clockWork.key8, not clockWork.targetHasDebuff("Immolate"))
        clockWork.shouldHitKey(clockWork.key7, not clockWork.targetHasDebuff("Corruption"))
        clockWork.shouldHitKey(clockWork.key6, not clockWork.targetHasDebuff("Curse of Agony"))
        clockWork.shouldHitKey(clockWork.key5, clockWork.playerHealthPct() < 80 and not clockWork.targetHasDebuff("Drain Life"))
        clockWork.shouldHitKey(clockWork.key4, clockWork.playerManaPct() > 50) -- Shadow Bolt as of now
        clockWork.shouldHitKey(clockWork.key2, clockWork.healthPercentage("target") < 20 and not clockWork.targetHasDebuff("Drain Soul"))
        clockWork.shouldHitKey(clockWork.key1, not IsCurrentAction(14) and clockWork.targetInRange(clockWork.DUEL), 14) --Baguette

        clockWork.shouldHitKey(clockWork.key3, not UnitExists("pet")) -- Fear si le pet n'est pas présent

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and clockWork.targetInRange(clockWork.DUEL) then
            clockWork.shouldHitCtrlKey(clockWork.key1)
        end -- Pet Attack

    elseif (clockWork.outOfCombat()) then
        -- hors combat

        clockWork.shouldHitKey(clockWork.key9, clockWork.playerManaPct() < 33 and clockWork.playerHealthPct() > 66) -- Life Tap
        clockWork.shouldHitShiftKey(clockWork.key9, not clockWork.playerHasBuff("Demon Skin")) -- Buff
        clockWork.shouldHitShiftKey(clockWork.key8, not UnitExists("pet")) -- Invoquer le pet s'il n'existe pas
        clockWork.shouldHitShiftKey(clockWork.key7, clockWork.playerHealthPct() < 25 and not clockWork.playerHasBuff("Food")) -- Manger
    end
end

function clockWork.warlockRotation()

    if clockWork.spe == 1 then
        rotation1()
    elseif clockWork.spe == 2 then
        rotation2()
    elseif clockWork.spe == 3 then
        rotation3()
    end
end

