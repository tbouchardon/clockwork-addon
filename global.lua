

ksuto = {}

ksuto.UPDATE_INTERVAL = 0.25
ksuto.ADDING_WP = false;
ksuto.TOGGLE_ON_OFF = false
ksuto.TARGET_NEAREST_ENEMY = false
ksuto.DRIVE_MOD = false
ksuto.DRIVE_LOOP = false
ksuto.DEBUG_MOD = false

function ksuto.print(text)

    DEFAULT_CHAT_FRAME:AddMessage(text)
end

function ksuto.printDebug(text)

    if ksuto.DEBUG_MOD then

        DEFAULT_CHAT_FRAME:AddMessage("Ksuto (Debug) -> " .. text)
    end
end

function ksuto.createDot(name, xPos, yPos)

    local dotFrame = CreateFrame("FRAME", "ksuto_" .. name, ksuto.frame)
    dotFrame:SetPoint("TOPLEFT", xPos, yPos)
    dotFrame:SetWidth(1)
    dotFrame:SetHeight(1)
    dotFrame:SetFrameStrata("HIGH");

    dotFrame.texture = dotFrame:CreateTexture("HIGH")
    dotFrame.texture:SetAllPoints()
    dotFrame.texture:SetTexture(0, 0, 0, 1)

    return dotFrame
end

function ksuto.getBuffName(id)
    KsutoTooltip:SetUnitBuff(id)
    local buffName = tostring(KsutoTooltipTextLeft1:GetText());
    if (buffName) then
        return buffName:GetText() or id
    end
    return id
end

function ksuto.unitHasDebuff(unit, effect)
    local index = 1;
    while UnitDebuff(unit, index) do

        if ksuto.DEBUG_MOD then
            local icon, count, castable, texture, debuffType, isStealable, isMine, shouldConsolidate, spellId = UnitDebuff(unit, index)
            if icon then ksuto.printDebug("icon : " .. icon) end
            if count then ksuto.printDebug("count : " .. count) end
            if castable then ksuto.printDebug("castable : " .. castable) end
            if texture then ksuto.printDebug("texture : " .. texture) end
            if debuffType then ksuto.printDebug("debuffType : " .. debuffType) end
            if isStealable then ksuto.printDebug("isStealable : " .. isStealable) end
            if isMine then ksuto.printDebug("isMine : " .. isMine) end
            if shouldConsolidate then ksuto.printDebug("shouldConsolidate : " .. shouldConsolidate) end
            if spellId then ksuto.printDebug("spellId : " .. spellId) end
        end

        KsutoTooltip:SetUnitDebuff(unit, index);
        local debuffName = tostring(KsutoTooltipTextLeft1:GetText());
        ksuto.printDebug("debuffName : " .. debuffName)
        if (string.find(debuffName, effect)) then
            return true;
        end
        index = index + 1;
    end
    return false;
end

function ksuto.unitHasBuff(unit, effect)
    local index = 1;
    while UnitBuff(unit, index) do

        if ksuto.DEBUG_MOD then
            local icon, count, castable, texture, debuffType, isStealable, isMine, shouldConsolidate, spellId = UnitBuff(unit, index)
            if icon then ksuto.printDebug("icon : " .. icon) end
            if count then ksuto.printDebug("count : " .. count) end
            if castable then ksuto.printDebug("castable : " .. castable) end
            if texture then ksuto.printDebug("texture : " .. texture) end
            if debuffType then ksuto.printDebug("debuffType : " .. debuffType) end
            if isStealable then ksuto.printDebug("isStealable : " .. isStealable) end
            if isMine then ksuto.printDebug("isMine : " .. isMine) end
            if shouldConsolidate then ksuto.printDebug("shouldConsolidate : " .. shouldConsolidate) end
            if spellId then ksuto.printDebug("spellId : " .. spellId) end
        end

        KsutoTooltip:SetUnitBuff(unit, index);
        local buffName = tostring(KsutoTooltipTextLeft1:GetText());
        ksuto.printDebug("buffName : " .. buffName)
        if (string.find(buffName, effect)) then
            return true;
        end
        index = index + 1;
    end
    return false;
end