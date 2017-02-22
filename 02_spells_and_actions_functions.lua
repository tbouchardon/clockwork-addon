function ksuto.getBuffName(id)

    -- ksuto.printDebug("function ksuto.getBuffName(" .. tostring(id))
    KsutoTooltip:SetUnitBuff(id)
    local buffName = tostring(KsutoTooltipTextLeft1:GetText());
    if (buffName) then
        return buffName:GetText() or id
    end
    return id
end

function ksuto.unitHasDebuff(unit, effect)

    -- ksuto.printDebug("function ksuto.unitHasDebuff(" .. tostring(unit) .. ", " .. tostring(effect))
    local index = 1;
    while UnitDebuff(unit, index) do

        if ksuto.DEBUG_MOD then
            local icon, count, castable, texture, debuffType, isStealable, isMine, shouldConsolidate, spellId = UnitDebuff(unit, index)
            --            if icon then ksuto.printDebug("icon : " .. icon) end
            --            if count then ksuto.printDebug("count : " .. count) end
            --            if castable then ksuto.printDebug("castable : " .. castable) end
            --            if texture then ksuto.printDebug("texture : " .. texture) end
            --            if debuffType then ksuto.printDebug("debuffType : " .. debuffType) end
            --            if isStealable then ksuto.printDebug("isStealable : " .. isStealable) end
            --            if isMine then ksuto.printDebug("isMine : " .. isMine) end
            --            if shouldConsolidate then ksuto.printDebug("shouldConsolidate : " .. shouldConsolidate) end
            --            if spellId then ksuto.printDebug("spellId : " .. spellId) end
        end

        KsutoTooltip:SetUnitDebuff(unit, index);
        local debuffName = tostring(KsutoTooltipTextLeft1:GetText());
        --        ksuto.printDebug("debuffName : " .. debuffName)
        if (string.find(debuffName, effect)) then
            return true;
        end
        index = index + 1;
    end
    return false;
end

function ksuto.targetHasDebuff(effect)

    return ksuto.unitHasDebuff("target", effect)
end

function ksuto.unitHasBuff(unit, effect)

    -- ksuto.printDebug("function ksuto.unitHasBuff(" .. tostring(unit) .. ", " .. tostring(effect))
    local index = 1;
    while UnitBuff(unit, index) do

        if ksuto.DEBUG_MOD then
            local icon, count, castable, texture, debuffType, isStealable, isMine, shouldConsolidate, spellId = UnitBuff(unit, index)
            --            if icon then ksuto.printDebug("icon : " .. icon) end
            --            if count then ksuto.printDebug("count : " .. count) end
            --            if castable then ksuto.printDebug("castable : " .. castable) end
            --            if texture then ksuto.printDebug("texture : " .. texture) end
            --            if debuffType then ksuto.printDebug("debuffType : " .. debuffType) end
            --            if isStealable then ksuto.printDebug("isStealable : " .. isStealable) end
            --            if isMine then ksuto.printDebug("isMine : " .. isMine) end
            --            if shouldConsolidate then ksuto.printDebug("shouldConsolidate : " .. shouldConsolidate) end
            --            if spellId then ksuto.printDebug("spellId : " .. spellId) end
        end

        KsutoTooltip:SetUnitBuff(unit, index);
        local buffName = tostring(KsutoTooltipTextLeft1:GetText());
        --        ksuto.printDebug("buffName : " .. buffName)
        if (string.find(buffName, effect)) then
            return true;
        end
        index = index + 1;
    end
    return false;
end

function ksuto.playerHasBuff(effect)

    return ksuto.unitHasBuff("player", effect)
end

function ksuto.findSpell(spellName, bookType)

    -- ksuto.printDebug("function ksuto.findSpell(" .. tostring(spellName) .. ", " .. tostring(bookType))
    local i, s;
    local found = false;
    for i = 1, MAX_SKILLLINE_TABS do
        local name, texture, offset, numSpells = GetSpellTabInfo(i);
        if (not name) then break; end
        for s = offset + 1, offset + numSpells do
            local spell, rank = GetSpellName(s, bookType);
            if (spell == spellName) then found = true; end
            if (found and spell ~= spellName) then return s - 1; end
        end
    end
    if (found) then return s; end
    return nil;
end

function ksuto.dropSpellInBarSlot(spellName, slot)

    -- ksuto.printDebug("function ksuto.dropSpellInBarSlot(" .. tostring(spellName) .. ", " .. tostring(slot))

    local id = ksuto.findSpell(spellName, BOOKTYPE_SPELL);
    ksuto.print(tostring(id))
    --PickupSpell(spellName)
    if id then
        PickupSpell(id, BOOKTYPE_SPELL);
        PlaceAction(slot)
    end
end