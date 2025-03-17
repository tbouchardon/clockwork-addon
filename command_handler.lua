--Chat commands

function Clockwork:commandHandler(msg)
    -- Clockwork.log.debug("local function commandHandler(" .. tostring(msg))

    Clockwork.log.debug("Command Handler")

    local coordinates
    if msg ~= nil then coordinates = string.find(msg, '%d%d,%d%d.%d%d,%d%d;') end

    Clockwork.log.debug("msg : " .. tostring(msg))
    if msg == 'toggle' then
        self:clickToggle()
    elseif coordinates ~= nil then
        coordinates = ""

        Clockwork.log.debug(msg)

        for coords in string.gmatch(msg, '%d%d,%d%d.%d%d,%d%d;') do
            coordinates = coordinates .. coords
        end

        self.addWaypointList = coordinates;
    elseif (msg == 'tne') then
        self:clickTNE()
    elseif (msg == 'addwp') then
        self:clickAddWp()
    elseif (msg == 'wpadded') then
        self.addWaypoint.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.ADDING_WP = false
        Clockwork.log.notice("Waypoint Added")
    elseif (msg == 'clearwp') then
        self:clickClearWp()
    elseif (msg == 'wpcleared') then
        self.clearWaypoints.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Waypoint cleared")
    elseif (msg == 'drive') then
        self:clickDrive()
    elseif (msg == 'loop') then
        self:clickLoop()
    elseif (msg == 'debug') then
        self:clickDebug()
    elseif (msg == 'listspells') then
        self:listAllSpells()
    elseif (msg == 'listactions') then
        self:reportActionButtons()
    elseif (msg == 'update actions') then
        self:updateActionButtons()
    else
        Clockwork.log.notice("------------ Clockwork ------------")
        Clockwork.log.notice("/clockWork toggle         -- Turn Clockwork On [Blush]/Off")
        Clockwork.log.notice("/clockWork tne            -- Target Nearest Enemy : On/Off")
        Clockwork.log.notice("/clockWork 05,21-63,30;   -- Add new waypoint(s)")
        Clockwork.log.notice("/clockWork addwp          -- Add new waypoint")
        Clockwork.log.notice("/clockWork clearwp        -- Clear all waypoints")
        Clockwork.log.notice("/clockWork drive          -- Start Autopilote")
        Clockwork.log.notice("/clockWork loop           -- Loop through waypoints")
        Clockwork.log.notice("/clockWork update actions -- Update action buttons")
        Clockwork.log.notice("/clockWork debug          -- Debug Mod : On/Off")
        if Clockwork.DEBUG_MOD then Clockwork.log.notice("/clockWork listspells   -- List all spells") end
        if Clockwork.DEBUG_MOD then Clockwork.log.notice("/clockWork listactions  -- List all actions slots") end
    end
end

SlashCmdList['CLOCKWORK_SLASHCMD'] = function (...) Clockwork.commandHandler(Clockwork, ...) end
SLASH_CLOCKWORK_SLASHCMD1 = '/clockwork'
SLASH_CLOCKWORK_SLASHCMD2 = '/clk'

function Clockwork:clickToggle()
    if Clockwork.TOGGLE_ON_OFF == false then
        Clockwork.TOGGLE_ON_OFF = true
        self.toggle.texture:SetColorTexture(1, 1, 1, 1)
        self.onOff:Hide()
        Clockwork.log.notice("On")
    else
        Clockwork.TOGGLE_ON_OFF = false
        self.toggle.texture:SetColorTexture(0, 0, 0, 1)
        self.onOff:Show()
        Clockwork.log.notice("Off")
    end
end

function Clockwork:clickTNE()
    if Clockwork.TARGET_NEAREST_ENEMY == false then
        Clockwork.TARGET_NEAREST_ENEMY = true
        self.targetNearestEnemy.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.log.notice("Target Nearest Enemy : On")
    else
        Clockwork.TARGET_NEAREST_ENEMY = false
        Clockwork.targetNearestEnemy.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Target Nearest Enemy : Off")
    end
end

function Clockwork:clickAddWp()
    Clockwork.log.notice("Adding Waypoint")
    self.addWaypoint.texture:SetColorTexture(1, 1, 1, 1)
    Clockwork.ADDING_WP = true
end

function Clockwork:clickClearWp()
    Clockwork.log.notice("Clearing Waypoints")
    self.clearWaypoints.texture:SetColorTexture(1, 1, 1, 1)
end

function Clockwork:clickDrive()
    if Clockwork.DRIVE_MOD == false then
        Clockwork.DRIVE_MOD = true
        self.drive.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.log.notice("Drive Mod : On")
    else
        Clockwork.DRIVE_MOD = false
        self.drive.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Drive Mod : Off")
    end
end

function Clockwork:clickLoop()
    if Clockwork.DRIVE_LOOP == false then
        Clockwork.DRIVE_LOOP = true
        self.driveLoop.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.log.notice("Drive Loop : On")
    else
        Clockwork.DRIVE_LOOP = false
        self.driveLoop.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Drive Loop : Off")
    end
end

function Clockwork:clickDebug()
    if Clockwork.DEBUG_MOD == false then
        Clockwork.DEBUG_MOD = true
        Clockwork.LOG_LEVEL = 'DEBUG'
        self.debug.texture:SetColorTexture(1, 0, 0, 1)
        Clockwork.log.notice("Debug Mod : On")
        Clockwork.log.debug("UnitClass : " .. UnitClass("player"))
    else
        Clockwork.DEBUG_MOD = false
        Clockwork.LOG_LEVEL = 'NOTICE'
        self.debug.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Debug Mod : Off")
    end
end
