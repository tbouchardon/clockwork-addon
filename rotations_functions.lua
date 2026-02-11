Clockwork.INSPECT = 1 --28 yards
Clockwork.TRADE = 2   --11.11 yards
Clockwork.DUEL = 3    --9.9 yards
Clockwork.FOLLOW = 4  --28 yards

Clockwork.rotations = {}

--- Updates the player's status and executes rotations.
--- @return nil
function Clockwork:rotation()
    -- Clockwork.log.debug("function Clockwork.rotation()")

    self:updateUIStatus()
    Clockwork:resetKeys()

    -- Ne rien faire si un cast est déjà en cours
    if (self.CASTING == true) then
        return;
    end

    --Clockwork.log.debug("UnitAffectingCombat(\"player\")" .. tostring(UnitAffectingCombat("player")))
    --Clockwork.log.debug("UnitAffectingCombat(\"target\")" .. tostring(UnitAffectingCombat("target")))
    --Clockwork.log.debug("UnitClass(\"player\")" .. tostring(UnitClass("player")))

    if (IsMounted()) then
        return
    end

    -- Ne lancer la rotation que si le joueur est hors combat, ou la cible ET le joueur en combat
    if (Clockwork.AGGRO_MOD or Clockwork.bothPlayerAndTargetInCombat() or Clockwork.playerNotInCombat()) then
        local rotation = Clockwork.rotations[Clockwork.player.specialization.id]
        if rotation then rotation() end
    end
end

--- Updates the UI elements based on player and target status.
--- @return nil
function Clockwork:updateUIStatus()
    if UnitAffectingCombat("player") then
        self.inCombat.texture:SetColorTexture(1, 1, 1, 1)
        self.wasInCombat = true
    else
        self:resetCombat()
    end

    if UnitExists("raid1") then
        self:updateRaidHealth()
    elseif UnitExists("party1") then
        self:updatePartyHealth()
    else
        self:checkUnitHealth("player", -1)
    end

    self.playerHealth.texture:SetColorTexture(1 / 100 * Clockwork.healthPercentage("player"), 0, 0, 1)
    self.playerMana.texture:SetColorTexture(0, 0, 1 / 100 * Clockwork.manaPercentage("player"), 1)

    if (UnitExists("target") and not UnitIsUnit("player", "target")) then
        if (Clockwork.targetIsUnfriendly()) then
            self.targetReaction.texture:SetColorTexture(1, 0, 0, 1)
        elseif (Clockwork.targetIsNeutral()) then
            self.targetReaction.texture:SetColorTexture(1, 1, 0, 1)
        elseif (Clockwork.targetIsFriendly()) then
            self.targetReaction.texture:SetColorTexture(0, 1, 0, 1)
        else
            self.targetReaction.texture:SetColorTexture(0, 0, 0, 1)
        end

        self.targetHealth.texture:SetColorTexture(1 / 100 * Clockwork.healthPercentage("target"), 0, 0, 1)
        self.targetMana.texture:SetColorTexture(0, 0, 1 / 100 * Clockwork.manaPercentage("target"), 1)
    else
        self.targetReaction.texture:SetColorTexture(0, 0, 0, 1)
        self.targetHealth.texture:SetColorTexture(0, 0, 0, 1)
        self.targetMana.texture:SetColorTexture(0, 0, 0, 1)
    end

    if Clockwork.DRIVE_MOD == true
        and ((Clockwork.unitHasBuff("player", "Food") and (Clockwork.playerHealthPct() < 100))
            or (Clockwork.unitHasBuff("player", "Drink") and (Clockwork.playerManaPct() < 100))) then
        self.drive.texture:SetColorTexture(0, 0, 0, 1)
    elseif Clockwork.DRIVE_MOD == true then
        self.drive.texture:SetColorTexture(1, 1, 1, 1)
    end
end

--- Checks if both player and target are in combat.
--- @return boolean
function Clockwork.bothPlayerAndTargetInCombat()
    return UnitAffectingCombat("player") and UnitAffectingCombat("target")
end

--- Checks if the player is not in combat.
--- @return boolean
function Clockwork.playerNotInCombat()
    return not UnitAffectingCombat("player")
end

--- Checks if a debuff can be cast on the target.
--- @param spell string
--- @param slot number?
--- @return boolean
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

--- Checks if the target is in melee range.
--- @return boolean
function Clockwork.targetInMeeleRange()
    return Clockwork.targetInRange(Clockwork.TRADE)
end

