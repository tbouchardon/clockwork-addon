--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()

    --    clockWork.printDebug("function clockWork.shamanHealRotation")

    -- if (clockWork.DEBUG_MOD) then clockWork.playerHasBuff("for debug purpose") end

    if (clockWork.targetMemberIfHealthLessThan(60)) then
	
		clockWork.shouldHitKey(clockWork.key9, nil, 65)

    elseif (clockWork.unitExistCanAndShouldDie()) and not (clockWork.enemyPlayer()) then

        clockWork.shouldHitKey(clockWork.key9, clockWork.playerHealthPct() < 30, 65) -- je me soigne (barre d'action bas gauche, 5e icone)
        clockWork.shouldHitKey(clockWork.key8, not clockWork.playerHasBuff("Lightning Shield") and clockWork.playerManaPct() > 18, 25) -- bouclier de foudre (tout en haut barre verticale droite)
        clockWork.shouldHitKey(clockWork.key7, not clockWork.hasMainHandEnchant() and clockWork.playerManaPct() > 10, 60) -- Windfury Weapon (barre bas droite, derni�re icone)
        clockWork.shouldHitKey(clockWork.key5, not IsCurrentAction(26) and clockWork.targetInRange(clockWork.DUEL), 26) -- activate Attack (juste en dessous du 25)
        clockWork.shouldHitKey(clockWork.key3, clockWork.healthPercentage('target') < 98 and clockWork.healthPercentage('target') > 15 and not clockWork.targetHasDebuff("Flame Shock") and clockWork.playerManaPct() > 18, 3) -- orion de feu
        clockWork.shouldHitKey(clockWork.key1, clockWork.playerManaPct() > 30 and clockWork.healthPercentage('target') > 90, 1) -- chaine �claire
        clockWork.shouldHitKey(clockWork.key0, clockWork.playerManaPct() < 65, 37) -- Totem regen mana
        clockWork.shouldHitKey(clockWork.key2, clockWork.healthPercentage('target') < 98 and clockWork.healthPercentage('target') > 50, 2) -- Blood Fury (racial)
        clockWork.shouldHitKey(clockWork.key4, clockWork.playerHealthPct() < 55, 4) -- Nature's Swiftness

    elseif (clockWork.outOfCombat()) then

        clockWork.shouldHitKey(clockWork.key6, clockWork.playerManaPct() < 35 and not clockWork.playerHasBuff("Drink"), 59) -- regen (barre en bas � droite, avant derni�re icone)
    end
end

local function rotation2()
end

local function rotation3()
end

function clockWork.shamanRotation()

    if clockWork.spe == 1 then rotation1()
    elseif clockWork.spe == 2 then rotation2()
    elseif clockWork.spe == 3 then rotation3()
    end
end
