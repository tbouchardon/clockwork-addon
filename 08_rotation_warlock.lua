--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()

    priority = 100
    --clockWork.printDebug("function clockWork.warlockAfflictionRotation")

    -- if (clockWork.DEBUG_MOD) then clockWork.playerHasBuff(, "for debug purpose") end

    -- N'attaquer que si :

    if (clockWork.unitExistCanAndShouldDie() and not clockWork.isCasting()) then

        local hasDebuff, hasAnyDebuff, remainingTime

        -- Fast invoke pet

        clockWork.log.debug(tostring((not UnitExists("pet") or clockWork.healthPercentage("pet") < 33)))
        clockWork.shouldHitShiftKey(clockWork.keyG,
                not clockWork.outOfCombat() and
                        not clockWork.playerHasBuff("Domination gangrenée") and
                        (not UnitExists("pet") or clockWork.healthPercentage("pet") < 33), 200)
        clockWork.shouldHitKey(clockWork.keyG, clockWork.playerHasBuff("Domination gangrenée") and true, 195)

        -- Repel enemy player
        clockWork.shouldHitKey(clockWork.keyR, clockWork.targetInRange(clockWork.TRADE) and not clockWork.targetHasDebuff("Voile de mort") and clockWork.enemyPlayer(), 190)

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitExists("pet")
                and clockWork.healthPercentage("pet") > 10
                and UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and clockWork.targetInRange(clockWork.DUEL) then
            clockWork.shouldHitCtrlKey(clockWork.key1, nil, 155)
        end -- Pet Attack

        -- Heal self
        clockWork.shouldHitKey(clockWork.keyT, clockWork.playerHealthPct() < 60, 150)

        -- Heal pet
        clockWork.shouldHitShiftKey(clockWork.keyT, UnitExists("pet") and clockWork.healthPercentage("pet") < 33, 145)

        -- Crépuscule
        clockWork.shouldHitKey(clockWork.key1, clockWork.playerHasBuff("Crépuscule") and true, 105)

        --Haunt
        hasDebuff, remainingTime = clockWork.targetHasDebuff("Hanter")
        clockWork.shouldHitKey(clockWork.keyD, not hasDebuff or remainingTime < 3, 100)

        --Unstable Affliction
        hasDebuff, remainingTime = clockWork.targetHasDebuff("Affliction instable")
        afflictionInstableTargetFound = false
        if (clockWork.afflictionInstableTarget ~= nil) then
            for guid, _ in pairs(clockWork.targets.list) do
                if guid == clockWork.afflictionInstableTarget then
                    clockWork.log.debug("Unstable Affliction : afflictionInstableTargetFound : " .. guid)
                    if (clockWork.afflictionInstableEndTime > GetTime()) then
                        afflictionInstableTargetFound = true
                    else
                        clockWork.log.debug("Unstable Affliction : But time's up.")
                    end
                end
            end
        end
        if not afflictionInstableTargetFound then
            clockWork.log.debug("Unstable Affliction : afflictionInstableTarget Not Found : clearing")
            clockWork.afflictionInstableTarget = nil
            clockWork.afflictionInstableEndTime = nil
        end
        if (not hasDebuff
                and not afflictionInstableTargetFound
                and (not clockWork.afflictionInstableEndTime or clockWork.afflictionInstableEndTime < GetTime())) then
            clockWork.log.debug("Unstable Affliction : not hasDebuff")
            clockWork.shouldHitKey(clockWork.key6, true, 95)
        end
        if hasDebuff then
            clockWork.log.debug("Unstable Affliction : hasDebuff")
            currentTargetGUID = UnitGUID("target")
            clockWork.afflictionInstableEndTime = GetTime() + remainingTime
            clockWork.afflictionInstableTarget = currentTargetGUID
        end

        --Agony
        hasDebuff, remainingTime = clockWork.targetHasDebuff("Agonie")
        clockWork.shouldHitKey(clockWork.key5, not hasDebuff or remainingTime < 4, 90)

        --Corruption
        hasDebuff, remainingTime = clockWork.targetHasDebuff("Corruption")
        clockWork.shouldHitKey(clockWork.key3, not hasDebuff, 85) --or remainingTime < 2

        -- Singularité
        clockWork.shouldHitKey(clockWork.keyF, nil, 80)

        --Summon Darkglare
        clockWork.shouldHitShiftKey(clockWork.keyG, clockWork.targetsOwnDebuffCount() > 3, 75)

        -- Graine de Corruption
        hasDebuff, remainingTime = clockWork.targetHasDebuff("Graine de Corruption")
        clockWork.shouldHitShiftKey(clockWork.keyF,
                clockWork.targets.multiTargetMod
                        and UnitPower("player", Enum.PowerType.SoulShards) > 1
                        and not hasDebuff, 86)

        --Malefic Raptures
        clockWork.shouldHitKey(clockWork.key2,
                (UnitPower("player", Enum.PowerType.SoulShards) > 1 and clockWork.targetsOwnDebuffCount() > 3)
                        or UnitPower("player", Enum.PowerType.SoulShards) == 5, 70)


        -- filler
        clockWork.shouldHitKey(clockWork.key1)

        -- ALT KEYS
        -- SHIFT KEYS

        clockWork.shouldHitKey(clockWork.keyG, not UnitExists("pet")) -- Invoquer si le pet n'existe pas

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
local function rotation2()
end

---------------------------------------------------------------------------------------------------
local function rotation3()
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