--- Checks if the target is in the specified range.
--- @param distance number
--- @return boolean
function Clockwork.targetInRange(distance)
    -- Clockwork.log.debug("function Clockwork.targetInRange(" .. tostring(distance))

    -- distance - A value from 1 to 5:
    -- 1 = Compare Achievements, 28 yards
    -- 2 = Trade, 8 yards
    -- 3 = Duel, 7 yards
    -- 4 = Follow, 28 yards
    -- 5 = Pet-battle Duel, 7 yards
    
    if CheckInteractDistance("target", distance) then
        return true
    else
        return false
    end
end

--- Checks if an action can be cast.
--- @param actionSlot number
--- @return boolean
function Clockwork.actionCanBeCast(actionSlot)
    Clockwork.log.debug("function Clockwork.actionCanBeCast(" .. tostring(actionSlot))

    if (Clockwork.CHECK_ACTIONS_CAST == false) then
        return true
    end

    local actionType, id, subType = GetActionInfo(actionSlot)
    if not id then
        Clockwork.log.debug("No action in slot" .. tostring(actionSlot))
        return false
    end
    Clockwork.log.debug("id = " .. id)
    local spellInfo = C_Spell.GetSpellInfo(id)
    Clockwork.log.debug(tostring(actionType) .. ": " .. tostring(spellInfo.name) .. " (" .. tostring(spellInfo.spellID) .. ") ")
    Clockwork.log.debug("ActionHasRange(" .. actionSlot .. ") = " .. tostring(ActionHasRange(actionSlot)))
    Clockwork.log.debug("IsActionInRange(" .. actionSlot .. ") = " .. tostring(IsActionInRange(actionSlot)))

    local canBeCast = true

    if ActionHasRange(actionSlot) then
        canBeCast = IsActionInRange(actionSlot) ~= false -- Can be true or nil
    end

    --Clockwork.log.debug("canBeCast1 : " .. tostring(canBeCast))

    if canBeCast == true then
        local start, duration, enable = GetActionCooldown(actionSlot)

        Clockwork.log.debug("GetActionCooldown(" .. actionSlot .. ")" ..
            " start = " .. tostring(start) ..
            " duration = " .. tostring(duration) ..
            " enable = " .. tostring(enable))

        canBeCast = (start == 0)
    end

    --Clockwork.log.debug("canBeCast2 : " .. tostring(canBeCast))

    if canBeCast == true then
        local isUsable, notEnoughMana = IsUsableAction(actionSlot)

        Clockwork.log.debug("IsUsableAction(" .. actionSlot .. ") = isUsable " .. tostring(isUsable))
        --         Clockwork.log.debug("IsUsableAction("..actionSlot..") = notEnoughMana " .. tostring(notEnoughMana))

        canBeCast = isUsable ~= nil and isUsable == true
    end

    if (canBeCast == true) then
        if spellInfo.castTime ~= 0 then
            canBeCast = Clockwork.player.isMoving == false
        end
    end

    --Clockwork.log.debug("canBeCast3 : " .. tostring(canBeCast))

    return canBeCast
end

--- Checks if the target is an enemy player.
--- @return boolean
function Clockwork.enemyPlayer()
    -- Clockwork.log.debug("function Clockwork.enemyPlayer(")

    if UnitIsPlayer("target") then
        return true
    else
        return false
    end
end

--- Calculates the health percentage of a unit.
--- @param unit string
--- @return number
function Clockwork.healthPercentage(unit)
    -- Clockwork.log.debug("function Clockwork.healthPercentage(" .. tostring(unit))

    if (UnitHealth(unit) == 0) then
        return 0
    end

    local percentage

    percentage = UnitHealth(unit) / UnitHealthMax(unit) * 100

    return percentage
end

--- Gets the player's health percentage.
--- @return number
function Clockwork.playerHealthPct()
    return Clockwork.healthPercentage("player")
end

--- Calculates the mana percentage of a unit.
--- @param unit string
--- @return number
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

--- Gets the player's mana percentage.
--- @return number
function Clockwork.playerManaPct()
    return Clockwork.manaPercentage("player")
end

--- Checks if the target exists, can be attacked, and the player is alive.
--- @return boolean
function Clockwork.unitExistCanAndShouldDie()
    return UnitExists("target") and
        not UnitIsDeadOrGhost("target") and
        not UnitIsDeadOrGhost("player") and                             -- > La cible ET le joueur sont vivants (>_<)
        (not UnitIsTapDenied("target")) and                             -- > La cible peut être marquée par le joueur.
        (Clockwork.targetIsNeutral() or Clockwork.targetIsUnfriendly()) -- > La cible est un enemi (rouge uniquement)
end

--- Checks if the target is unfriendly.
--- @return boolean
function Clockwork.targetIsUnfriendly()
    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") < 4
end

--- Checks if the target is neutral.
--- @return boolean
function Clockwork.targetIsNeutral()
    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") == 4
