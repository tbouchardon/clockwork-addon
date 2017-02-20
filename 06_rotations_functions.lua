ksuto.INSPECT = 1 --28 yards
ksuto.TRADE = 2 --11.11 yards
ksuto.DUEL = 3 --9.9 yards
ksuto.FOLLOW = 4 --28 yards

function ksuto.rotation()

    -- ksuto.printDebug("function ksuto.rotation(")

    if UnitAffectingCombat("player") then ksuto.inCombat.texture:SetTexture(1, 1, 1, 1)
    else ksuto.inCombat.texture:SetTexture(0, 0, 0, 1)
    end
    ksuto.health.texture:SetTexture(1 / 100 * ksuto.healthPercentage("player"), 0, 0, 1)
    ksuto.mana.texture:SetTexture(0, 0, 1 / 100 * ksuto.manaPercentage("player"), 1)

    if ksuto.DRIVE_MOD == true
            and (ksuto.unitHasBuff("player", "Food")
            or ksuto.unitHasBuff("player", "Drink")) then
        ksuto.drive.texture:SetTexture(0, 0, 0, 1)
    elseif ksuto.DRIVE_MOD == true then
        ksuto.drive.texture:SetTexture(1, 1, 1, 1)
    end

    if (UnitAffectingCombat("player") and UnitAffectingCombat("target")) or
            (not UnitAffectingCombat("player")) then

        if UnitClass("player") == "Warlock" then ksuto.warlockAfflictionRotation()
        elseif UnitClass("player") == "Warrior" then ksuto.warriorDefRotation()
        end
    end
end

function ksuto.checkDebuffSpellCast(spell, slot)

    -- ksuto.printDebug("function ksuto.checkDebuffSpellCast(" .. tostring(spell) .. ", " .. tostring(slot))

    --    ksuto.print("ksuto.checkDebuffSpellCast(" .. tostring(spell) .. "," .. tostring(slot) .. ')')

    if not spell then return false end

    if not ksuto.unitHasDebuff("target", spell) then
        if slot ~= nil then
            return ksuto.checkActionCast(slot)
        else
            ksuto.print("Ksuto -> No slot ! (" .. tostring(spell) .. ")")
            return true
        end
    else
        return false
    end
end

function ksuto.checkTargetDistance(distance)

    -- ksuto.printDebug("function ksuto.checkTargetDistance(" .. tostring(distance))

    if CheckInteractDistance("target", distance) then
        return true
    else
        return false
    end
end

function ksuto.checkActionCast(slot)

    -- ksuto.printDebug("function ksuto.checkActionCast(" .. tostring(slot))

    ksuto.printDebug("slot = " .. tostring(slot))
    --     ksuto.printDebug("ActionHasRange(slot) = " .. tostring(ActionHasRange(slot)))
    --     ksuto.printDebug("IsActionInRange(slot) = " .. tostring(IsActionInRange(slot)))

    local canBeCast = true

    if ActionHasRange(slot) then canBeCast = IsActionInRange(slot) == 1 end

    ksuto.printDebug("canBeCast1 : " .. tostring(canBeCast))

    if canBeCast == true then

        local start, duration, enable = GetActionCooldown(slot)

        --         ksuto.printDebug("GetActionCooldown(slot) start = " .. tostring(start))
        --         ksuto.printDebug("GetActionCooldown(slot) duration = " .. tostring(duration))
        --         ksuto.printDebug("GetActionCooldown(slot) enable = " .. tostring(enable))

        canBeCast = (start == 0)
    end

    ksuto.printDebug("canBeCast2 : " .. tostring(canBeCast))

    if canBeCast == true then

        local isUsable, notEnoughMana = IsUsableAction(slot)

        --         ksuto.printDebug("IsUsableAction(slot) = isUsable " .. tostring(isUsable))
        --         ksuto.printDebug("IsUsableAction(slot) = notEnoughMana " .. tostring(notEnoughMana))

        canBeCast = (isUsable ~= nil)
    end

    ksuto.printDebug("canBeCast3 : " .. tostring(canBeCast))

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

    local percentage

    percentage = UnitHealth(unit) / UnitHealthMax(unit) * 100

    return percentage
end

function ksuto.manaPercentage(unit)

    -- ksuto.printDebug("function ksuto.manaPercentage(" .. tostring(unit)) -- or energy, rage, etc

    local percentage

    percentage = UnitMana(unit) / UnitManaMax(unit) * 100

    return percentage
end
