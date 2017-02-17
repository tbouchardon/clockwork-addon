ksuto = {}

ksuto.DEBUG_MOD = false
ksuto.CHECK_ACTIONS_CAST = true

ksuto.UPDATE_INTERVAL = 0.2 -- 200ms
ksuto.ADDING_WP = false;
ksuto.TOGGLE_ON_OFF = false
ksuto.TARGET_NEAREST_ENEMY = false
ksuto.DRIVE_MOD = false
ksuto.DRIVE_LOOP = false

function ksuto.print(text)

    DEFAULT_CHAT_FRAME:AddMessage(text)
end

function ksuto.createDot(name, xPos, yPos, slot, shiftslot)

    local dotFrame = CreateFrame("FRAME", "ksuto_" .. name, ksuto.frame)
    dotFrame:SetPoint("TOPLEFT", ksuto.scale(xPos), ksuto.scale(yPos))
    dotFrame:SetWidth(ksuto.scale(1))
    dotFrame:SetHeight(ksuto.scale(1))
    dotFrame:SetFrameStrata("HIGH");

    dotFrame.texture = dotFrame:CreateTexture("HIGH")
    dotFrame.texture:SetAllPoints()
    dotFrame.texture:SetTexture(0, 0, 0, 1)
    dotFrame.slot = slot;
    dotFrame.shiftslot = shiftslot;

    return dotFrame
end

ksuto.scaleMultiplicator = 0
function ksuto.scale(x) return ksuto.scaleMultiplicator * x end