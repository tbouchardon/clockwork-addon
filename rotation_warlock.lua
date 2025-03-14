--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial()        -- no Sp
end
local function initialActions() -- no Sp
end

---------------------------------------------------------------------------------------------------
local function affliction()
    local priority = 100
    --Clockwork.log.debug("function Clockwork.warlockAfflictionRotation")

    -- if (Clockwork.DEBUG_MOD) then Clockwork.playerHasBuff(, "for debug purpose") end

    -- N'attaquer que si :

    if (Clockwork.unitExistCanAndShouldDie() and not Clockwork.isCasting()) then
        local hasDebuff, hasAnyDebuff, remainingTime

        -- Fast invoke pet

        Clockwork.log.debug(tostring((not UnitExists("pet") or Clockwork.healthPercentage("pet") < 33)))
        Clockwork.shouldHitShiftKey({
            key = Clockwork.keyG,
            condition =
                not Clockwork.outOfCombat() and
                not Clockwork.playerHasBuff("Domination gangrenée") and
                (not UnitExists("pet") or Clockwork.healthPercentage("pet") < 33),
            priority = 200
        })
        Clockwork.shouldHitKey({
            key = Clockwork.keyG,
            condition = Clockwork.playerHasBuff("Domination gangrenée") and
                true,
            priority = 195
        })

        -- Repel enemy player
        Clockwork.shouldHitKey({
            key = Clockwork.keyR,
            condition =
                Clockwork.targetInRange(Clockwork.TRADE) and not Clockwork.targetHasDebuff("Voile de mort") and
                Clockwork.enemyPlayer(),
            priority = 190
        })

        -- Le pet attaque SI l'enemi attaque le joueur ET est à moins de 9.9 yards
        if UnitExists("pet")
            and Clockwork.healthPercentage("pet") > 10
            and UnitIsUnit("player", "targettarget")
            and not UnitIsUnit("pettarget", "target")
            and Clockwork.targetInRange(Clockwork.DUEL) then
            Clockwork.shouldHitCtrlKey({
                key = Clockwork.key1,
                condition = nil,
                priority = 155
            })
        end -- Pet Attack

        -- Heal self
        Clockwork.shouldHitKey({
            key = Clockwork.keyT,
            condition = Clockwork.playerHealthPct() < 60,
            priority = 150
        })

        -- Heal pet
        Clockwork.shouldHitShiftKey({
            key = Clockwork.keyT,
            condition = UnitExists("pet") and
                Clockwork.healthPercentage("pet") < 33,
            priority = 145
        })

        -- Crépuscule
        Clockwork.shouldHitKey({
            key = Clockwork.key1,
            condition = Clockwork.playerHasBuff("Crépuscule") and true,
            priority = 105
        })

        --Haunt
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Hanter")
        Clockwork.shouldHitKey({
            key = Clockwork.keyD,
            condition = not hasDebuff or remainingTime < 3,
            priority = 100
        })

        --Unstable Affliction
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Affliction instable")
        local afflictionInstableTargetFound = false
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
            Clockwork.shouldHitKey({
                key = Clockwork.key6,
                condition = true,
                priority = 95
            })
        end
        if hasDebuff then
            Clockwork.log.debug("Unstable Affliction : hasDebuff")
            local currentTargetGUID = UnitGUID("target")
            Clockwork.afflictionInstableEndTime = GetTime() + remainingTime
            Clockwork.afflictionInstableTarget = currentTargetGUID
        end

        --Agony
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Agonie")
        Clockwork.shouldHitKey({
            key = Clockwork.key5,
            condition = not hasDebuff or remainingTime < 4,
            priority = 90
        })

        --Corruption
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Corruption")
        Clockwork.shouldHitKey({
            key = Clockwork.key3,
            condition = not hasDebuff,
            priority = 85
        }) --or remainingTime < 2

        -- Singularité
        Clockwork.shouldHitKey({
            key = Clockwork.keyF,
            condition = nil,
            priority = 80
        })

        --Summon Darkglare
        Clockwork.shouldHitShiftKey({
            key = Clockwork.keyG,
            condition = Clockwork.targetsOwnDebuffCount() > 3,
            priority = 75
        })

        -- Graine de Corruption
        hasDebuff, remainingTime = Clockwork.targetHasDebuff("Graine de Corruption")
        Clockwork.shouldHitShiftKey({
            key = Clockwork.keyF,
            condition = Clockwork.targets.multiTargetMod
                and UnitPower("player", Enum.PowerType.SoulShards) > 1
                and not hasDebuff,
            priority = 86
        })

        --Malefic Raptures
        Clockwork.shouldHitKey({
            key = Clockwork.key2,
            condition = (UnitPower("player", Enum.PowerType.SoulShards) > 1 and Clockwork.targetsOwnDebuffCount() > 3) or
                UnitPower("player", Enum.PowerType.SoulShards) == 5,
            priority = 70
        })


        -- filler
        Clockwork.shouldHitKey({ key = Clockwork.key1 })

        -- ALT KEYS
        -- SHIFT KEYS

        Clockwork.shouldHitKey({
            key = Clockwork.keyG,
            condition = not UnitExists("pet")
        }) -- Invoquer si le pet n'existe pas
    elseif (Clockwork.outOfCombat()) then
        -- hors combat

        --Clockwork.log.debug("Clockwork.outOfCombat()")

        --Clockwork.shouldHitKey(Clockwork.keyQ, Clockwork.playerManaPct() < 33 and Clockwork.playerHealthPct() > 66) -- Life Tap

        local hasDebuff, remainingTime = Clockwork.playerHasBuff("Pierre d'âme")
        Clockwork.shouldHitKey({
            key = Clockwork.keyEq,
            condition = not hasDebuff
        })

        --Clockwork.shouldHitShiftKey(Clockwork.keyT, not Clockwork.playerHasBuff("Demon Skin")) -- Buff
        Clockwork.shouldHitKey({
            key = Clockwork.keyG,
            condition = not UnitExists("pet") and not Clockwork.isCasting()
        }) -- Invoquer le pet s'il n'existe pas
        --Clockwork.shouldHitShiftKey(Clockwork.keyQ, Clockwork.playerHealthPct() < 25 and not Clockwork.playerHasBuff("Food")) -- Manger
    end
end
local function afflictionActions()
    Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.AGONIE_980, 5)
    Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.CORRUPTION_172, 4)
    Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.TRAIT_DE_L_OMBRE_686, 1)
end

---------------------------------------------------------------------------------------------------
local function demonology()
end
local function demonologyActions()
end

---------------------------------------------------------------------------------------------------
local function destruction()
end
local function destructionActions()
    Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.AGONIE_980, 5)
    Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.IMMOLATION_348, 4)
    Clockwork.dropSpellInBarSlot(Clockwork.Enum.Spell.Warlock.TRAIT_DE_L_OMBRE_686, 1)
end

Clockwork.rotations[Clockwork.Enum.Specialization.Warlock.Affliction] = affliction
Clockwork.rotations[Clockwork.Enum.Specialization.Warlock.Demonology] = demonology
Clockwork.rotations[Clockwork.Enum.Specialization.Warlock.Destruction] = destruction
Clockwork.rotations[Clockwork.Enum.Specialization.Warlock.Initial] = initial

Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warlock.Affliction] = afflictionActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warlock.Demonology] = demonologyActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warlock.Destruction] = destructionActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warlock.Initial] = initialActions
