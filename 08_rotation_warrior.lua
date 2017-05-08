--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

ksuto.regen = 53

local function rotation1()

    --    ksuto.printDebug("function ksuto.warriorDefRotation")

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff("for debug purpose") end

    if (ksuto.unitExistCanAndShouldDie()) and (not ksuto.enemyPlayer()) then

        --barre 2, tech toutes postures
        ksuto.shouldHitKey(ksuto.keyH, nil, 13) --, not ksuto.targetInRange(ksuto.DUEL)) -- Arc
        ksuto.shouldHitKey(ksuto.key1, not IsCurrentAction(14) and ksuto.targetInRange(ksuto.DUEL), 14) -- activate Attack
        ksuto.shouldHitKey(ksuto.key5, ksuto.playerManaPct() > 50, 15) -- frappe héroïque
        ksuto.shouldHitKey(ksuto.key7, ksuto.playerManaPct() > 30 and ksuto.healthPercentage('target') > 20 , 19) -- bloodthirst
        ksuto.shouldHitKey(ksuto.key2, ksuto.playerManaPct() < 10 and ksuto.healthPercentage('target') > 90 and ksuto.healthPercentage('target') < 99, 18) -- bloodrage
        ksuto.shouldHitKey(ksuto.key6, not ksuto.targetHasDebuff("Demoralizing Shout") and ksuto.targetInRange(ksuto.DUEL) and ksuto.healthPercentage('target') > 20 , 23) -- mon debuff
        ksuto.shouldHitKey(ksuto.key4, not ksuto.playerHasBuff("Battle Shout"), 24) -- mon buff

        --barre 1, posture attaque
        ksuto.shouldHitKey(ksuto.key9, ksuto.playerManaPct() > 5, 75) -- overpower
        ksuto.shouldHitKey(ksuto.key8, not ksuto.targetHasDebuff("Rend") and ksuto.healthPercentage('target') > 20 , 77) -- dot
        ksuto.shouldHitShiftKey(ksuto.key8, ksuto.healthPercentage('target') < 20 and ksuto.playerManaPct() > 20 and ksuto.playerHealthPct() < ksuto.regen , 78) -- execut

    elseif (ksuto.outOfCombat()) then

        --barre 3, divers
        ksuto.shouldHitKey(ksuto.key3, ksuto.playerHealthPct() < ksuto.regen and not ksuto.playerHasBuff("Food"), 36) -- regen
        --ksuto.shouldHitKey(ksuto.key2, ksuto.playerHealthPct() > 31 and ksuto.playerHealthPct() < 60 and not ksuto.playerHasBuff("First Aid") and not ksuto.playerHasAnyDebuff(), 35) -- regen
    end
end

local function rotation2()
end

local function rotation3()
end

function ksuto.warriorRotation()

    if ksuto.spe == 1 then rotation1()
    elseif ksuto.spe == 2 then rotation2()
    elseif ksuto.spe == 3 then rotation3()
    end
end

