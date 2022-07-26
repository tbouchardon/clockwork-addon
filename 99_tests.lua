--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 05/05/2017
-- Time: 10:03
-- To change this template use File | Settings | File Templates.
--

function initRotationsFrame()

    for action in ClockWork_ROTATIONS.actions do

        local line = CreateFrame("Frame", action.shift .. action.ctrl .. action.alt .. action.key, "ClockWorkRotationFrame")
    end
end

function testRotation(spe)

    for condition in spe.contitions do

        local idValid = false;

        if condition.enemyPlayer then end
        if condition.hasMainHandEnchant then end
        if condition.hasOffHandEnchant then end
        if condition.healthPercentage.unit then end
        if condition.manaPercentage.unit then end
        if condition.outOfCombat then end
        if condition.unitHasBuff.unit then end
        if condition.unitHasDebuff.unit then end
        if condition.unitReaction then end
    end
end

