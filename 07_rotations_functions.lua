ksuto.INSPECT = 1 --28 yards
ksuto.TRADE = 2 --11.11 yards
ksuto.DUEL = 3 --9.9 yards
ksuto.FOLLOW = 4 --28 yards

function ksuto.rotation()

    -- ksuto.printDebug("function ksuto.rotation(")

    if UnitAffectingCombat("player") then
        ksuto.inCombat.texture:SetTexture(1, 1, 1, 1)
        ksuto.wasInCombat = true
    else
        ksuto.resetCombat()
    end

    ksuto.playerHealth.texture:SetTexture(1 / 100 * ksuto.healthPercentage("player"), 0, 0, 1)
    ksuto.playerMana.texture:SetTexture(0, 0, 1 / 100 * ksuto.manaPercentage("player"), 1)

    --    ksuto.print(tostring(ksuto.targetHostile()) .. tostring(ksuto.targetNeutral()))

    if (UnitExists("target") and not UnitIsUnit("player", "target")) then
        if (ksuto.targetUnfriendly()) then ksuto.targetReaction.texture:SetTexture(1, 0, 0, 1)
        elseif (ksuto.targetNeutral()) then ksuto.targetReaction.texture:SetTexture(1, 1, 0, 1)
        elseif (ksuto.targetFriendly()) then ksuto.targetReaction.texture:SetTexture(0, 1, 0, 1)
        else ksuto.targetReaction.texture:SetTexture(0, 0, 0, 1)
        end

        ksuto.targetHealth.texture:SetTexture(1 / 100 * ksuto.healthPercentage("target"), 0, 0, 1)
        ksuto.targetMana.texture:SetTexture(0, 0, 1 / 100 * ksuto.manaPercentage("target"), 1)
    else
        ksuto.targetReaction.texture:SetTexture(0, 0, 0, 1)
        ksuto.targetHealth.texture:SetTexture(0, 0, 0, 1)
        ksuto.targetMana.texture:SetTexture(0, 0, 0, 1)
    end

    if ksuto.DRIVE_MOD == true
            and (ksuto.unitHasBuff("player", "Food")
            or ksuto.unitHasBuff("player", "Drink")) then
        ksuto.drive.texture:SetTexture(0, 0, 0, 1)
    elseif ksuto.DRIVE_MOD == true then
        ksuto.drive.texture:SetTexture(1, 1, 1, 1)
    end

    -- Ne rien faire si un cast est déjà en cours
    if (ksuto.CASTING == true) then
        ksuto.resetKeys();
        return;
    end

    -- Ne lancer la rotation que si le joueur est hors combat, ou la cible ET le joueur en combat
    if (UnitAffectingCombat("player") and UnitAffectingCombat("target")) or
            (not UnitAffectingCombat("player")) then

        if UnitClass("player") == "Warlock" then ksuto.warlockAfflictionRotation()
        elseif UnitClass("player") == "Warrior" then ksuto.warriorDefRotation()
        elseif UnitClass("player") == "Shaman" then ksuto.shamanHealRotation()
        end
    end
end

function ksuto.debuffCanBeCast(spell, slot)

    -- ksuto.printDebug("function ksuto.debuffCanBeCast(" .. tostring(spell) .. ", " .. tostring(slot))

    --    ksuto.print("ksuto.debuffCanBeCast(" .. tostring(spell) .. "," .. tostring(slot) .. ')')

    if not spell then return false end

    if not ksuto.unitHasDebuff("target", spell) then
        if slot ~= nil then
            return ksuto.actionCanBeCast(slot)
        else
            ksuto.print("Ksuto -> No slot ! (" .. tostring(spell) .. ")")
            return true
        end
    else
        return false
    end
end

function ksuto.targetInRange(distance)

    -- ksuto.printDebug("function ksuto.targetInRange(" .. tostring(distance))

    if CheckInteractDistance("target", distance) then
        return true
    else
        return false
    end
