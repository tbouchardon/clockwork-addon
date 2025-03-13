Clockwork.DEBUG_MOD = false
Clockwork.CHECK_ACTIONS_CAST = true
Clockwork.CASTING = false;

Clockwork.UPDATE_INTERVAL = 0.2 -- 200ms
Clockwork.ADDING_WP = false;
Clockwork.TOGGLE_ON_OFF = false
Clockwork.TARGET_NEAREST_ENEMY = false
Clockwork.DRIVE_MOD = false
Clockwork.AGGRO_MOD = true
Clockwork.DRIVE_LOOP = false

Clockwork.player = {}
Clockwork.player.position = {}
Clockwork.player.position.posX = 0
Clockwork.player.position.posY = 0
Clockwork.player.isMoving = false
Clockwork.player.GUID = nil

Clockwork.pet = {}
Clockwork.pet.GUID = nil

Clockwork.targets = {}
Clockwork.targets.list = {}
Clockwork.targets.count = 0
Clockwork.targets.multiTargetMod = false
Clockwork.targets.multiTargetModTrigger = 3

function Clockwork.createDot(name, xPos, yPos, slot, shiftslot, altslot)

    -- Clockwork.printDebug("function Clockwork.createDot(" .. tostring(name) .. ", " .. tostring(xPos) .. ", " .. tostring(yPos) .. ", " .. tostring(slot) .. ", " .. tostring(shiftslot))

    local dotFrame = CreateFrame("FRAME", "clockWork_" .. name, Clockwork.frame)
    dotFrame:SetPoint("TOPLEFT", xPos, yPos)
    dotFrame:SetWidth(1)
    dotFrame:SetHeight(1)
    dotFrame:SetFrameStrata("HIGH");

    dotFrame.texture = dotFrame:CreateTexture(nil, "HIGHLIGHT")
    dotFrame.texture:SetAllPoints()
    dotFrame.texture:SetColorTexture(0, 0, 0, 1)
    dotFrame.slot = slot;
    dotFrame.shiftslot = shiftslot;
    dotFrame.altslot = altslot;

    dotFrame.priority = -1

    return dotFrame
end

function Clockwork.tableLength(T)

    if T == nil then
        return 0
    end
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function Clockwork.emptyOrNil(s)

    if s == nil then
        return true
    end
    if s == "" then
        return true
    end
    if s == 0 then
        return true
    end
    return false
end

function Clockwork.ternary(condition, if_true, if_false)
    if condition then
        return if_true
    else
        return if_false
    end
end