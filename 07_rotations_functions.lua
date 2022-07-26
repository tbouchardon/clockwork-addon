clockWork.INSPECT = 1 --28 yards
clockWork.TRADE = 2 --11.11 yards
clockWork.DUEL = 3 --9.9 yards
clockWork.FOLLOW = 4 --28 yards

clockWork.spe = 1

function clockWork.rotation()

    --clockWork.printDebug("function clockWork.rotation()")

    if UnitAffectingCombat("player") then
        clockWork.inCombat.texture:SetColorTexture(1, 1, 1, 1)
        clockWork.wasInCombat = true
    else
        clockWork.resetCombat()
    end

    if UnitExists("raid1") then
        clockWork.updateRaidHealth()
    elseif UnitExists("party1") then
        clockWork.updatePartyHealth()
    else
        clockWork.checkUnitHealth("player", -1)
    end

    clockWork.playerHealth.texture:SetColorTexture(1 / 100 * clockWork.healthPercentage("player"), 0, 0, 1)
    clockWork.playerMana.texture:SetColorTexture(0, 0, 1 / 100 * clockWork.manaPercentage("player"), 1)

    --    clockWork.print(tostring(clockWork.targetHostile()) .. tostring(clockWork.targetNeutral()))

    if (UnitExists("target") and not UnitIsUnit("player", "target")) then
        if (clockWork.targetUnfriendly()) then
            clockWork.targetReaction.texture:SetColorTexture(1, 0, 0, 1)
        elseif (clockWork.targetNeutral()) then
            clockWork.targetReaction.texture:SetColorTexture(1, 1, 0, 1)
        elseif (clockWork.targetFriendly()) then
            clockWork.targetReaction.texture:SetColorTexture(0, 1, 0, 1)
        else
            clockWork.targetReaction.texture:SetColorTexture(0, 0, 0, 1)
        end

        clockWork.targetHealth.texture:SetColorTexture(1 / 100 * clockWork.healthPercentage("target"), 0, 0, 1)
        clockWork.targetMana.texture:SetColorTexture(0, 0, 1 / 100 * clockWork.manaPercentage("target"), 1)
    else
        clockWork.targetReaction.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.targetHealth.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.targetMana.texture:SetColorTexture(0, 0, 0, 1)
    end

    if clockWork.DRIVE_MOD == true
            and ((clockWork.unitHasBuff("player", "Food") and (clockWork.playerHealthPct() < 100))
            or (clockWork.unitHasBuff("player", "Drink") and (clockWork.playerManaPct() < 100))) then
        clockWork.drive.texture:SetColorTexture(0, 0, 0, 1)
    elseif clockWork.DRIVE_MOD == true then
        clockWork.drive.texture:SetColorTexture(1, 1, 1, 1)
    end

    -- Ne rien faire si un cast est déjà en cours
    if (clockWork.CASTING == true) then
        clockWork.resetKeys();
        return ;
    end

    clockWork.resetKeys()

    --clockWork.printDebug("UnitAffectingCombat(\"player\")" .. tostring(UnitAffectingCombat("player")))
    --clockWork.printDebug("UnitAffectingCombat(\"target\")" .. tostring(UnitAffectingCombat("target")))
    --clockWork.printDebug("UnitClass(\"player\")" .. tostring(UnitClass("player")))

    if (IsMounted()) then
        return
    end

    -- Ne lancer la rotation que si le joueur est hors combat, ou la cible ET le joueur en combat
    if (clockWork.AGGRO_MOD or clockWork.bothPlayerAndTargetInCombat() or clockWork.playerNotInCombat()) then

        if UnitClass("player") == "Démoniste" then
            clockWork.warlockRotation()
            --elseif UnitClass("player") == "Warrior" then
            --    clockWork.warriorRotation()
            --elseif UnitClass("player") == "Shaman" then
            --    clockWork.shamanRotation()
            --elseif UnitClass("player") == "Mage" then
            --    clockWork.mageRotation()
            --elseif UnitClass("player") == "Priest" then
            --    clockWork.priestRotation()
        end
    end
end

function clockWork.bothPlayerAndTargetInCombat()

    return UnitAffectingCombat("player") and UnitAffectingCombat("target")

end

function clockWork.playerNotInCombat()

    return not UnitAffectingCombat("player")

end

