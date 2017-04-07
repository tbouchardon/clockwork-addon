--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

function ksuto.warriorDefRotation()

    --    ksuto.printDebug("function ksuto.warriorDefRotation")

    ksuto.updatePositionCoordinates()

    -- if (ksuto.DEBUG_MOD) then ksuto.playerHasBuff("for debug purpose") end

    if (ksuto.unitExistCanAndShouldDie()) and not (ksuto.enemyPlayer()) then
    
        --barre 2, tech toutes postures
        ksuto.shouldHitKey(ksuto.keyH, nil, 13) --, not ksuto.targetInRange(ksuto.DUEL)) -- Arc
        ksuto.shouldHitKey(ksuto.key1, not IsCurrentAction(14) and ksuto.targetInRange(ksuto.DUEL), 14) -- activate Attack
        ksuto.shouldHitKey(ksuto.key5, ksuto.playerManaPct() > 40, 15) -- frappe héroïque
        ksuto.shouldHitKey(ksuto.key6, not ksuto.targetHasDebuff("Demoralizing Shout"), 23) -- mon debuff
        ksuto.shouldHitKey(ksuto.key4, not ksuto.playerHasBuff("Battle Shout"), 24) -- mon buff
        
        --barre 1, posture attaque
        ksuto.shouldHitKey(ksuto.key9, ksuto.playerManaPct() > 5, 75) -- overpower (/!\ doute sur l'emplacement, à vérifier)
        ksuto.shouldHitKey(ksuto.key8, not ksuto.targetHasDebuff("Rend"), 77) -- dot

    else

        ksuto.resetKeys()
        --barre 3, divers
        ksuto.shouldHitKey(ksuto.key3, ksuto.playerHealthPct() < 30 and not ksuto.playerHasBuff("Food"), 36) -- regen
        ksuto.shouldHitKey(ksuto.key2, ksuto.playerHealthPct() > 31 and ksuto.playerHealthPct() < 60 and not ksuto.playerHasBuff("Bandage") and not ksuto.playerHasAnyDebuff(), 35) -- regen
    end
end

