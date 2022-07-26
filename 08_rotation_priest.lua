				--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()


    --    clockWork.printDebug("function clockWork.priestRotation")

    -- if (clockWork.DEBUG_MOD) then clockWork.playerHasBuff("for debug purpose") end

    if (clockWork.unitExistCanAndShouldDie()) and not (clockWork.enemyPlayer()) then

        
		clockWork.shouldHitKey(clockWork.key8, not clockWork.playerHasBuff("Power Word: Fortitude"), 25) -- Endurance
		clockWork.shouldHitKey(clockWork.key0, not clockWork.playerHasBuff("Inner Fire"), 37) -- feu intérieur
		clockWork.shouldHitKey(clockWork.key5, not IsCurrentAction(26) and clockWork.targetInRange(clockWork.DUEL), 26) -- activate Attack
        clockWork.shouldHitKey(clockWork.key1, clockWork.healthPercentage('target') < 99, 1) -- Chatiment
		clockWork.shouldHitKey(clockWork.key3, clockWork.healthPercentage('target') > 99, 3) -- Flamme sacrée
        clockWork.shouldHitKey(clockWork.key2, clockWork.healthPercentage('target') < 99 and clockWork.healthPercentage('target') > 25 and not clockWork.targetHasDebuff("Shadow Word: Pain"), 2) -- Mot de douleur
        clockWork.shouldHitKey(clockWork.key4, not clockWork.playerHasBuff("Power Word: Shield") and not clockWork.playerHasDebuff("Weakened Soul") and clockWork.healthPercentage('target') > 20, 4 ) -- Bouclier
		clockWork.shouldHitKey(clockWork.key9, clockWork.playerHealthPct() < 55, 65) -- soins rapide
		clockWork.shouldHitKey(clockWork.key6, clockWork.healthPercentage('target') < 99 and clockWork.healthPercentage('target') > 65, 59) -- Peste dévorante
		
    elseif (clockWork.outOfCombat()) then
		
        clockWork.shouldHitKey(clockWork.key7, clockWork.playerManaPct() < 35 and not clockWork.playerHasBuff("Drink"), 60) -- regen mana
		clockWork.shouldHitKey(clockWork.key8, not clockWork.playerHasBuff("Power Word: Fortitude"), 25) -- Endurance
        

    end
end

local function rotation2()
end

local function rotation3()
end

function clockWork.priestRotation()

    if clockWork.spe == 1 then rotation1()
    elseif clockWork.spe == 2 then rotation2()
    elseif clockWork.spe == 3 then rotation3()
    end
end