function clockWork.debuffCanBeCast(spell, slot)

    -- clockWork.printDebug("function clockWork.debuffCanBeCast(" .. tostring(spell) .. ", " .. tostring(slot))

    --    clockWork.print("clockWork.debuffCanBeCast(" .. tostring(spell) .. "," .. tostring(slot) .. ')')

    if not spell then
        return false
    end

    if not clockWork.unitHasDebuff("target", spell) then
        if slot ~= nil then
            return clockWork.actionCanBeCast(slot)
        else
            clockWork.print("No slot ! (" .. tostring(spell) .. ")")
            return true
        end
    else
        return false
    end
end

function clockWork.targetInRange(distance)

    -- clockWork.printDebug("function clockWork.targetInRange(" .. tostring(distance))

    if CheckInteractDistance("target", distance) then
        return true
    else
        return false
    end
end

function clockWork.actionCanBeCast(slot)

    clockWork.printDebug("function clockWork.actionCanBeCast(" .. tostring(slot))

    if (clockWork.CHECK_ACTIONS_CAST == false) then
        return true
    end

    clockWork.printDebug("slot = " .. tostring(slot))
    local actionType, id, subType = GetActionInfo(slot)
    local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(id)
    clockWork.printDebug(tostring(actionType) .. ": " .. tostring(name) .. " (" .. tostring(spellID) .. ") ")
    clockWork.printDebug("ActionHasRange(slot) = " .. tostring(ActionHasRange(slot)))
    clockWork.printDebug("IsActionInRange(slot) = " .. tostring(IsActionInRange(slot)))

    local canBeCast = true

    if ActionHasRange(slot) then
        canBeCast = IsActionInRange(slot) ~= false -- Can be true or nil
    end

    --clockWork.printDebug("canBeCast1 : " .. tostring(canBeCast))

    if canBeCast == true then

        local start, duration, enable = GetActionCooldown(slot)

        --         clockWork.printDebug("GetActionCooldown(slot) start = " .. tostring(start))
        --         clockWork.printDebug("GetActionCooldown(slot) duration = " .. tostring(duration))
        --         clockWork.printDebug("GetActionCooldown(slot) enable = " .. tostring(enable))

        canBeCast = (start == 0)
    end

    --clockWork.printDebug("canBeCast2 : " .. tostring(canBeCast))

    if canBeCast == true then

        local isUsable, notEnoughMana = IsUsableAction(slot)

        --         clockWork.printDebug("IsUsableAction(slot) = isUsable " .. tostring(isUsable))
        --         clockWork.printDebug("IsUsableAction(slot) = notEnoughMana " .. tostring(notEnoughMana))

        canBeCast = (isUsable ~= nil)
    end

    if (canBeCast == true) then
        if castTime ~= 0 then
            canBeCast = clockWork.player.isMoving == false
        end
    end

    --clockWork.printDebug("canBeCast3 : " .. tostring(canBeCast))

    return canBeCast
end

function clockWork.enemyPlayer()

    -- clockWork.printDebug("function clockWork.enemyPlayer(")

    if UnitIsPlayer("target") then
        return true
    else
        return false
    end
end

function clockWork.healthPercentage(unit)

    -- clockWork.printDebug("function clockWork.healthPercentage(" .. tostring(unit))

    if (UnitHealth(unit) == 0) then
        return 0
    end

    local percentage

    percentage = UnitHealth(unit) / UnitHealthMax(unit) * 100

    return percentage
end

function clockWork.playerHealthPct()

    return clockWork.healthPercentage("player")
end

function clockWork.manaPercentage(unit)

    -- clockWork.printDebug("function clockWork.manaPercentage(" .. tostring(unit)) -- or energy, rage, etc

    local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
    local power = UnitPower(unit, powerType)
    local powerMax = UnitPowerMax(unit, powerType)

    if (powerType == -1) then
        return 0
    end

    local percentage

    percentage = power / powerMax * 100

    return percentage
end

function clockWork.playerManaPct()

    return clockWork.manaPercentage("player")
end

function clockWork.unitExistCanAndShouldDie()
    return UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player") and -- > La cible ET le joueur sont vivants (>_<)
            (not UnitIsTapDenied("target")) and -- > La cible peut être marquée par le joueur.
            (clockWork.targetNeutral() or clockWork.targetUnfriendly()) -- > La cible est un enemi (rouge uniquement)
