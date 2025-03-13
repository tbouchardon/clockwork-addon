Clockwork.INSPECT = 1 --28 yards
Clockwork.TRADE = 2 --11.11 yards
Clockwork.DUEL = 3 --9.9 yards
Clockwork.FOLLOW = 4 --28 yards

Clockwork.spe = 1

function Clockwork.rotation()

    --Clockwork.log.debug("function Clockwork.rotation()")

    if UnitAffectingCombat("player") then
        Clockwork.inCombat.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.wasInCombat = true
    else
        Clockwork.resetCombat()
    end

    if UnitExists("raid1") then
        Clockwork.updateRaidHealth()
    elseif UnitExists("party1") then
        Clockwork.updatePartyHealth()
    else
        Clockwork.checkUnitHealth("player", -1)
    end

    Clockwork.playerHealth.texture:SetColorTexture(1 / 100 * Clockwork.healthPercentage("player"), 0, 0, 1)
    Clockwork.playerMana.texture:SetColorTexture(0, 0, 1 / 100 * Clockwork.manaPercentage("player"), 1)

    Clockwork.log.debug(tostring(Clockwork.targetHostile()) .. tostring(Clockwork.targetNeutral()))

    if (UnitExists("target") and not UnitIsUnit("player", "target")) then
        if (Clockwork.targetUnfriendly()) then
            Clockwork.targetReaction.texture:SetColorTexture(1, 0, 0, 1)
        elseif (Clockwork.targetNeutral()) then
            Clockwork.targetReaction.texture:SetColorTexture(1, 1, 0, 1)
        elseif (Clockwork.targetFriendly()) then
            Clockwork.targetReaction.texture:SetColorTexture(0, 1, 0, 1)
        else
            Clockwork.targetReaction.texture:SetColorTexture(0, 0, 0, 1)
        end

        Clockwork.targetHealth.texture:SetColorTexture(1 / 100 * Clockwork.healthPercentage("target"), 0, 0, 1)
        Clockwork.targetMana.texture:SetColorTexture(0, 0, 1 / 100 * Clockwork.manaPercentage("target"), 1)
    else
        Clockwork.targetReaction.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.targetHealth.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.targetMana.texture:SetColorTexture(0, 0, 0, 1)
    end

    if Clockwork.DRIVE_MOD == true
            and ((Clockwork.unitHasBuff("player", "Food") and (Clockwork.playerHealthPct() < 100))
            or (Clockwork.unitHasBuff("player", "Drink") and (Clockwork.playerManaPct() < 100))) then
        Clockwork.drive.texture:SetColorTexture(0, 0, 0, 1)
    elseif Clockwork.DRIVE_MOD == true then
        Clockwork.drive.texture:SetColorTexture(1, 1, 1, 1)
    end

    -- Ne rien faire si un cast est déjà en cours
    if (Clockwork.CASTING == true) then
        Clockwork.resetKeys();
        return ;
    end

    Clockwork.resetKeys()

    --Clockwork.log.debug("UnitAffectingCombat(\"player\")" .. tostring(UnitAffectingCombat("player")))
    --Clockwork.log.debug("UnitAffectingCombat(\"target\")" .. tostring(UnitAffectingCombat("target")))
    --Clockwork.log.debug("UnitClass(\"player\")" .. tostring(UnitClass("player")))

    if (IsMounted()) then
        return
    end

    -- Ne lancer la rotation que si le joueur est hors combat, ou la cible ET le joueur en combat
    if (Clockwork.AGGRO_MOD or Clockwork.bothPlayerAndTargetInCombat() or Clockwork.playerNotInCombat()) then

        if UnitClass("player") == "Démoniste" then
            Clockwork.warlockRotation()
            --elseif UnitClass("player") == "Warrior" then
            --    Clockwork.warriorRotation()
            --elseif UnitClass("player") == "Shaman" then
            --    Clockwork.shamanRotation()
            --elseif UnitClass("player") == "Mage" then
            --    Clockwork.mageRotation()
            --elseif UnitClass("player") == "Priest" then
            --    Clockwork.priestRotation()
        end
    end
end

function Clockwork.bothPlayerAndTargetInCombat()

    return UnitAffectingCombat("player") and UnitAffectingCombat("target")

end

function Clockwork.playerNotInCombat()

    return not UnitAffectingCombat("player")

end

