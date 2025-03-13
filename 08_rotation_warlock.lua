--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()

    priority = 100
    --Clockwork.log.debug("function Clockwork.warlockAfflictionRotation")

    -- if (Clockwork.DEBUG_MOD) then Clockwork.playerHasBuff(, "for debug purpose") end

    -- N'attaquer que si :

    if (Clockwork.unitExistCanAndShouldDie() and not Clockwork.isCasting()) then

        local hasDebuff, hasAnyDebuff, remainingTime

        -- Fast invoke pet

        Clockwork.log.debug(tostring((not UnitExists("pet") or Clockwork.healthPercentage("pet") < 33)))
        Clockwork.shouldHitShiftKey(Clockwork.keyG,
                not Clockwork.outOfCombat() and
                        not Clockwork.playerHasBuff("Domination gangrenée") and
                        (not UnitExists("pet") or Clockwork.healthPercentage("pet") < 33), 200)
        Clockwork.shouldHitKey(Clockwork.keyG, Clockwork.playerHasBuff("Domination gangrenée") and true, 195)

        -- Repel enemy player
        Clockwork.shouldHitKey(Clockwork.keyR, Clockwork.targetInRange(Clockwork.TRADE) and not Clockwork.targetHasDebuff("Voile de mort") and Clockwork.enemyPlayer(), 190)

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitExists("pet")
                and Clockwork.healthPercentage("pet") > 10
                and UnitIsUnit("player", "targettarget")
                and not UnitIsUnit("pettarget", "target")
                and Clockwork.targetInRange(Clockwork.DUEL) then
            Clockwork.shouldHitCtrlKey(Clockwork.key1, nil, 155)
        end -- Pet Attack

        -- Heal self
        Clockwork.shouldHitKey(Clockwork.keyT, Clockwork.playerHealthPct() < 60, 150)

        -- Heal pet
        Clockwork.shouldHitShiftKey(Clockwork.keyT, UnitExists("pet") and Clockwork.healthPercentage("pet") < 33, 145)

        -- Crépuscule
        Clockwork.shouldHitKey(Clockwork.key1, Clockwork.playerHasBuff("Crépuscule") and true, 105)

        --Haunt
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Hanter")
        Clockwork.shouldHitKey(Clockwork.keyD, not hasDebuff or remainingTime < 3, 100)

        --Unstable Affliction
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Affliction instable")
        afflictionInstableTargetFound = false
        if (Clockwork.afflictionInstableTarget ~= nil) then
            for guid, _ in pairs(Clockwork.targets.list) do
                if guid == Clockwork.afflictionInstableTarget then
                    Clockwork.log.debug("Unstable Affliction : afflictionInstableTargetFound : " .. guid)
                    if (Clockwork.afflictionInstableEndTime > GetTime()) then
                        afflictionInstableTargetFound = true
                    else
                        Clockwork.log.debug("Unstable Affliction : But time's up.")
                    end
                end
            end
        end
        if not afflictionInstableTargetFound then
            Clockwork.log.debug("Unstable Affliction : afflictionInstable Target Not Found : clearing")
            Clockwork.afflictionInstableTarget = nil
            Clockwork.afflictionInstableEndTime = nil
        end
        if (not hasDebuff
                and not afflictionInstableTargetFound
                and (not Clockwork.afflictionInstableEndTime or Clockwork.afflictionInstableEndTime < GetTime())) then
            Clockwork.log.debug("Unstable Affliction : not hasDebuff")
            Clockwork.shouldHitKey(Clockwork.key6, true, 95)
        end
        if hasDebuff then
            Clockwork.log.debug("Unstable Affliction : hasDebuff")
            currentTargetGUID = UnitGUID("target")
            Clockwork.afflictionInstableEndTime = GetTime() + remainingTime
            Clockwork.afflictionInstableTarget = currentTargetGUID
        end

        --Agony
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Agonie")
        Clockwork.shouldHitKey(Clockwork.key5, not hasDebuff or remainingTime < 4, 90)

        --Corruption
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Corruption")
        Clockwork.shouldHitKey(Clockwork.key3, not hasDebuff, 85) --or remainingTime < 2

        -- Singularité
        Clockwork.shouldHitKey(Clockwork.keyF, nil, 80)

        --Summon Darkglare
        Clockwork.shouldHitShiftKey(Clockwork.keyG, Clockwork.targetsOwnDebuffCount() > 3, 75)

        -- Graine de Corruption
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Graine de Corruption")
        Clockwork.shouldHitShiftKey(Clockwork.keyF,
                Clockwork.targets.multiTargetMod
                        and UnitPower("player", Enum.PowerType.SoulShards) > 1
                        and not hasDebuff, 86)

        --Malefic Raptures
        Clockwork.shouldHitKey(Clockwork.key2,
                (UnitPower("player", Enum.PowerType.SoulShards) > 1 and Clockwork.targetsOwnDebuffCount() > 3)
                        or UnitPower("player", Enum.PowerType.SoulShards) == 5, 70)


        -- filler
        Clockwork.shouldHitKey(Clockwork.key1)

        -- ALT KEYS
        -- SHIFT KEYS

        Clockwork.shouldHitKey(Clockwork.keyG, not UnitExists("pet")) -- Invoquer si le pet n'existe pas

    elseif (Clockwork.outOfCombat()) then
        -- hors combat

        --Clockwork.log.debug("Clockwork.outOfCombat()")

        --Clockwork.shouldHitKey(Clockwork.keyQ, Clockwork.playerManaPct() < 33 and Clockwork.playerHealthPct() > 66) -- Life Tap

        hasDebuff, remainingTime = Clockwork.playerHasBuff("Pierre d'âme")
        Clockwork.shouldHitKey(Clockwork.keyEq, not hasDebuff)

        --Clockwork.shouldHitShiftKey(Clockwork.keyT, not Clockwork.playerHasBuff("Demon Skin")) -- Buff
        Clockwork.shouldHitKey(Clockwork.keyG, not UnitExists("pet") and not Clockwork.isCasting()) -- Invoquer le pet s'il n'existe pas
        --Clockwork.shouldHitShiftKey(Clockwork.keyQ, Clockwork.playerHealthPct() < 25 and not Clockwork.playerHasBuff("Food")) -- Manger
    end
end

---------------------------------------------------------------------------------------------------
local function rotation2()
end

---------------------------------------------------------------------------------------------------
local function rotation3()
end

function Clockwork.warlockRotation()

    if Clockwork.spe == 1 then
        rotation1()
    elseif Clockwork.spe == 2 then
        rotation2()
    elseif Clockwork.spe == 3 then
        rotation3()
    end
end

