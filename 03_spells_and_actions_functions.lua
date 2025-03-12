function clockWork.getBuffName(id)

    -- clockWork.printDebug("function clockWork.getBuffName(" .. tostring(id))
    ClockWorkTooltip:SetUnitBuff(id)
    local buffName = tostring(ClockWorkTooltipTextLeft1:GetText())
    if (buffName) then
        return buffName:GetText() or id
    end
    return id
end

function clockWork.isUnitCastingEffect(unit, effect)

    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(unit)

    if (name == nil) then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(unit)
    end

    --clockWork.printDebug(name)

    --if (name ~= nil) then
    --    clockWork.printDebug("clockWork.isUnitCastingEffect : " .. " " .. tostring(name))
    --end

    if effect == nil then
        return name ~= nil
    end

    return string.find(name, effect)
end

function clockWork.isCastingEffect(effect)

    return clockWork.isUnitCastingEffect("player", effect)
end

function clockWork.isUnitCasting(unit)

    return clockWork.isUnitCastingEffect(unit, nil)
end

function clockWork.isCasting()

    return clockWork.isUnitCasting("player")
end

function clockWork.targetsOwnDebuffCount()

    local index = 1
    local numberOfDebuff = 0

    while UnitAura("target", index, "HARMFUL") do

        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura("target", index, "HARMFUL")

        --clockWork.printDebug(tostring(name) .. " " .. tostring(source) .. " " .. tostring(castByPlayer))

        if (castByPlayer == true) then
            numberOfDebuff = numberOfDebuff + 1
        end

        --clockWork.printDebug("index : " .. tostring(index))

        index = index + 1
    end

    return numberOfDebuff
end

function clockWork.unitHasDebuff(unit, effect)

    -- https://wowpedia.fandom.com/wiki/API_UnitAura

    -- clockWork.printDebug("function clockWork.unitHasDebuff(" .. tostring(unit) .. ", " .. tostring(effect))
    local index = 1

    while UnitAura(unit, index, "HARMFUL") do

        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, index, "HARMFUL")

        if (string.find(name, effect) and castByPlayer) then

            local remainingTime = 0

            if expirationTime then

                remainingTime = expirationTime - GetTime()
            end

            --clockWork.printDebug(tostring(name) .. " " .. tostring(source) .. " " .. tostring(castByPlayer) .. " " .. tostring(expirationTime))

            return true, true, remainingTime
        end

        --clockWork.printDebug(name .. " " .. source .. " " .. tostring(castByPlayer) .. " " .. tostring(expirationTime))

        index = index + 1
    end

    return false, index > 1, 0
end

function clockWork.targetHasDebuff(effect)

    local buff, anybuff, remainingTime = clockWork.unitHasDebuff("target", effect)

    --clockWork.printDebug("clockWork.targetHasDebuff(" .. effect .. ") => buff : " .. tostring(buff) .. ", anybuff : " .. tostring(anybuff) .. " remainingTime : " .. tostring(remainingTime))

    return buff, remainingTime
end

function clockWork.playerHasAnyBuff()

    local buff, anybuff = clockWork.unitHasBuff("player", "")

    return anybuff
end

function clockWork.playerHasDebuff(effect)

    return clockWork.unitHasDebuff("player", effect)
end

function clockWork.unitHasAnyBuff(unit)

    local buff, anybuff = clockWork.unitHasBuff(unit, "")

    return anybuff
end

function clockWork.playerHasAnyDebuff()

    local buff, anybuff = clockWork.unitHasDebuff("player", "")

    return anybuff
end

function clockWork.unitHasAnyDebuff(unit)

    local buff, anybuff = clockWork.unitHasDebuff(unit, "")

    return anybuff
end

function clockWork.unitHasBuff(unit, effect)

    -- clockWork.printDebug("function clockWork.unitHasBuff(" .. tostring(unit) .. ", " .. tostring(effect))
    local index = 1
    while UnitBuff(unit, index) do

        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, index)

        if (string.find(name, effect) and castByPlayer) then

            local remainingTime = 0

            if expirationTime then

                remainingTime = expirationTime - GetTime()
            end

            return true, true, remainingTime
        end

        index = index + 1
    end

    return false, index > 1, 0
end

function clockWork.playerHasBuff(effect)

    return clockWork.unitHasBuff("player", effect)
end

function clockWork.findSpell(spellName, bookType)

    -- clockWork.printDebug("function clockWork.findSpell(" .. tostring(spellName) .. ", " .. tostring(bookType))
    --local i, s
    local found = false
    for i = 1, MAX_SKILLLINE_TABS do
        local name, texture, offset, numSpells = GetSpellTabInfo(i)
        if (not name) then
            break
        end
        for s = offset + 1, offset + numSpells do
            local spell, rank = GetSpellName(s, bookType)
            if (spell == spellName) then
                found = true
            end
            if (found and spell ~= spellName) then
                return s - 1
            end
        end
    end
    if (found) then
        return s
    end
    return nil
end

function clockWork.dropSpellInBarSlot(spellName, slot)

    -- clockWork.printDebug("function clockWork.dropSpellInBarSlot(" .. tostring(spellName) .. ", " .. tostring(slot))

    local id = clockWork.findSpell(spellName, BOOKTYPE_SPELL)
    clockWork.log.notice(tostring(id))
    --PickupSpell(spellName)
    if id then
        PickupSpell(id, BOOKTYPE_SPELL)
        PlaceAction(slot)
    end
end

function clockWork.isPassiveDamage(arg1)

    return string.find(arg1, clockWork.lightningShield)
end