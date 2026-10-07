Clockwork.DEBUG_MOD = false
Clockwork.CASTING = false;

Clockwork.UPDATE_INTERVAL = 0.2 -- 200ms
Clockwork.ADDING_WP = false;
Clockwork.TOGGLE_ON_OFF = false
Clockwork.TARGET_NEAREST_ENEMY = false
Clockwork.DRIVE_MOD = false
Clockwork.AGGRO_MOD = true
Clockwork.MULTI_MOD = false
Clockwork.DRIVE_LOOP = false
Clockwork.FISH_MOD = false

Clockwork.player = {}
---@alias PlayerClass { className:string, classFilename:string, classId:number }
---@type PlayerClass
Clockwork.player.class = nil
Clockwork.player.position = {}
Clockwork.player.position.posX = 0
Clockwork.player.position.posY = 0
Clockwork.player.isMoving = false
Clockwork.player.GUID = nil

Clockwork.pet = {}
Clockwork.pet.GUID = nil

---@class Dot: Frame , {}
---comment
---@param name any
---@param xPos any
---@param yPos any
---@return Dot
function Clockwork:createDot(name, xPos, yPos)
    local dotFrame = CreateFrame("FRAME", "clockWork_" .. name, Clockwork.frame)
    dotFrame:SetPoint("TOPLEFT", xPos, yPos)
    dotFrame:SetWidth(1)
    dotFrame:SetHeight(1)
    dotFrame:SetFrameStrata("TOOLTIP")
    dotFrame:SetFrameLevel(10)

    dotFrame.texture = dotFrame:CreateTexture(nil, "OVERLAY")
    dotFrame.texture:SetAllPoints()
    dotFrame.texture:SetColorTexture(0, 0, 0, 1)

    return dotFrame
end

---comment
---@param number number
---@return integer
---@return integer
function Clockwork.modulo(number)
    local modulo = number % 12               -- Get the modulo 12
    local quotient = math.floor(number / 12) -- Get the integer quotient (Lua 5.1 compatible)

    if modulo == 0 then
        modulo = 12
        quotient = quotient - 1
    end

    return modulo, quotient
end