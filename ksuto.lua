

function rotation()

    ksuto.rotation()
end

--Chat commands

SLASH_KSUTO1 = '/ksuto'
SLASH_KSUTO2 = '/kto'

local function commandHandler(msg)

    ksuto.printDebug("Command Handler")

    local coordinates
    if msg ~= nil then coordinates = string.find(msg, '%d%d,%d%d.%d%d,%d%d;') end

    --ksuto.printDebug("msg : " .. msg)
    if msg == 'toggle' then

        if ksuto.TOGGLE_ON_OFF == false then

            ksuto.TOGGLE_ON_OFF = true
            ksuto.toggle.texture:SetTexture(1, 1, 1, 1)
            ksuto.onOff:Hide()
            ksuto.print("Ksuto : On")

        else

            ksuto.TOGGLE_ON_OFF = false
            ksuto.toggle.texture:SetTexture(0, 0, 0, 1)
            ksuto.onOff:Show()
            ksuto.print("Ksuto : Off")
        end

    elseif coordinates ~= nil then

        coordinates = ""

        for coords in string.gmatch(msg, '%d%d,%d%d.%d%d,%d%d;') do
            coordinates = coordinates .. coords
        end

        ksuto.printDebug(coordinates)
        ksuto.addWaypointList = coordinates;

    elseif (msg == 'tne') then

        if ksuto.TARGET_NEAREST_ENEMY == false then

            ksuto.TARGET_NEAREST_ENEMY = true
            ksuto.targetNearestEnemy.texture:SetTexture(1, 1, 1, 1)
            ksuto.print("Ksuto -> Target Nearest Enemy : On")
        else

            ksuto.TARGET_NEAREST_ENEMY = false
            ksuto.targetNearestEnemy.texture:SetTexture(0, 0, 0, 1)
            ksuto.print("Ksuto -> Target Nearest Enemy : Off")
        end

    elseif (msg == 'addwp') then

        ksuto.print("Ksuto -> Adding Waypoint")
        ksuto.addWaypoint.texture:SetTexture(1, 1, 1, 1)
        ksuto.ADDING_WP = true

    elseif (msg == 'wpadded') then

        ksuto.addWaypoint.texture:SetTexture(0, 0, 0, 1)
        ksuto.ADDING_WP = false
        ksuto.print("Ksuto -> Waypoint Added")

    elseif (msg == 'clearwp') then

        ksuto.print("Ksuto -> Clearing Waypoints")
        ksuto.clearWaypoints.texture:SetTexture(1, 1, 1, 1)

    elseif (msg == 'wpcleared') then

        ksuto.clearWaypoints.texture:SetTexture(0, 0, 0, 1)
        ksuto.print("Ksuto -> Waypoint cleared")

    elseif (msg == 'drive') then

        if ksuto.DRIVE_MOD == false then

            ksuto.DRIVE_MOD = true
            ksuto.drive.texture:SetTexture(1, 1, 1, 1)
            ksuto.print("Ksuto -> Drive Mod : On")
        else

            ksuto.DRIVE_MOD = false
            ksuto.drive.texture:SetTexture(0, 0, 0, 1)
            ksuto.print("Ksuto -> Drive Mod : Off")
        end

    elseif (msg == 'loop') then

        if ksuto.DRIVE_LOOP == false then

            ksuto.DRIVE_LOOP = true
            ksuto.driveLoop.texture:SetTexture(1, 1, 1, 1)
            ksuto.print("Ksuto -> Drive Loop : On")
        else

            ksuto.DRIVE_LOOP = false
            ksuto.driveLoop.texture:SetTexture(0, 0, 0, 1)
            ksuto.print("Ksuto -> Drive Loop : Off")
        end

    elseif (msg == 'debug') then

        if ksuto.DEBUG_MOD == false then

            ksuto.DEBUG_MOD = true
            ksuto.debug.texture:SetTexture(1, 0, 0, 1)
            ksuto.print("Ksuto -> Debug Mod : On")
        else

            ksuto.DEBUG_MOD = false
            ksuto.debug.texture:SetTexture(0, 0, 0, 1)
            ksuto.print("Ksuto -> Debug Mod : Off")
        end

    elseif (msg == 'listspells') then

        ksuto.listAllSpells()

    elseif (msg == 'listactions') then

        ksuto.reportActionButtons()

    else
        ksuto.print("------------ KSUTO ------------")
        ksuto.print("/ksuto toggle       -- Turn Ksuto On [Blush]/Off")
        ksuto.print("/ksuto tne          -- Target Nearest Enemy : On/Off")
        ksuto.print("/ksuto 05,21-63,30; -- Add new waypoint(s)")
        ksuto.print("/ksuto addwp        -- Add new waypoint")
        ksuto.print("/ksuto clearwp      -- Clear all waypoints")
        ksuto.print("/ksuto drive        -- Start Autopilote")
        ksuto.print("/ksuto loop         -- Loop through waypoints")
        ksuto.print("/ksuto debug        -- Debug Mod : On/Off")
        if ksuto.DEBUG_MOD then ksuto.print("/ksuto listspells   -- List all spells") end
        if ksuto.DEBUG_MOD then ksuto.print("/ksuto listactions  -- List all actions slots") end
    end
end

SlashCmdList["KSUTO"] = commandHandler

