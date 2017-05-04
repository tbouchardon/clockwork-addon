--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()

    --    ksuto.printDebug("function ksuto.mageRotation")

    ksuto.updatePositionCoordinates()

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff("for debug purpose") end

    if (ksuto.targetMemberIfHealthLessThan(60)) then

        ksuto.shouldHitKey(ksuto.key9, nil, 65)

    elseif (ksuto.unitExistCanAndShouldDie()) and not (ksuto.enemyPlayer()) then

        ksuto.shouldHitKey(ksuto.key9, ksuto.playerHealthPct() < 50, 65) -- je me soigne (barre d'action bas gauche, 5e icone)
        ksuto.shouldHitKey(ksuto.key8, not ksuto.playerHasBuff("Lightning Shield") and ksuto.playerManaPct() > 20, 25) -- bouclier de foudre (tout en haut barre verticale droite)
        ksuto.shouldHitKey(ksuto.key7, not ksuto.hasMainHandEnchant() and ksuto.playerManaPct() > 15, 60) -- Windfury Weapon
		ksuto.shouldHitKey(ksuto.key5, not IsCurrentAction(26) and ksuto.targetInRange(ksuto.DUEL), 26) -- activate Attack (juste en dessous du 25)
        ksuto.shouldHitKey(ksuto.key3, ksuto.healthPercentage('target') < 98 and ksuto.healthPercentage('target') > 18 and not ksuto.targetHasDebuff("Flame Shock") and ksuto.playerManaPct() > 20, 3) -- orion de feu
        ksuto.shouldHitKey(ksuto.key1, ksuto.playerManaPct() > 30 and ksuto.healthPercentage('target') > 90, 1) -- chaine éclaire

    elseif (ksuto.outOfCombat()) then

        ksuto.shouldHitKey(ksuto.key6, ksuto.playerManaPct() < 25 and not ksuto.playerHasBuff("Drink"), 59) -- regen (barre en bas à droite 6e icone)
    end
end

local function rotation2()
end

local function rotation3()
end

function ksuto.mageRotation()

    if ksuto.spe == 1 then rotation1()
    elseif ksuto.spe == 2 then rotation2()
    elseif ksuto.spe == 3 then rotation3()
    end
end