end

function ksuto.actionCanBeCast(slot)

    --    ksuto.printDebug("function ksuto.actionCanBeCast(" .. tostring(slot))

    if (ksuto.CHECK_ACTIONS_CAST == false) then return true end

    --    ksuto.printDebug("slot = " .. tostring(slot))
    --    ksuto.printDebug("ActionHasRange(slot) = " .. tostring(ActionHasRange(slot)))
    --    ksuto.printDebug("IsActionInRange(slot) = " .. tostring(IsActionInRange(slot)))

    local canBeCast = true

    if ActionHasRange(slot) then canBeCast = IsActionInRange(slot) == 1 end

    --    ksuto.printDebug("canBeCast1 : " .. tostring(canBeCast))

    if canBeCast == true then

        local start, duration, enable = GetActionCooldown(slot)

        --         ksuto.printDebug("GetActionCooldown(slot) start = " .. tostring(start))
        --         ksuto.printDebug("GetActionCooldown(slot) duration = " .. tostring(duration))
        --         ksuto.printDebug("GetActionCooldown(slot) enable = " .. tostring(enable))

        canBeCast = (start == 0)
    end

    --    ksuto.printDebug("canBeCast2 : " .. tostring(canBeCast))

    if canBeCast == true then

        local isUsable, notEnoughMana = IsUsableAction(slot)

        --         ksuto.printDebug("IsUsableAction(slot) = isUsable " .. tostring(isUsable))
        --         ksuto.printDebug("IsUsableAction(slot) = notEnoughMana " .. tostring(notEnoughMana))

        canBeCast = (isUsable ~= nil)
    end

    --    ksuto.printDebug("canBeCast3 : " .. tostring(canBeCast))

    return canBeCast
end

function ksuto.enemyPlayer()

    -- ksuto.printDebug("function ksuto.enemyPlayer(")

    if UnitIsPlayer("target") then
        return true
    else
        return false
    end
end

function ksuto.healthPercentage(unit)

    -- ksuto.printDebug("function ksuto.healthPercentage(" .. tostring(unit))

    if (UnitHealth(unit) == 0) then return 0 end

    local percentage

    percentage = UnitHealth(unit) / UnitHealthMax(unit) * 100

    return percentage
end

function ksuto.playerHealthPct()

    return ksuto.healthPercentage("player")
end

function ksuto.manaPercentage(unit)

    -- ksuto.printDebug("function ksuto.manaPercentage(" .. tostring(unit)) -- or energy, rage, etc

    if (UnitMana(unit) == 0) then return 0 end

    local percentage

    percentage = UnitMana(unit) / UnitManaMax(unit) * 100

    return percentage
end

function ksuto.playerManaPct()

    return ksuto.manaPercentage("player")
end

function ksuto.unitExistCanAndShouldDie()
    return UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player") and -- > La cible ET le joueur sont vivants (>_<)
            (not UnitIsTapped("target") or (UnitIsTapped("target") and UnitIsTappedByPlayer("target"))) and -- > La cible n'est pas marquée OU est marquée par le joueur.
            (ksuto.targetNeutral() or ksuto.targetUnfriendly()) -- > La cible est un enemi (rouge uniquement)
end

function ksuto.targetUnfriendly()

    if not UnitExists("target") then return false end

    return UnitReaction("player", "target") < 4
end

function ksuto.targetNeutral()

    if not UnitExists("target") then return false end

    return UnitReaction("player", "target") == 4
end

function ksuto.targetFriendly()

    if not UnitExists("target") then return false end

    return UnitReaction("player", "target") > 4
end

function ksuto.resetCombat()

    ksuto.inCombat.texture:SetTexture(0, 0, 0, 1)
    ksuto.wasInCombat = false
    ksuto.selfHit = time()
    ksuto.creatureHit = time()
    ksuto.deltaSelfHitCreatureHit = 0
end
