--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local regen = 53

local function rotation1()

    --    clockWork.printDebug("function clockWork.warriorDefRotation")

    -- if (clockWork.DEBUG_MOD) then clockWork.playerHasBuff("for debug purpose") end

    if (clockWork.unitExistCanAndShouldDie()) and (not clockWork.enemyPlayer()) then

        --barre 2, tech toutes postures
        clockWork.shouldHitKey(clockWork.keyH, nil, 13) --, not clockWork.targetInRange(clockWork.DUEL)) -- Arc
        clockWork.shouldHitKey(clockWork.key1, not IsCurrentAction(14) and clockWork.targetInRange(clockWork.DUEL), 14) -- activate Attack
        clockWork.shouldHitKey(clockWork.key5, clockWork.playerManaPct() > 50, 15) -- frappe héroïque
        clockWork.shouldHitKey(clockWork.key7, clockWork.playerManaPct() > 30 and clockWork.healthPercentage('target') > 20 , 19) -- bloodthirst
        clockWork.shouldHitKey(clockWork.key2, clockWork.playerManaPct() < 10 and clockWork.healthPercentage('target') > 90 and clockWork.healthPercentage('target') < 99, 18) -- bloodrage
        clockWork.shouldHitKey(clockWork.key6, not clockWork.targetHasDebuff("Demoralizing Shout") and clockWork.targetInRange(clockWork.DUEL) and clockWork.healthPercentage('target') > 20 , 23) -- mon debuff
        clockWork.shouldHitKey(clockWork.key4, not clockWork.playerHasBuff("Battle Shout"), 24) -- mon buff

        --barre 1, posture attaque
        clockWork.shouldHitKey(clockWork.key9, clockWork.playerManaPct() > 5, 75) -- overpower
        clockWork.shouldHitKey(clockWork.key8, not clockWork.targetHasDebuff("Rend") and clockWork.healthPercentage('target') > 20 , 77) -- dot
        clockWork.shouldHitShiftKey(clockWork.key8, clockWork.healthPercentage('target') < 20 and clockWork.playerManaPct() > 20 and clockWork.playerHealthPct() < regen, 78) -- execut

    elseif (clockWork.outOfCombat()) then

        --barre 3, divers
        clockWork.shouldHitKey(clockWork.key3, clockWork.playerHealthPct() < regen and not clockWork.playerHasBuff("Food"), 36) -- regen
        --clockWork.shouldHitKey(clockWork.key2, clockWork.playerHealthPct() > 31 and clockWork.playerHealthPct() < 60 and not clockWork.playerHasBuff("First Aid") and not clockWork.playerHasAnyDebuff(), 35) -- regen
    end
end

local function rotation2()
end

local function rotation3()
end

function clockWork.warriorRotation()

    if clockWork.spe == 1 then rotation1()
    elseif clockWork.spe == 2 then rotation2()
    elseif clockWork.spe == 3 then rotation3()
    end
end

