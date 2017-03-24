--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 17/02/2017
-- Time: 13:51
-- To change this template use File | Settings | File Templates.
--

local function onUpdate()

    -- ksuto.printDebug("local function onUpdate(")

    local now = GetTime()

    if (ksuto.nextUpdate < now) then

        --ksuto.printDebug(ksuto.nextUpdate)

        if (ksuto.TOGGLE_ON_OFF and ksuto.ADDING_WP == false) then

            ksuto.updatePositionCoordinates()
            ksuto.rotation()
        end

        if ksuto.addWaypointList ~= nil and
                ksuto.ADDING_WP == false then

            local index = 0;
            local finished = true

            for coords in string.gfind(ksuto.addWaypointList, ".-;") do

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



local function onEvent()

    -- ksuto.printDebug("local function onEvent(")

    ksuto.printDebug("event = " .. event)

    if event == "SPELLCAST_START" or event == "SPELLCAST_CHANNEL_START" then

        ksuto.CASTING = true
    elseif event == "SPELLCAST_STOP" or event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" then
        ksuto.CASTING = false
    end

    if event == "PLAYER_ENTERING_WORLD" then

        ksuto.printDebug("GetCurrentResolution() : " .. tostring(GetCurrentResolution()))
        ksuto.printDebug("({ GetScreenResolutions() })[GetCurrentResolution()] : " .. tostring(({ GetScreenResolutions() })[GetCurrentResolution()]))

        local currentResulution = tostring(({ GetScreenResolutions() })[GetCurrentResolution()])
        local height = string.gsub(currentResulution, "%d+x", "")

        ksuto.printDebug("currentResolution height : " .. height)
        ksuto.printDebug("GetCVar(uiScale) : " .. GetCVar("uiScale"))

        ksuto.scaleMultiplicator = (768 / tonumber(height)) / GetCVar("uiScale")

        ksuto.print("scaleMultiplicator : " .. tostring(ksuto.scaleMultiplicator))

        -- init Frames

        ksuto.frame:SetWidth(ksuto.scale(16))
        ksuto.frame:SetHeight(ksuto.scale(16))

        ksuto.nextUpdate = 0
        ksuto.addWaypointList = nil
        ksuto.waypointListIndex = 0

        ksuto.blackBackground1 = CreateFrame("FRAME", "ksuto_ksuto.blackBackground1", ksuto.frame)
        ksuto.blackBackground1:SetPoint("CENTER", 0, 0)
        ksuto.blackBackground1:SetWidth(ksuto.scale(16))
        ksuto.blackBackground1:SetHeight(ksuto.scale(8))
        ksuto.blackBackground1:SetFrameStrata("MEDIUM");
        ksuto.blackBackground1.texture = ksuto.blackBackground1:CreateTexture("MEDIUM")
        ksuto.blackBackground1.texture:SetAllPoints()
        ksuto.blackBackground1.texture:SetTexture(0, 0, 0, 1)

        ksuto.blackBackground2 = CreateFrame("FRAME", "ksuto_Background2", ksuto.frame)
        ksuto.blackBackground2:SetPoint("CENTER", 0, 0)
        ksuto.blackBackground2:SetWidth(ksuto.scale(8))
        ksuto.blackBackground2:SetHeight(ksuto.scale(16))
        ksuto.blackBackground2:SetFrameStrata("MEDIUM");
        ksuto.blackBackground2.texture = ksuto.blackBackground2:CreateTexture("MEDIUM")
        ksuto.blackBackground2.texture:SetAllPoints()
        ksuto.blackBackground2.texture:SetTexture(0, 0, 0, 1)

        ksuto.blackBackground3 = CreateFrame("FRAME", "ksuto_Background3", ksuto.frame)
        ksuto.blackBackground3:SetPoint("CENTER", 0, 0)
        ksuto.blackBackground3:SetWidth(ksuto.scale(14))
        ksuto.blackBackground3:SetHeight(ksuto.scale(14))
        ksuto.blackBackground3:SetFrameStrata("MEDIUM");
        ksuto.blackBackground3.texture = ksuto.blackBackground3:CreateTexture("MEDIUM")
        ksuto.blackBackground3.texture:SetAllPoints()
        ksuto.blackBackground3.texture:SetTexture(0, 0, 0, 1)

        ksuto.onOff = CreateFrame("FRAME", "ksuto_onOff", ksuto.frame)
        ksuto.onOff:SetPoint("CENTER", 0, 0)
        ksuto.onOff:SetWidth(ksuto.scale(16))
        ksuto.onOff:SetHeight(ksuto.scale(16))
        ksuto.onOff:SetFrameStrata("DIALOG")
        ksuto.onOff.texture = ksuto.onOff:CreateTexture("DIALOG")
        ksuto.onOff.texture:SetAllPoints()
        ksuto.onOff.texture:SetTexture(0, 1, 0, 1)

        ksuto.inCombat = ksuto.createDot("ksuto_inCombat", 2, -2)
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

        ksuto.initKeys()
        ksuto.initCoords()
    end
end

ksuto.frame = CreateFrame("FRAME", "ksuto_MainFrame", UIParent)
ksuto.frame:SetPoint("TOPLEFT", 30, -100)
ksuto.frame:SetFrameStrata("MEDIUM")

ksuto.frame:SetScript("OnEvent", onEvent);
ksuto.frame:SetScript("OnUpdate", onUpdate);

ksuto.frame:RegisterEvent("PLAYER_ENTERING_WORLD");

ksuto.frame:RegisterEvent("SPELLCAST_START")
ksuto.frame:RegisterEvent("SPELLCAST_STOP")
ksuto.frame:RegisterEvent("SPELLCAST_FAILED")
ksuto.frame:RegisterEvent("SPELLCAST_INTERRUPTED")
ksuto.frame:RegisterEvent("SPELLCAST_DELAYED")
ksuto.frame:RegisterEvent("SPELLCAST_CHANNEL_START")
ksuto.frame:RegisterEvent("SPELLCAST_CHANNEL_UPDATE")
ksuto.frame:RegisterEvent("SPELLCAST_CHANNEL_STOP")

ksuto.frame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS") -- TODO : Inefficient ?


ksuto.frame.texture = ksuto.frame:CreateTexture("MEDIUM")
ksuto.frame.texture:SetAllPoints()
ksuto.frame.texture:SetTexture(0, 1, 0, 1)