function Clockwork.debuffCanBeCast(spell, slot)

    -- Clockwork.log.debug("function Clockwork.debuffCanBeCast(" .. tostring(spell) .. ", " .. tostring(slot))

    Clockwork.log.debug("Clockwork.debuffCanBeCast(" .. tostring(spell) .. "," .. tostring(slot) .. ')')

    if not spell then
        return false
    end

    if not Clockwork.unitHasDebuff("target", spell) then
        if slot ~= nil then
            return Clockwork.actionCanBeCast(slot)
        else
            Clockwork.log.notice("No slot ! (" .. tostring(spell) .. ")")
            return true
        end
    else
        return false
    end
end

function Clockwork.targetInRange(distance)

    -- Clockwork.log.debug("function Clockwork.targetInRange(" .. tostring(distance))

    if CheckInteractDistance("target", distance) then
        return true
    else
        return false
    end
end

function Clockwork.actionCanBeCast(slot)

    Clockwork.log.debug("function Clockwork.actionCanBeCast(" .. tostring(slot))

    if (Clockwork.CHECK_ACTIONS_CAST == false) then
        return true
    end

    Clockwork.log.debug("slot = " .. tostring(slot))
    local actionType, id, subType = GetActionInfo(slot)
    local name, rank, icon, castTime, minRange, maxRange, spellID = C_Spell.GetSpellInfo(id)
    Clockwork.log.debug(tostring(actionType) .. ": " .. tostring(name) .. " (" .. tostring(spellID) .. ") ")
    Clockwork.log.debug("ActionHasRange(slot) = " .. tostring(ActionHasRange(slot)))
    Clockwork.log.debug("IsActionInRange(slot) = " .. tostring(IsActionInRange(slot)))

    local canBeCast = true

    if ActionHasRange(slot) then
        canBeCast = IsActionInRange(slot) ~= false -- Can be true or nil
    end

    --Clockwork.log.debug("canBeCast1 : " .. tostring(canBeCast))

    if canBeCast == true then

        local start, duration, enable = GetActionCooldown(slot)

        --         Clockwork.log.debug("GetActionCooldown(slot) start = " .. tostring(start))
        --         Clockwork.log.debug("GetActionCooldown(slot) duration = " .. tostring(duration))
        --         Clockwork.log.debug("GetActionCooldown(slot) enable = " .. tostring(enable))

        canBeCast = (start == 0)
    end

    --Clockwork.log.debug("canBeCast2 : " .. tostring(canBeCast))

    if canBeCast == true then

        local isUsable, notEnoughMana = IsUsableAction(slot)

        --         Clockwork.log.debug("IsUsableAction(slot) = isUsable " .. tostring(isUsable))
        --         Clockwork.log.debug("IsUsableAction(slot) = notEnoughMana " .. tostring(notEnoughMana))

        canBeCast = (isUsable ~= nil)
    end

    if (canBeCast == true) then
        if castTime ~= 0 then
            canBeCast = Clockwork.player.isMoving == false
        end
    end

    --Clockwork.log.debug("canBeCast3 : " .. tostring(canBeCast))

    return canBeCast
end

function Clockwork.enemyPlayer()

    -- Clockwork.log.debug("function Clockwork.enemyPlayer(")

    if UnitIsPlayer("target") then
        return true
    else
        return false
    end
end

function Clockwork.healthPercentage(unit)

    -- Clockwork.log.debug("function Clockwork.healthPercentage(" .. tostring(unit))

    if (UnitHealth(unit) == 0) then
        return 0
    end

    local percentage

    percentage = UnitHealth(unit) / UnitHealthMax(unit) * 100

    return percentage
end

function Clockwork.playerHealthPct()

    return Clockwork.healthPercentage("player")
end

function Clockwork.manaPercentage(unit)

    -- Clockwork.log.debug("function Clockwork.manaPercentage(" .. tostring(unit)) -- or energy, rage, etc

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

function Clockwork.playerManaPct()

    return Clockwork.manaPercentage("player")
end

function Clockwork.unitExistCanAndShouldDie()
    return UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player") and -- > La cible ET le joueur sont vivants (>_<)
            (not UnitIsTapDenied("target")) and -- > La cible peut être marquée par le joueur.
            (Clockwork.targetNeutral() or Clockwork.targetUnfriendly()) -- > La cible est un enemi (rouge uniquement)
end

function Clockwork.targetUnfriendly()

    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") < 4
end

