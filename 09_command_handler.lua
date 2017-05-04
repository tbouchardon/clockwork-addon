--Chat commands

SLASH_KSUTO1 = '/ksuto'
SLASH_KSUTO2 = '/kto'

local function commandHandler(msg)

    -- ksuto.printDebug("local function commandHandler(" .. tostring(msg))

    ksuto.printDebug("Command Handler")

    local coordinates
    if msg ~= nil then coordinates = string.find(msg, '%d%d,%d%d.%d%d,%d%d;') end
    local spe
    if msg ~= nil then spe = string.find(msg, 'spe%d') end

    --ksuto.printDebug("msg : " .. msg)
    if msg == 'toggle' then

        ksuto.clickToggle()

    elseif coordinates ~= nil then

        coordinates = ""

        ksuto.printDebug(msg)

        for coords in string.gfind(msg, '%d%d,%d%d.%d%d,%d%d;') do
            coordinates = coordinates .. coords
        end

        ksuto.addWaypointList = coordinates;

    elseif spe ~= nil then

        for spe in string.gfind(msg, 'spe%d') do
            ksuto.spe = tonumber(string.sub(spe, 4, 4))
        end

        if (ksuto.spe > 3) then ksuto.spe = 3 end

        ksuto.printDebug("spe : " .. ksuto.spe)

    elseif (msg == 'tne') then

        ksuto.clickTNE()

    elseif (msg == 'addwp') then

        ksuto.clickAddWp()

    elseif (msg == 'wpadded') then

        ksuto.addWaypoint.texture:SetTexture(0, 0, 0, 1)
        ksuto.ADDING_WP = false
        ksuto.print("Ksuto -> Waypoint Added")

    elseif (msg == 'clearwp') then

        ksuto.clickClearWp()

    elseif (msg == 'wpcleared') then

        ksuto.clearWaypoints.texture:SetTexture(0, 0, 0, 1)
        ksuto.print("Ksuto -> Waypoint cleared")

    elseif (msg == 'drive') then

        ksuto.clickDrive()

    elseif (msg == 'loop') then

        ksuto.clickLoop()

    elseif (msg == 'debug') then

        ksuto.clickDebug()

    elseif (msg == 'listspells') then

        ksuto.listAllSpells()

    elseif (msg == 'listactions') then

        ksuto.reportActionButtons()

    else
        ksuto.print("------------ KSUTO ------------")
        ksuto.print("/ksuto toggle       -- Turn Ksuto On [Blush]/Off")
        ksuto.print("/ksuto spe1         -- Select spe (1/2/3)")
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

function ksuto.clickToggle()

    if ksuto.TOGGLE_ON_OFF == false then

        ksuto.TOGGLE_ON_OFF = true
        ksuto.toggle.texture:SetTexture(1, 1, 1, 1)
        ksuto.onOff:Hide()
        ksuto.print("Ksuto -> On")

    else

        ksuto.TOGGLE_ON_OFF = false
        ksuto.toggle.texture:SetTexture(0, 0, 0, 1)
        ksuto.onOff:Show()
        ksuto.print("Ksuto -> Off")
    end
end

function ksuto.clickTNE()

    if ksuto.TARGET_NEAREST_ENEMY == false then

        ksuto.TARGET_NEAREST_ENEMY = true
        ksuto.targetNearestEnemy.texture:SetTexture(1, 1, 1, 1)
        ksuto.print("Ksuto -> Target Nearest Enemy : On")
    else

        ksuto.TARGET_NEAREST_ENEMY = false
        ksuto.targetNearestEnemy.texture:SetTexture(0, 0, 0, 1)
        ksuto.print("Ksuto -> Target Nearest Enemy : Off")
    end
end

function ksuto.clickAddWp()

    ksuto.print("Ksuto -> Adding Waypoint")
    ksuto.addWaypoint.texture:SetTexture(1, 1, 1, 1)
    ksuto.ADDING_WP = true
end

function ksuto.clickClearWp()

    ksuto.print("Ksuto -> Clearing Waypoints")
    ksuto.clearWaypoints.texture:SetTexture(1, 1, 1, 1)
end

function ksuto.clickDrive()

    if ksuto.DRIVE_MOD == false then

        ksuto.DRIVE_MOD = true
        ksuto.drive.texture:SetTexture(1, 1, 1, 1)
        ksuto.print("Ksuto -> Drive Mod : On")
    else

        ksuto.DRIVE_MOD = false
        ksuto.drive.texture:SetTexture(0, 0, 0, 1)
        ksuto.print("Ksuto -> Drive Mod : Off")
    end
end

function ksuto.clickLoop()

    if ksuto.DRIVE_LOOP == false then

        ksuto.DRIVE_LOOP = true
        ksuto.driveLoop.texture:SetTexture(1, 1, 1, 1)
        ksuto.print("Ksuto -> Drive Loop : On")
    else

        ksuto.DRIVE_LOOP = false
        ksuto.driveLoop.texture:SetTexture(0, 0, 0, 1)
        ksuto.print("Ksuto -> Drive Loop : Off")
    end
end

function ksuto.clickDebug()

    if ksuto.DEBUG_MOD == false then

        ksuto.DEBUG_MOD = true
        ksuto.debug.texture:SetTexture(1, 0, 0, 1)
        ksuto.print("Ksuto -> Debug Mod : On")
        ksuto.printDebug("UnitClass : " .. UnitClass("player"))
    else

        ksuto.DEBUG_MOD = false
        ksuto.debug.texture:SetTexture(0, 0, 0, 1)
        ksuto.print("Ksuto -> Debug Mod : Off")
    end
end