end

function clockWork.targetUnfriendly()

    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") < 4
end

function clockWork.targetNeutral()

    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") == 4
end

function clockWork.targetFriendly()

    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") > 4
end

function clockWork.resetCombat()

    clockWork.inCombat.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.wasInCombat = false
    clockWork.lastTimePlayerHit = time()
    clockWork.lastTimePlayerHasBeenHit = time()
    clockWork.durationBeingHitWithoutRetaliating = 0
end

clockWork.lowestMemberHealth = 100
clockWork.lowestMemberHealthIndex = nil

function clockWork.updatePartyHealth()

    clockWork.lowestMemberHealth = 100
    clockWork.lowestMemberHealthIndex = nil

    clockWork.checkUnitHealth("player", -1)

    for index = 1, 4 do

        clockWork.checkUnitHealth("party" .. tostring(index), index)
        clockWork.raid[index].texture:SetColorTexture(1 / 100 * clockWork.healthPercentage("party" .. tostring(index)), 0, 0, 1)
    end
end

function clockWork.updateRaidHealth()

    clockWork.lowestMemberHealth = 100
    clockWork.lowestMemberHealthIndex = nil

    clockWork.checkUnitHealth("player", -1)

    for index = 1, 40 do

        clockWork.checkUnitHealth("raid" .. tostring(index), index)
        clockWork.raid[index].texture:SetColorTexture(1 / 100 * clockWork.healthPercentage("raid" .. tostring(index)), 0, 0, 1)
    end
end

function clockWork.checkUnitHealth(unit, index)

    if UnitExists(unit) then
        if clockWork.healthPercentage(unit) < clockWork.lowestMemberHealth then
            clockWork.lowestMemberHealth = clockWork.healthPercentage(unit)
            clockWork.lowestMemberHealthIndex = index
        end
    end
end

function clockWork.targetMember(index)

    local root = ""
    if UnitExists("raid1") then
        root = "raid"
    elseif UnitExists("party1") then
        root = "party"
    end

    local inRange = CheckInteractDistance(root + index, clockWork.FOLLOW)

    if not index == -1 and inRange then
        local percent = clockWork.healthPercentage(root .. tostring(index))
        clockWork.raid[index].texture:SetColorTexture(1 / 100 * percent, 1 / 100 * percent, 1 / 100 * percent, 1)
    end

    return inRange
end

function clockWork.hasMainHandEnchant()

    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges, hasThrownEnchant, thrownExpiration, thrownCharges = GetWeaponEnchantInfo()

    -- if hasMainHandEnchant then clockWork.print("hasMainHandEnchant = "..tostring(hasMainHandEnchant)) end
    -- if mainHandExpiration then clockWork.print("mainHandExpiration = "..tostring(mainHandExpiration)) end
    -- if mainHandCharges then clockWork.print("mainHandCharges = "..tostring(mainHandCharges)) end
    -- if hasOffHandEnchant then clockWork.print("hasOffHandEnchant = "..tostring(hasOffHandEnchant)) end
    -- if offHandExpiration then clockWork.print("offHandExpiration = "..tostring(offHandExpiration)) end
    -- if offHandCharges then clockWork.print("offHandCharges = "..tostring(offHandCharges)) end
    -- if hasThrownEnchant then clockWork.print("hasThrownEnchant = "..tostring(hasThrownEnchant)) end
    -- if thrownExpiration then clockWork.print("thrownExpiration = "..tostring(thrownExpiration)) end
    -- if thrownCharges then clockWork.print("thrownCharges = "..tostring(thrownCharges)) end

    return hasMainHandEnchant
end

function clockWork.hasOffHandEnchant()

    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges, hasThrownEnchant, thrownExpiration, thrownCharges = GetWeaponEnchantInfo()

    return hasOffHandEnchant
end

function clockWork.targetMemberIfHealthLessThan(health)

    if clockWork.lowestMemberHealthIndex and
            not clockWork.lowestMemberHealthIndex == -1
            and clockWork.lowestMemberHealth < health then

        return clockWork.targetMember(clockWork.lowestMemberHealthIndex)
    end

    return false
end

function clockWork.outOfCombat()

    return (not UnitIsDeadOrGhost("player")) and (not UnitAffectingCombat("player"))
end

