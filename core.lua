-- init Frame

ksuto.frame = CreateFrame("FRAME", "ksuto_MainFrame", UIParent)
ksuto.frame:SetPoint("TOP", 0, -100)
ksuto.frame:SetWidth(16)
ksuto.frame:SetHeight(16)
ksuto.frame:SetFrameStrata("MEDIUM")
ksuto.frame.texture = ksuto.frame:CreateTexture("MEDIUM")
ksuto.frame.texture:SetAllPoints()
ksuto.frame.texture:SetTexture(0, 1, 0, 1)

ksuto.nextUpdate = 0
ksuto.addWaypointList = nil
ksuto.waypointListIndex = 0

function ksuto.frame:onUpdate(elapsed)

    local now = GetTime()

    if (ksuto.nextUpdate < now) then

        --ksuto.printDebug(ksuto.nextUpdate)

        if (ksuto.TOGGLE_ON_OFF) then

            ksuto.updatePositionCoordinates()
            ksuto.rotation()
        end

        if ksuto.addWaypointList ~= nil and
                ksuto.ADDING_WP == false then

            local index = 0;
            local finished = true

            for coords in string.gmatch(coordinates, ".-;") do

                if index == ksuto.waypointListIndex then

                    finished = false
                    ksuto.print("Ksuto -> Adding Waypoint : " .. coords)
                    ksuto.updatePositionFromCoordinates(coords)
                    ksuto.addWaypoint.texture:SetTexture(1, 1, 1, 1)
                    ksuto.ADDING_WP = true;
                end

                index = index + 1;
            end

            if (finished) then

                ksuto.addWaypointList = nil
                ksuto.waypointListIndex = 0
            end

            ksuto.waypointListIndex = ksuto.waypointListIndex + 1
        end

        ksuto.nextUpdate = now + ksuto.UPDATE_INTERVAL;
    end
end

ksuto.frame:SetScript("OnUpdate", ksuto.frame.onUpdate)

ksuto.blackBackground1 = CreateFrame("FRAME", "ksuto_ksuto.blackBackground1", ksuto.frame)
ksuto.blackBackground1:SetPoint("CENTER", 0, 0)
ksuto.blackBackground1:SetWidth(16)
ksuto.blackBackground1:SetHeight(8)
ksuto.blackBackground1:SetFrameStrata("MEDIUM");
ksuto.blackBackground1.texture = ksuto.blackBackground1:CreateTexture("MEDIUM")
ksuto.blackBackground1.texture:SetAllPoints()
ksuto.blackBackground1.texture:SetTexture(0, 0, 0, 1)

ksuto.blackBackground2 = CreateFrame("FRAME", "ksuto_Background2", ksuto.frame)
ksuto.blackBackground2:SetPoint("CENTER", 0, 0)
ksuto.blackBackground2:SetWidth(8)
ksuto.blackBackground2:SetHeight(16)
ksuto.blackBackground2:SetFrameStrata("MEDIUM");
ksuto.blackBackground2.texture = ksuto.blackBackground2:CreateTexture("MEDIUM")
ksuto.blackBackground2.texture:SetAllPoints()
ksuto.blackBackground2.texture:SetTexture(0, 0, 0, 1)

ksuto.blackBackground3 = CreateFrame("FRAME", "ksuto_Background3", ksuto.frame)
ksuto.blackBackground3:SetPoint("CENTER", 0, 0)
ksuto.blackBackground3:SetWidth(14)
ksuto.blackBackground3:SetHeight(14)
ksuto.blackBackground3:SetFrameStrata("MEDIUM");
ksuto.blackBackground3.texture = ksuto.blackBackground3:CreateTexture("MEDIUM")
ksuto.blackBackground3.texture:SetAllPoints()
ksuto.blackBackground3.texture:SetTexture(0, 0, 0, 1)

ksuto.onOff = CreateFrame("FRAME", "ksuto_onOff", ksuto.frame)
ksuto.onOff:SetPoint("CENTER", 0, 0)
ksuto.onOff:SetWidth(16)
ksuto.onOff:SetHeight(16)
ksuto.onOff:SetFrameStrata("DIALOG")
ksuto.onOff.texture = ksuto.onOff:CreateTexture("DIALOG")
ksuto.onOff.texture:SetAllPoints()
ksuto.onOff.texture:SetTexture(0, 1, 0, 1)

ksuto.health = ksuto.createDot("ksuto_health", 12, -2)
ksuto.mana = ksuto.createDot("ksuto_mana", 13, -2)
ksuto.toggle = ksuto.createDot("ksuto_toggle", 2, -13)
ksuto.targetNearestEnemy = ksuto.createDot("ksuto_targetNearestEnemy", 3, -13)
ksuto.addWaypoint = ksuto.createDot("ksuto_addWaypoint", 4, -13)
ksuto.clearWaypoints = ksuto.createDot("ksuto_clearWaypoints", 5, -13)
ksuto.drive = ksuto.createDot("ksuto_drive", 6, -13)
ksuto.driveLoop = ksuto.createDot("ksuto_driveLoop", 7, -13)
ksuto.debug = ksuto.createDot("ksuto_debug", 13, -13)
if ksuto.DEBUG_MOD then ksuto.debug.texture:SetTexture(1, 0, 0, 1) end