function Clockwork.getBuffName(id)
    ClockworkTooltip:ClearLines()
    ClockworkTooltip:SetUnitBuff(id)
    local tooltipTextLeft1 = ClockworkTooltip["TextLeft1"]
    if not tooltipTextLeft1 then
        return id
    end
    local buffName = tooltipTextLeft1:GetText()
    return buffName or id
end

function Clockwork.isUnitCastingEffect(unit, effect)
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(
        unit)

    if (name == nil) then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(unit)
    end

    --Clockwork.printDebug(name)

    --if (name ~= nil) then
    --    Clockwork.printDebug("Clockwork.isUnitCastingEffect : " .. " " .. tostring(name))
    --end

    if effect == nil then
        return name ~= nil
    end

    return string.find(name, effect)
end

function Clockwork.isCastingEffect(effect)
    return Clockwork.isUnitCastingEffect("player", effect)
end

function Clockwork.isUnitCasting(unit)
    return Clockwork.isUnitCastingEffect(unit, nil)
end

function Clockwork.isCasting()
    return Clockwork.isUnitCasting("player")
end

function Clockwork.targetsOwnDebuffCount()
    local index = 1
    local numberOfDebuff = 0

    while C_UnitAuras.GetAuraDataByIndex("target", index, "HARMFUL") do
        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod =
            C_UnitAuras.GetAuraDataByIndex("target", index, "HARMFUL")

        --Clockwork.printDebug(tostring(name) .. " " .. tostring(source) .. " " .. tostring(castByPlayer))

        if (castByPlayer == true) then
            numberOfDebuff = numberOfDebuff + 1
        end

        --Clockwork.printDebug("index : " .. tostring(index))

        index = index + 1
    end

    return numberOfDebuff
end

function Clockwork.unitHasDebuff(unit, effect)
    -- https://wowpedia.fandom.com/wiki/API_UnitAura

    -- Clockwork.printDebug("function Clockwork.unitHasDebuff(" .. tostring(unit) .. ", " .. tostring(effect))
    local index = 1

    while C_UnitAuras.GetAuraDataByIndex(unit, index, "HARMFUL") do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, index, "HARMFUL")
        if (aura and string.find(aura.name, effect) and aura.isFromPlayerOrPlayerPet) then
            local remainingTime = 0

            if aura.expirationTime then
                remainingTime = aura.expirationTime - GetTime()
            end

            --Clockwork.printDebug(tostring(name) .. " " .. tostring(source) .. " " .. tostring(castByPlayer) .. " " .. tostring(expirationTime))

            return true, true, remainingTime
        end

        --Clockwork.printDebug(name .. " " .. source .. " " .. tostring(castByPlayer) .. " " .. tostring(expirationTime))

        index = index + 1
    end

    return false, index > 1, 0
end

function Clockwork.targetHasDebuff(effect)
    local buff, anybuff, remainingTime = Clockwork.unitHasDebuff("target", effect)

    --Clockwork.printDebug("Clockwork.targetHasDebuff(" .. effect .. ") => buff : " .. tostring(buff) .. ", anybuff : " .. tostring(anybuff) .. " remainingTime : " .. tostring(remainingTime))

    return buff, remainingTime
end

function Clockwork.playerHasAnyBuff()
    local buff, anybuff = Clockwork.unitHasBuff("player", "")

    return anybuff
end

function Clockwork.playerHasDebuff(effect)
    return Clockwork.unitHasDebuff("player", effect)
end

function Clockwork.unitHasAnyBuff(unit)
    local buff, anybuff = Clockwork.unitHasBuff(unit, "")

    return anybuff
end

function Clockwork.playerHasAnyDebuff()
    local buff, anybuff = Clockwork.unitHasDebuff("player", "")

    return anybuff
end

function Clockwork.unitHasAnyDebuff(unit)
    local buff, anybuff = Clockwork.unitHasDebuff(unit, "")

    return anybuff
end

function Clockwork.unitHasBuff(unit, effect)
    -- Clockwork.printDebug("function Clockwork.unitHasBuff(" .. tostring(unit) .. ", " .. tostring(effect))
    local index = 1
    while C_UnitAuras.GetBuffDataByIndex(unit, index) do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, index)

        if (aura and string.find(aura.name, effect) and aura.isFromPlayerOrPlayerPet) then
            local remainingTime = 0

            if aura.expirationTime then
                remainingTime = aura.expirationTime - GetTime()
            end

            return true, true, remainingTime
        end

        index = index + 1
    end

    return false, index > 1, 0
end

function Clockwork.playerHasBuff(effect)
    return Clockwork.unitHasBuff("player", effect)
end

function Clockwork.findSpellSlotIndex(spellName, bookType)
    -- Clockwork.printDebug("function Clockwork.findSpell(" .. tostring(spellName) .. ", " .. tostring(bookType))
    --local i, s
    local found = false
    for spellTabIndex = 1, C_SpellBook.GetNumSpellBookSkillLines() do
        local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(spellTabIndex)
        if (not skillLineInfo.name) then
            break
        end
        for spellIndex = skillLineInfo.itemIndexOffset + 1, skillLineInfo.itemIndexOffset + skillLineInfo.numSpellBookItems do
            local name, subName = C_SpellBook.GetSpellBookItemName(spellIndex, bookType)
            if (name == spellName) then
                found = true
            end
            if (found and name ~= spellName) then
                return spellIndex - 1
            end
        end
    end
    return nil
end

function Clockwork.dropSpellInBarSlot(spellName, slot)
    -- Clockwork.printDebug("function Clockwork.dropSpellInBarSlot(" .. tostring(spellName) .. ", " .. tostring(slot))

    local spellSlotIndex = Clockwork.findSpellSlotIndex(spellName, Enum.SpellBookSpellBank.Player)
    Clockwork.log.notice(tostring(spellSlotIndex))
    if spellSlotIndex then
        C_SpellBook.PickupSpellBookItem(spellSlotIndex, Enum.SpellBookSpellBank.Player)
        PlaceAction(slot)
    end
end

function Clockwork.isPassiveDamage(arg1)
    return string.find(arg1, Clockwork.lightningShield)
end
