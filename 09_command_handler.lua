--Chat commands

local function commandHandler(msg)

    -- clockWork.printDebug("local function commandHandler(" .. tostring(msg))

    clockWork.printDebug("Command Handler")

    local coordinates
    if msg ~= nil then coordinates = string.find(msg, '%d%d,%d%d.%d%d,%d%d;') end
    local spe
    if msg ~= nil then spe = string.find(msg, 'spe%d') end

    --clockWork.printDebug("msg : " .. msg)
    if msg == 'toggle' then

        clockWork.clickToggle()

    elseif coordinates ~= nil then

        coordinates = ""

        clockWork.printDebug(msg)

        for coords in string.gfind(msg, '%d%d,%d%d.%d%d,%d%d;') do
            coordinates = coordinates .. coords
        end

        clockWork.addWaypointList = coordinates;

    elseif spe ~= nil then

        for spe in string.gfind(msg, 'spe%d') do
            clockWork.spe = tonumber(string.sub(spe, 4, 4))
        end

        if (clockWork.spe > 3) then clockWork.spe = 3 end

        clockWork.printDebug("spe : " .. clockWork.spe)

    elseif (msg == 'tne') then

        clockWork.clickTNE()

    elseif (msg == 'addwp') then

        clockWork.clickAddWp()

    elseif (msg == 'wpadded') then

        clockWork.addWaypoint.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.ADDING_WP = false
        clockWork.print("Waypoint Added")

    elseif (msg == 'clearwp') then

        clockWork.clickClearWp()

    elseif (msg == 'wpcleared') then

        clockWork.clearWaypoints.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.print("Waypoint cleared")

    elseif (msg == 'drive') then

        clockWork.clickDrive()

    elseif (msg == 'loop') then

        clockWork.clickLoop()

    elseif (msg == 'debug') then

        clockWork.clickDebug()

    elseif (msg == 'listspells') then

        clockWork.listAllSpells()

    elseif (msg == 'listactions') then

        clockWork.reportActionButtons()

    else
        clockWork.print("------------ ClockWork ------------")
        clockWork.print("/clockWork toggle       -- Turn ClockWork On [Blush]/Off")
        clockWork.print("/clockWork spe1         -- Select spe (1/2/3)")
        clockWork.print("/clockWork tne          -- Target Nearest Enemy : On/Off")
        clockWork.print("/clockWork 05,21-63,30; -- Add new waypoint(s)")
        clockWork.print("/clockWork addwp        -- Add new waypoint")
        clockWork.print("/clockWork clearwp      -- Clear all waypoints")
        clockWork.print("/clockWork drive        -- Start Autopilote")
        clockWork.print("/clockWork loop         -- Loop through waypoints")
        clockWork.print("/clockWork debug        -- Debug Mod : On/Off")
        if clockWork.DEBUG_MOD then clockWork.print("/clockWork listspells   -- List all spells") end
        if clockWork.DEBUG_MOD then clockWork.print("/clockWork listactions  -- List all actions slots") end
    end
end

SlashCmdList['CLOCKWORK_SLASHCMD'] = commandHandler
SLASH_CLOCKWORK_SLASHCMD1 = '/clockwork'
SLASH_CLOCKWORK_SLASHCMD2 = '/clk'

function clockWork.clickToggle()

    if clockWork.TOGGLE_ON_OFF == false then

        clockWork.TOGGLE_ON_OFF = true
        clockWork.toggle.texture:SetColorTexture(1, 1, 1, 1)
        clockWork.onOff:Hide()
        clockWork.print("On")

    else

        clockWork.TOGGLE_ON_OFF = false
        clockWork.toggle.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.onOff:Show()
        clockWork.print("Off")
    end
end

function clockWork.clickTNE()

    if clockWork.TARGET_NEAREST_ENEMY == false then

        clockWork.TARGET_NEAREST_ENEMY = true
        clockWork.targetNearestEnemy.texture:SetColorTexture(1, 1, 1, 1)
        clockWork.print("Target Nearest Enemy : On")
    else

        clockWork.TARGET_NEAREST_ENEMY = false
        clockWork.targetNearestEnemy.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.print("Target Nearest Enemy : Off")
    end
end

function clockWork.clickAddWp()

    clockWork.print("Adding Waypoint")
    clockWork.addWaypoint.texture:SetColorTexture(1, 1, 1, 1)
    clockWork.ADDING_WP = true
end

function clockWork.clickClearWp()

    clockWork.print("Clearing Waypoints")
    clockWork.clearWaypoints.texture:SetColorTexture(1, 1, 1, 1)
end

function clockWork.clickDrive()

    if clockWork.DRIVE_MOD == false then

        clockWork.DRIVE_MOD = true
        clockWork.drive.texture:SetColorTexture(1, 1, 1, 1)
        clockWork.print("Drive Mod : On")
    else

        clockWork.DRIVE_MOD = false
        clockWork.drive.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.print("Drive Mod : Off")
    end
end

function clockWork.clickLoop()

    if clockWork.DRIVE_LOOP == false then

        clockWork.DRIVE_LOOP = true
        clockWork.driveLoop.texture:SetColorTexture(1, 1, 1, 1)
        clockWork.print("Drive Loop : On")
    else

        clockWork.DRIVE_LOOP = false
        clockWork.driveLoop.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.print("Drive Loop : Off")
    end
end

function clockWork.clickDebug()

    if clockWork.DEBUG_MOD == false then

        clockWork.DEBUG_MOD = true
        clockWork.debug.texture:SetColorTexture(1, 0, 0, 1)
        clockWork.print("Debug Mod : On")
        clockWork.printDebug("UnitClass : " .. UnitClass("player"))
    else

        clockWork.DEBUG_MOD = false
        clockWork.debug.texture:SetColorTexture(0, 0, 0, 1)
        clockWork.print("Debug Mod : Off")
    end
end

