				--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()


    --    ksuto.printDebug("function ksuto.priestRotation")

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff("for debug purpose") end

    if (ksuto.unitExistCanAndShouldDie()) and not (ksuto.enemyPlayer()) then

        
		ksuto.shouldHitKey(ksuto.key8, not ksuto.playerHasBuff("Power Word: Fortitude"), 25) -- Endurance
		ksuto.shouldHitKey(ksuto.key0, not ksuto.playerHasBuff("Inner Fire"), 37) -- feu intérieur
		ksuto.shouldHitKey(ksuto.key5, not IsCurrentAction(26) and ksuto.targetInRange(ksuto.DUEL), 26) -- activate Attack
        ksuto.shouldHitKey(ksuto.key1, ksuto.healthPercentage('target') < 99, 1) -- Chatiment
		ksuto.shouldHitKey(ksuto.key3, ksuto.healthPercentage('target') > 99, 3) -- Flamme sacrée
        ksuto.shouldHitKey(ksuto.key2, ksuto.healthPercentage('target') < 99 and ksuto.healthPercentage('target') > 25 and not ksuto.targetHasDebuff("Shadow Word: Pain"), 2) -- Mot de douleur
        ksuto.shouldHitKey(ksuto.key4, not ksuto.playerHasBuff("Power Word: Shield") and not ksuto.playerHasDebuff("Weakened Soul") and ksuto.healthPercentage('target') > 20, 4 ) -- Bouclier
		ksuto.shouldHitKey(ksuto.key9, ksuto.playerHealthPct() < 55, 65) -- soins rapide
		ksuto.shouldHitKey(ksuto.key6, ksuto.healthPercentage('target') < 99 and ksuto.healthPercentage('target') > 65, 59) -- Peste dévorante
		
    elseif (ksuto.outOfCombat()) then
		
        ksuto.shouldHitKey(ksuto.key7, ksuto.playerManaPct() < 35 and not ksuto.playerHasBuff("Drink"), 60) -- regen mana
		ksuto.shouldHitKey(ksuto.key8, not ksuto.playerHasBuff("Power Word: Fortitude"), 25) -- Endurance 
        

    end
end

local function rotation2()
end

local function rotation3()
end

function ksuto.priestRotation()

    if ksuto.spe == 1 then rotation1()
    elseif ksuto.spe == 2 then rotation2()
    elseif ksuto.spe == 3 then rotation3()
    end
end
