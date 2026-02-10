--- Checks if a unit is casting a specific effect.
--- @param unit string
--- @param effect string?
--- @return boolean
function Clockwork.isUnitCastingEffect(unit, effect)
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(
        unit)

    if (name == nil) then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(unit)
    end

    --Clockwork.log.debug(name)

    --if (name ~= nil) then
    --    Clockwork.log.debug("Clockwork.isUnitCastingEffect : " .. " " .. tostring(name))
    --end

    if effect == nil then
        return name ~= nil
    end

    return string.find(name, effect) ~= nil
end

--- Checks if the player is casting a specific effect.
--- @param effect string?
--- @return boolean
function Clockwork.isCastingEffect(effect)
    return Clockwork.isUnitCastingEffect("player", effect)
end

--- Checks if a unit is casting any spell.
--- @param unit string
--- @return boolean
function Clockwork.isUnitCasting(unit)
    return Clockwork.isUnitCastingEffect(unit, nil)
end

--- Checks if the player is casting any spell.
--- @return boolean
function Clockwork.isCasting()
    return Clockwork.isUnitCasting("player")
end

--- Counts the number of debuffs cast by the player on the target.
--- @return number
function Clockwork.targetsOwnDebuffCount()
    local index = 1
    local numberOfDebuff = 0

    while C_UnitAuras.GetAuraDataByIndex("target", index, "HARMFUL") do
        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod =
            C_UnitAuras.GetAuraDataByIndex("target", index, "HARMFUL")

        --Clockwork.log.debug(tostring(name) .. " " .. tostring(source) .. " " .. tostring(castByPlayer))

        if (castByPlayer == true) then
            numberOfDebuff = numberOfDebuff + 1
        end

        --Clockwork.log.debug("index : " .. tostring(index))

        index = index + 1
    end

    return numberOfDebuff
end

--- Checks if a unit has a specific debuff.
--- @param unit string
--- @param effect string
--- @return boolean, boolean, number
function Clockwork.unitHasDebuff(unit, effect)
    -- https://wowpedia.fandom.com/wiki/API_UnitAura

    -- Clockwork.log.debug("function Clockwork.unitHasDebuff(" .. tostring(unit) .. ", " .. tostring(effect))
    local index = 1

    while C_UnitAuras.GetAuraDataByIndex(unit, index, "HARMFUL") do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, index, "HARMFUL")
        if (aura and string.find(aura.name, effect) and aura.isFromPlayerOrPlayerPet) then
            local remainingTime = 0

            if aura.expirationTime then
                remainingTime = aura.expirationTime - GetTime()
            end

            --Clockwork.log.debug(tostring(name) .. " " .. tostring(source) .. " " .. tostring(castByPlayer) .. " " .. tostring(expirationTime))

            return true, true, remainingTime
        end

        --Clockwork.log.debug(name .. " " .. source .. " " .. tostring(castByPlayer) .. " " .. tostring(expirationTime))

        index = index + 1
    end

    return false, index > 1, 0
end

--- Checks if the target has a specific debuff.
--- @param effect string
--- @return boolean, number
function Clockwork.targetHasDebuff(effect)
    local buff, anybuff, remainingTime = Clockwork.unitHasDebuff("target", effect)

    --Clockwork.log.debug("Clockwork.targetHasDebuff(" .. effect .. ") => buff : " .. tostring(buff) .. ", anybuff : " .. tostring(anybuff) .. " remainingTime : " .. tostring(remainingTime))

    return buff, remainingTime
end

--- Checks if the player has any buff.
--- @return boolean
function Clockwork.playerHasAnyBuff()
    local buff, anybuff = Clockwork.unitHasBuff("player", "")

    return anybuff
end

--- Checks if the player has a specific debuff.
--- @param effect string
--- @return boolean, boolean, number
function Clockwork.playerHasDebuff(effect)
    return Clockwork.unitHasDebuff("player", effect)
end

--- Checks if a unit has any buff.
--- @param unit string
--- @return boolean
function Clockwork.unitHasAnyBuff(unit)
    local buff, anybuff = Clockwork.unitHasBuff(unit, "")

    return anybuff
end

--- Checks if the player has any debuff.
--- @return boolean
function Clockwork.playerHasAnyDebuff()
    local buff, anybuff = Clockwork.unitHasDebuff("player", "")

    return anybuff
end

--- Checks if a unit has any debuff.
--- @param unit string
--- @return boolean
function Clockwork.unitHasAnyDebuff(unit)
    local buff, anybuff = Clockwork.unitHasDebuff(unit, "")

    return anybuff
end

function Clockwork.unitHasBuff(unit, effect)
    -- Clockwork.log.debug("function Clockwork.unitHasBuff(" .. tostring(unit) .. ", " .. tostring(effect))
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

---@return number|nil
function Clockwork.findSpellBookSlotIndex(spellEnum, bookType)
    -- Clockwork.log.debug("function Clockwork.findSpell(" .. tostring(spellName) .. ", " .. tostring(bookType))
    --local i, s
    for spellTabIndex = 1, C_SpellBook.GetNumSpellBookSkillLines() do
        local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(spellTabIndex)
        if (not skillLineInfo.name) then
            break
        end
        for spellSlotIndex = skillLineInfo.itemIndexOffset + 1, skillLineInfo.itemIndexOffset + skillLineInfo.numSpellBookItems do
            local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(spellSlotIndex, bookType)
            if (spellBookItemInfo.spellID == spellEnum.id) then
                return spellSlotIndex
            end
        end
    end
    return nil
end
