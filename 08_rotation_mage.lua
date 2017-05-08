--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1()

    --    ksuto.printDebug("function ksuto.mageFrostRotation")

    ksuto.updatePositionCoordinates()

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff("for debug purpose") end

    if (ksuto.targetMemberIfHealthLessThan(60)) then

        ksuto.shouldHitKey(ksuto.key9, nil, 65)

    elseif (ksuto.unitExistCanAndShouldDie()) and not (ksuto.enemyPlayer()) then

        ksuto.shouldHitKey(ksuto.key8, not ksuto.playerHasBuff("Frost Armor"), 25) -- Armure de givre
        ksuto.shouldHitKey(ksuto.key0, not ksuto.playerHasBuff("Arcane Intellect"), 37) -- Intelligence des arcanes
        -- ksuto.shouldHitKey(ksuto.key5, not IsCurrentAction(26) and ksuto.targetInRange(ksuto.DUEL), 26) -- activate Attack (juste en dessous du 25)
        ksuto.shouldHitKey(ksuto.key1, ksuto.targetInRange(ksuto.FOLLOW), 1) -- �claire de givre
        ksuto.shouldHitKey(ksuto.key4, ksuto.healthPercentage('target') < 95, 4) -- Trait de feu
        ksuto.shouldHitKey(ksuto.key9, ksuto.playerHealthPct() < 60 and not ksuto.playerHasBuff("Mana Shield"), 65) -- bouclier de mana

        elses

        ksuto .resetKeys()
        ksuto.shouldHitKey(ksuto.key7, ksuto.playerManaPct() < 60 and not ksuto.playerHasBuff("Drink"), 60) -- regen mana
        ksuto.shouldHitKey(ksuto.key6, ksuto.playerHealthPct() < 60 and not ksuto.playerHasBuff("Food"), 59) -- regen vie
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
