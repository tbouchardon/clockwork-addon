					--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1() -- Sp Feu
	
	--    clockWork.printDebug("function clockWork.mageRotation2")

    -- if (clockWork.DEBUG_MOD) then clockWork.playerHasBuff("for debug purpose") end

    if (clockWork.unitExistCanAndShouldDie()) and not (clockWork.enemyPlayer()) then

		clockWork.shouldHitKey(clockWork.key8, not clockWork.playerHasBuff("Mage Armor"), 25) -- Armure du mage
        clockWork.shouldHitKey(clockWork.key0, not clockWork.playerHasBuff("Arcane Intellect"), 37) -- Intelligence des arcanes
		clockWork.shouldHitKey(clockWork.key9, not clockWork.playerHasBuff("Combustion"), 65) -- Combustion
		clockWork.shouldHitKey(clockWork.key5, not IsCurrentAction(26) and clockWork.targetInRange(clockWork.DUEL), 26) -- activate Attack (juste en dessous du 25)
        clockWork.shouldHitKey(clockWork.key3, clockWork.healthPercentage('target') > 99, 3) -- Pyro
		clockWork.shouldHitKey(clockWork.key1, clockWork.healthPercentage('target') > 15, 1) -- eclaire de feu
		clockWork.shouldHitKey(clockWork.key2, clockWork.healthPercentage('target') < 16, 2) -- brulure
        clockWork.shouldHitKey(clockWork.key4, clockWork.healthPercentage('target') < 90, 4) -- Trait de feu
        -- clockWork.shouldHitKey(clockWork.key9, clockWork.playerHealthPct() < 30 and not clockWork.playerHasBuff("Mana Shield"), 65) -- bouclier de mana
		
    elseif (clockWork.outOfCombat()) then
		
		 -- clockWork.shouldHitKey(clockWork.key3, clockWork.playerManaPct() < 40, 3) -- Evocation
        clockWork.shouldHitKey(clockWork.key7, clockWork.playerManaPct() < 60 and not clockWork.playerHasBuff("Drink"), 60) -- regen mana
        clockWork.shouldHitKey(clockWork.key6, clockWork.playerHealthPct() < 70 and not clockWork.playerHasBuff("Food"), 59) -- regen vie
        
		
		
		
    end
end

---------------------------------------------------------------------------------------------------------------------
local function rotation2() -- Sp Givre

	--    clockWork.printDebug("function clockWork.mageRotation")

    -- if (clockWork.DEBUG_MOD) then clockWork.playerHasBuff("for debug purpose") end

    if (clockWork.unitExistCanAndShouldDie()) and not (clockWork.enemyPlayer()) then

        clockWork.shouldHitKey(clockWork.key5, not IsCurrentAction(26) and clockWork.targetInRange(clockWork.DUEL), 26) -- activate Attack (juste en dessous du 25)
        clockWork.shouldHitKey(clockWork.key1, clockWork.healthPercentage('target') > 15, 1) -- eclaire de givre
	clockWork.shouldHitKey(clockWork.key2, clockWork.healthPercentage('target') < 16, 2) -- brulure
        clockWork.shouldHitKey(clockWork.key4, clockWork.healthPercentage('target') < 80, 4) -- Trait de feu
        clockWork.shouldHitKey(clockWork.key9, clockWork.playerHealthPct() < 30 and not clockWork.playerHasBuff("Mana Shield"), 65) -- bouclier de mana
		
    elseif (clockWork.outOfCombat()) then
		
		 -- clockWork.shouldHitKey(clockWork.key3, clockWork.playerManaPct() < 40, 3) -- Evocation
        clockWork.shouldHitKey(clockWork.key7, clockWork.playerManaPct() < 60 and not clockWork.playerHasBuff("Drink"), 60) -- regen mana
        clockWork.shouldHitKey(clockWork.key6, clockWork.playerHealthPct() < 70 and not clockWork.playerHasBuff("Food"), 59) -- regen vie
        clockWork.shouldHitKey(clockWork.key8, not clockWork.playerHasBuff("Frost Armor"), 25) -- Armure de givre
        clockWork.shouldHitKey(clockWork.key0, not clockWork.playerHasBuff("Arcane Intellect"), 37) -- Intelligence des arcanes
	end
end

local function rotation3()
end

function clockWork.mageRotation()

    if clockWork.spe == 1 then rotation1()
    elseif clockWork.spe == 2 then rotation2()
    elseif clockWork.spe == 3 then rotation3()
    end
end