end

--- Checks if the target is friendly.
--- @return boolean
function Clockwork.targetIsFriendly()
    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") > 4
end

--- Resets combat-related variables.
--- @return nil
function Clockwork:resetCombat()
    self.inCombat.texture:SetColorTexture(0, 0, 0, 1)
    self.wasInCombat = false
    self.lastTimePlayerHit = time()
    self.lastTimePlayerHasBeenHit = time()
    self.durationBeingHitWithoutRetaliating = 0
end

Clockwork.lowestMemberHealth = 100
Clockwork.lowestMemberHealthIndex = nil

--- Updates party health information.
--- @return nil
function Clockwork:updatePartyHealth()
    self.lowestMemberHealth = 100
    self.lowestMemberHealthIndex = nil

    self:checkUnitHealth("player", -1)

    for index = 1, 4 do
        self:checkUnitHealth("party" .. tostring(index), index)
        self.raid[index].texture:SetColorTexture(1 / 100 * Clockwork.healthPercentage("party" .. tostring(index)), 0,
            0, 1)
    end
end

--- Updates raid health information.
--- @return nil
function Clockwork:updateRaidHealth()
    self.lowestMemberHealth = 100
    self.lowestMemberHealthIndex = nil

    Clockwork:checkUnitHealth("player", -1)

    for index = 1, 40 do
        Clockwork:checkUnitHealth("raid" .. tostring(index), index)
        self.raid[index].texture:SetColorTexture(1 / 100 * Clockwork.healthPercentage("raid" .. tostring(index)), 0,
            0, 1)
    end
end

--- Checks the health of a specific unit.
--- @param unit string
--- @param index number
--- @return nil
function Clockwork:checkUnitHealth(unit, index)
    if UnitExists(unit) then
        if Clockwork.healthPercentage(unit) < Clockwork.lowestMemberHealth then
            self.lowestMemberHealth = Clockwork.healthPercentage(unit)
            self.lowestMemberHealthIndex = index
        end
    end
end

--- Targets a raid or party member.
--- @param index number
--- @return boolean
function Clockwork:targetMember(index)
    local root = ""
    if UnitExists("raid1") then
        root = "raid"
    elseif UnitExists("party1") then
        root = "party"
    end

    local inRange = CheckInteractDistance(root + index, Clockwork.FOLLOW)

    if not index == -1 and inRange then
        local percent = Clockwork.healthPercentage(root .. tostring(index))
        self.raid[index].texture:SetColorTexture(1 / 100 * percent, 1 / 100 * percent, 1 / 100 * percent, 1)
    end

    return inRange
end

--- Checks if the player has a main-hand enchant.
--- @return boolean
function Clockwork.hasMainHandEnchant()
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID, hasRangedEnchant, rangedExpiration, rangedCharges, rangedEnchantID =
        GetWeaponEnchantInfo()

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

--- Checks if the player has an off-hand enchant.
--- @return boolean
function Clockwork.hasOffHandEnchant()
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID, hasRangedEnchant, rangedExpiration, rangedCharges, rangedEnchantID =
        GetWeaponEnchantInfo()

    return hasOffHandEnchant
end

--- Targets a raid or party member if their health is below a threshold.
--- @param health number
--- @return boolean
function Clockwork:targetMemberIfHealthLessThan(health)
    if self.lowestMemberHealthIndex and
        not self.lowestMemberHealthIndex == -1
        and self.lowestMemberHealth < health then
        return self:targetMember(Clockwork.lowestMemberHealthIndex)
    end

    return false
end

--- Checks if the player is out of combat.
--- @return boolean
function Clockwork.outOfCombat()
    return (not UnitIsDeadOrGhost("player")) and (not UnitAffectingCombat("player"))
end

--- Casts a spell if possible based on conditions.
--- @param params {spell:{name:string, id:integer}, condition:boolean|nil, priority:number|nil, duration:number|nil}
--- @return nil
function Clockwork:castSpellIfPossible(params)

    -- A condition of 'false' explicitly prevents casting. nil or true allows it.
    if params.condition == false then
        return
    end

    local action, error = self:getActionSlotAndBindingForSpell(params.spell.id)
    if not action then
        -- Clockwork.log.error(error) -- Optionally log why it failed
        return
    end

    if not Clockwork.actionCanBeCast(action.slot) then return end

    local modifier = nil
    if action.alt then
        modifier = Clockwork.ALT
    end
    if action.ctrl then
        modifier = Clockwork.CTRL
    end
    if action.shift then
        modifier = Clockwork.SHIFT
    end

    self:hitKeyWithModifier({
        key = action.key,
        priority = params.priority or 1,
        duration = params.duration
    }, modifier)
end