function Clockwork.targetNeutral()

    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") == 4
end

function Clockwork.targetFriendly()

    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") > 4
end

function Clockwork.resetCombat()

    Clockwork.inCombat.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.wasInCombat = false
    Clockwork.lastTimePlayerHit = time()
    Clockwork.lastTimePlayerHasBeenHit = time()
    Clockwork.durationBeingHitWithoutRetaliating = 0
end

Clockwork.lowestMemberHealth = 100
Clockwork.lowestMemberHealthIndex = nil

function Clockwork.updatePartyHealth()

    Clockwork.lowestMemberHealth = 100
    Clockwork.lowestMemberHealthIndex = nil

    Clockwork.checkUnitHealth("player", -1)

    for index = 1, 4 do

        Clockwork.checkUnitHealth("party" .. tostring(index), index)
        Clockwork.raid[index].texture:SetColorTexture(1 / 100 * Clockwork.healthPercentage("party" .. tostring(index)), 0, 0, 1)
    end
end

function Clockwork.updateRaidHealth()

    Clockwork.lowestMemberHealth = 100
    Clockwork.lowestMemberHealthIndex = nil

    Clockwork.checkUnitHealth("player", -1)

    for index = 1, 40 do

        Clockwork.checkUnitHealth("raid" .. tostring(index), index)
        Clockwork.raid[index].texture:SetColorTexture(1 / 100 * Clockwork.healthPercentage("raid" .. tostring(index)), 0, 0, 1)
    end
end

function Clockwork.checkUnitHealth(unit, index)

    if UnitExists(unit) then
        if Clockwork.healthPercentage(unit) < Clockwork.lowestMemberHealth then
            Clockwork.lowestMemberHealth = Clockwork.healthPercentage(unit)
            Clockwork.lowestMemberHealthIndex = index
        end
    end
end

function Clockwork.targetMember(index)

    local root = ""
    if UnitExists("raid1") then
        root = "raid"
    elseif UnitExists("party1") then
        root = "party"
    end

    local inRange = CheckInteractDistance(root + index, Clockwork.FOLLOW)

    if not index == -1 and inRange then
        local percent = Clockwork.healthPercentage(root .. tostring(index))
        Clockwork.raid[index].texture:SetColorTexture(1 / 100 * percent, 1 / 100 * percent, 1 / 100 * percent, 1)
    end

    return inRange
end

function Clockwork.hasMainHandEnchant()

    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges, hasThrownEnchant, thrownExpiration, thrownCharges = GetWeaponEnchantInfo()

    -- if hasMainHandEnchant then Clockwork.log.debug("hasMainHandEnchant = "..tostring(hasMainHandEnchant)) end
    -- if mainHandExpiration then Clockwork.log.debug("mainHandExpiration = "..tostring(mainHandExpiration)) end
    -- if mainHandCharges then Clockwork.log.debug("mainHandCharges = "..tostring(mainHandCharges)) end
    -- if hasOffHandEnchant then Clockwork.log.debug("hasOffHandEnchant = "..tostring(hasOffHandEnchant)) end
    -- if offHandExpiration then Clockwork.log.debug("offHandExpiration = "..tostring(offHandExpiration)) end
    -- if offHandCharges then Clockwork.log.debug("offHandCharges = "..tostring(offHandCharges)) end
    -- if hasThrownEnchant then Clockwork.log.debug("hasThrownEnchant = "..tostring(hasThrownEnchant)) end
    -- if thrownExpiration then Clockwork.log.debug("thrownExpiration = "..tostring(thrownExpiration)) end
    -- if thrownCharges then Clockwork.log.debug("thrownCharges = "..tostring(thrownCharges)) end

    return hasMainHandEnchant
end

function Clockwork.hasOffHandEnchant()

    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges, hasThrownEnchant, thrownExpiration, thrownCharges = GetWeaponEnchantInfo()

    return hasOffHandEnchant
end

function Clockwork.targetMemberIfHealthLessThan(health)

    if Clockwork.lowestMemberHealthIndex and
            not Clockwork.lowestMemberHealthIndex == -1
            and Clockwork.lowestMemberHealth < health then

        return Clockwork.targetMember(Clockwork.lowestMemberHealthIndex)
    end

    return false
end

function Clockwork.outOfCombat()

    return (not UnitIsDeadOrGhost("player")) and (not UnitAffectingCombat("player"))
end

