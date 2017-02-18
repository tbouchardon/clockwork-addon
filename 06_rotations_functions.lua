ksuto.INSPECT = 1 --28 yards
ksuto.TRADE = 2 --11.11 yards
ksuto.DUEL = 3 --9.9 yards
ksuto.FOLLOW = 4 --28 yards

function ksuto.rotation()

    ksuto.printDebug("UnitClass : " .. UnitClass("player"))

    if UnitAffectingCombat("player") then ksuto.inCombat.texture:SetTexture(1, 1, 1, 1)
    else ksuto.inCombat.texture:SetTexture(0, 0, 0, 1)
    end
    ksuto.health.texture:SetTexture(1 / 100 * ksuto.healthPercentage("player"), 0, 0, 1)
    ksuto.mana.texture:SetTexture(0, 0, 1 / 100 * ksuto.manaPercentage("player"), 1)

    if (UnitAffectingCombat("player") and UnitAffectingCombat("target")) or
            (not UnitAffectingCombat("player")) then

        if UnitClass("player") == "Warlock" then ksuto.warlockAfflictionRotation()
        elseif UnitClass("player") == "Warrior" then ksuto.warriorDefRotation()
        end
    end
end

function ksuto.checkDebuffSpellCast(spell, slot)

    if not spell then return false end

    if not ksuto.unitHasDebuff("target", spell) then
        if slot ~= nil then
            return ksuto.checkActionCast(slot)
        else
            ksuto.print("Ksuto -> No slot !")
            return true
        end
    else
        return false
    end
end

function ksuto.checkTargetDistance(distance)

    if CheckInteractDistance("target", distance) then
        return true
    else
        return false
    end
end

function ksuto.checkActionCast(slot)

    -- ksuto.printDebug("ActionHasRange(slot) = " .. ActionHasRange(slot))
    -- ksuto.printDebug("IsActionInRange(slot) = " .. IsActionInRange(slot))

    local canBeCast

    if ActionHasRange(slot) then canBeCast = IsActionInRange(slot) == 1 end

    if canBeCast == true then

        local start, duration, enable = GetActionCooldown(slot)

        -- ksuto.printDebug("GetActionCooldown(slot) start = " .. tostring(start))
        -- ksuto.printDebug("GetActionCooldown(slot) duration = " .. tostring(duration))
        -- ksuto.printDebug("GetActionCooldown(slot) enable = " .. tostring(enable))

        canBeCast = (start == 0)
    end

    if canBeCast == true then

        local isUsable, notEnoughMana = IsUsableAction(slot)

        -- ksuto.printDebug("IsUsableAction(slot) = isUsable " .. tostring(isUsable))
        -- ksuto.printDebug("IsUsableAction(slot) = notEnoughMana " .. tostring(notEnoughMana))

        canBeCast = (isUsable ~= nil)
    end

    return canBeCast
end

function ksuto.enemyPlayer()

    if UnitIsPlayer("target") then
        return true
    else
        return false
    end
end

function ksuto.healthPercentage(unit)

    local percentage

    percentage = UnitHealth(unit) / UnitHealthMax(unit) * 100

    return percentage
end

function ksuto.manaPercentage(unit) -- or energy, rage, etc

    local percentage

    percentage = UnitMana(unit) / UnitManaMax(unit) * 100

    return percentage
end
