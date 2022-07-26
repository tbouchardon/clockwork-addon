clockWork = {}

clockWork.DEBUG_MOD = false
clockWork.CHECK_ACTIONS_CAST = true
clockWork.CASTING = false;

clockWork.UPDATE_INTERVAL = 0.2 -- 200ms
clockWork.ADDING_WP = false;
clockWork.TOGGLE_ON_OFF = false
clockWork.TARGET_NEAREST_ENEMY = false
clockWork.DRIVE_MOD = false
clockWork.AGGRO_MOD = true
clockWork.DRIVE_LOOP = false

clockWork.player = {}
clockWork.player.position = {}
clockWork.player.position.posX = 0
clockWork.player.position.posY = 0
clockWork.player.isMoving = false

function clockWork.print(text)

    -- clockWork.printDebug("function clockWork.print(" .. tostring(text))

    DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: " .. tostring(text))
end

function clockWork.createDot(name, xPos, yPos, slot, shiftslot, altslot)

    -- clockWork.printDebug("function clockWork.createDot(" .. tostring(name) .. ", " .. tostring(xPos) .. ", " .. tostring(yPos) .. ", " .. tostring(slot) .. ", " .. tostring(shiftslot))

    local dotFrame = CreateFrame("FRAME", "clockWork_" .. name, clockWork.frame)
    dotFrame:SetPoint("TOPLEFT", xPos, yPos)
    dotFrame:SetWidth(1)
    dotFrame:SetHeight(1)
    dotFrame:SetFrameStrata("HIGH");

    dotFrame.texture = dotFrame:CreateTexture(nil, "HIGH")
    dotFrame.texture:SetAllPoints()
    dotFrame.texture:SetColorTexture(0, 0, 0, 1)
    dotFrame.slot = slot;
    dotFrame.shiftslot = shiftslot;
    dotFrame.altslot = altslot;

    return dotFrame
end

clockWork.scaleMultiplicator = 0
function clockWork.scale(x)

    clockWork.printDebug("function clockWork.scale(" .. tostring(x))

    return clockWork.scaleMultiplicator * x
end