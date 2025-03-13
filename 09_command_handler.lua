--Chat commands

local function commandHandler(msg)

    -- Clockwork.log.debug("local function commandHandler(" .. tostring(msg))

    Clockwork.log.debug("Command Handler")

    local coordinates
    if msg ~= nil then coordinates = string.find(msg, '%d%d,%d%d.%d%d,%d%d;') end
    local spe
    if msg ~= nil then spe = string.find(msg, 'spe%d') end

    --Clockwork.log.debug("msg : " .. msg)
    if msg == 'toggle' then

        Clockwork.clickToggle()

    elseif coordinates ~= nil then

        coordinates = ""

        Clockwork.log.debug(msg)

        for coords in string.gmatch(msg, '%d%d,%d%d.%d%d,%d%d;') do
            coordinates = coordinates .. coords
        end

        Clockwork.addWaypointList = coordinates;

    elseif spe ~= nil then

        for spe in string.gmatch(msg, 'spe%d') do
            Clockwork.spe = tonumber(string.sub(spe, 4, 4))
        end

        if (Clockwork.spe > 3) then Clockwork.spe = 3 end

        Clockwork.log.debug("spe : " .. Clockwork.spe)

    elseif (msg == 'tne') then

        Clockwork.clickTNE()

    elseif (msg == 'addwp') then

        Clockwork.clickAddWp()

    elseif (msg == 'wpadded') then

        Clockwork.addWaypoint.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.ADDING_WP = false
        Clockwork.log.notice("Waypoint Added")

    elseif (msg == 'clearwp') then

        Clockwork.clickClearWp()

    elseif (msg == 'wpcleared') then

        Clockwork.clearWaypoints.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Waypoint cleared")

    elseif (msg == 'drive') then

        Clockwork.clickDrive()

    elseif (msg == 'loop') then

        Clockwork.clickLoop()

    elseif (msg == 'debug') then

        Clockwork.clickDebug()

    elseif (msg == 'listspells') then

        Clockwork.listAllSpells()

    elseif (msg == 'listactions') then

        Clockwork.reportActionButtons()

    else
        Clockwork.log.notice("------------ Clockwork ------------")
        Clockwork.log.notice("/clockWork toggle       -- Turn Clockwork On [Blush]/Off")
        Clockwork.log.notice("/clockWork spe1         -- Select spe (1/2/3)")
        Clockwork.log.notice("/clockWork tne          -- Target Nearest Enemy : On/Off")
        Clockwork.log.notice("/clockWork 05,21-63,30; -- Add new waypoint(s)")
        Clockwork.log.notice("/clockWork addwp        -- Add new waypoint")
        Clockwork.log.notice("/clockWork clearwp      -- Clear all waypoints")
        Clockwork.log.notice("/clockWork drive        -- Start Autopilote")
        Clockwork.log.notice("/clockWork loop         -- Loop through waypoints")
        Clockwork.log.notice("/clockWork debug        -- Debug Mod : On/Off")
        if Clockwork.DEBUG_MOD then Clockwork.log.notice("/clockWork listspells   -- List all spells") end
        if Clockwork.DEBUG_MOD then Clockwork.log.notice("/clockWork listactions  -- List all actions slots") end
    end
end

SlashCmdList['CLOCKWORK_SLASHCMD'] = commandHandler
SLASH_CLOCKWORK_SLASHCMD1 = '/clockwork'
SLASH_CLOCKWORK_SLASHCMD2 = '/clk'

function Clockwork.clickToggle()

    if Clockwork.TOGGLE_ON_OFF == false then

        Clockwork.TOGGLE_ON_OFF = true
        Clockwork.toggle.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.onOff:Hide()
        Clockwork.log.notice("On")

    else

        Clockwork.TOGGLE_ON_OFF = false
        Clockwork.toggle.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.onOff:Show()
        Clockwork.log.notice("Off")
    end
end

function Clockwork.clickTNE()

    if Clockwork.TARGET_NEAREST_ENEMY == false then

        Clockwork.TARGET_NEAREST_ENEMY = true
        Clockwork.targetNearestEnemy.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.log.notice("Target Nearest Enemy : On")
    else

        Clockwork.TARGET_NEAREST_ENEMY = false
        Clockwork.targetNearestEnemy.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Target Nearest Enemy : Off")
    end
end

function Clockwork.clickAddWp()

    Clockwork.log.notice("Adding Waypoint")
    Clockwork.addWaypoint.texture:SetColorTexture(1, 1, 1, 1)
    Clockwork.ADDING_WP = true
end

function Clockwork.clickClearWp()

    Clockwork.log.notice("Clearing Waypoints")
    Clockwork.clearWaypoints.texture:SetColorTexture(1, 1, 1, 1)
end

function Clockwork.clickDrive()

    if Clockwork.DRIVE_MOD == false then

        Clockwork.DRIVE_MOD = true
        Clockwork.drive.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.log.notice("Drive Mod : On")
    else

        Clockwork.DRIVE_MOD = false
        Clockwork.drive.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Drive Mod : Off")
    end
end

function Clockwork.clickLoop()

    if Clockwork.DRIVE_LOOP == false then

        Clockwork.DRIVE_LOOP = true
        Clockwork.driveLoop.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.log.notice("Drive Loop : On")
    else

        Clockwork.DRIVE_LOOP = false
        Clockwork.driveLoop.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Drive Loop : Off")
    end
end

function Clockwork.clickDebug()

    if Clockwork.DEBUG_MOD == false then

        Clockwork.DEBUG_MOD = true
        Clockwork.debug.texture:SetColorTexture(1, 0, 0, 1)
        Clockwork.log.notice("Debug Mod : On")
        Clockwork.log.debug("UnitClass : " .. UnitClass("player"))
    else

        Clockwork.DEBUG_MOD = false
        Clockwork.debug.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Debug Mod : Off")
    end
end

