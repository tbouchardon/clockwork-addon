--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 17/02/2017
-- Time: 13:51
-- To change this template use File | Settings | File Templates.
--

function clockWork.addonLoaded()

    if ClockWork_ROTATIONS == nil then
        ClockWork_ROTATIONS = {};
    end
end

function clockWork.playerEnteringWorld()

    clockWork.printDebug("GetCurrentResolution() : " .. tostring(GetCurrentResolution()))
    clockWork.printDebug("GetScreenResolutions() : " .. tostring(GetScreenResolutions()))
    clockWork.printDebug("({ GetScreenResolutions() })[GetCurrentResolution()] : " .. tostring(GetScreenResolutions()[GetCurrentResolution()]))

    --local currentResulution = tostring(({ GetScreenResolutions() })[GetCurrentResolution()])
    local currentResulution = tostring(GetScreenResolutions())
    local height = string.gsub(currentResulution, "%d+x", "")

    clockWork.printDebug("currentResolution height : " .. height)
    clockWork.printDebug("GetCVar(uiScale) : " .. GetCVar("uiScale"))

    clockWork.scaleMultiplicator = (768 / tonumber(height)) / GetCVar("uiScale")

    clockWork.print("scaleMultiplicator : " .. tostring(clockWork.scaleMultiplicator))

    -- init Frames

    clockWork.frame:SetWidth(16)
    clockWork.frame:SetHeight(16)

    clockWork.nextUpdate = 0
    clockWork.addWaypointList = nil
    clockWork.waypointListIndex = 0

    clockWork.blackBackground3 = CreateFrame("FRAME", "clockWork_Background3", clockWork.frame)
    clockWork.blackBackground3:SetPoint("CENTER", 0, 0)
    clockWork.blackBackground3:SetWidth(14)
    clockWork.blackBackground3:SetHeight(14)
    clockWork.blackBackground3:SetFrameStrata("MEDIUM");
    clockWork.blackBackground3.texture = clockWork.blackBackground3:CreateTexture(nil, "BACKGROUND")
    clockWork.blackBackground3.texture:SetAllPoints()
    clockWork.blackBackground3.texture:SetColorTexture(0, 0, 0, 1)

    clockWork.blackBackground1 = CreateFrame("FRAME", "clockWork_Background1", clockWork.frame)
    clockWork.blackBackground1:SetPoint("CENTER", 0, 0)
    clockWork.blackBackground1:SetSize(16, 8)
    clockWork.blackBackground1:SetFrameStrata("MEDIUM");
    clockWork.blackBackground1.texture = clockWork.blackBackground1:CreateTexture(nil, "ARTWORK")
    clockWork.blackBackground1.texture:SetAllPoints()
    clockWork.blackBackground1.texture:SetColorTexture(0, 0, 0, 1)

    clockWork.blackBackground2 = CreateFrame("FRAME", "clockWork_Background2", clockWork.frame)
    clockWork.blackBackground2:SetPoint("CENTER", 0, 0)
    clockWork.blackBackground2:SetWidth(8)
    clockWork.blackBackground2:SetHeight(16)
    clockWork.blackBackground2:SetFrameStrata("MEDIUM");
    clockWork.blackBackground2.texture = clockWork.blackBackground2:CreateTexture(nil, "ARTWORK")
    clockWork.blackBackground2.texture:SetAllPoints()
    clockWork.blackBackground2.texture:SetColorTexture(0, 0, 0, 1)

    clockWork.onOff = CreateFrame("FRAME", "clockWork_onOff", clockWork.frame)
    clockWork.onOff:SetPoint("CENTER", 0, 0)
    clockWork.onOff:SetWidth(16)
    clockWork.onOff:SetHeight(16)
    clockWork.onOff:SetFrameStrata("DIALOG")
    clockWork.onOff.texture = clockWork.onOff:CreateTexture("DIALOG")
    clockWork.onOff.texture:SetAllPoints()
    clockWork.onOff.texture:SetColorTexture(0, 1, 0, 1)

    clockWork.inCombat = clockWork.createDot("clockWork_inCombat", 2, -2)
    clockWork.casting = clockWork.createDot("clockWork_casting", 3, -2)
    clockWork.stepBack = clockWork.createDot("clockWork_stepBack", 4, -2)

    clockWork.playerHealth = clockWork.createDot("clockWork_health", 12, -2)
    clockWork.playerMana = clockWork.createDot("clockWork_mana", 13, -2)
    clockWork.targetReaction = clockWork.createDot("clockWork_target_reaction", 11, -3)
    clockWork.targetHealth = clockWork.createDot("clockWork_target_health", 12, -3)
    clockWork.targetMana = clockWork.createDot("clockWork_target_mana", 13, -3)

    clockWork.toggle = clockWork.createDot("clockWork_toggle", 2, -13)
    clockWork.targetNearestEnemy = clockWork.createDot("clockWork_targetNearestEnemy", 3, -13)
    clockWork.addWaypoint = clockWork.createDot("clockWork_addWaypoint", 4, -13)
    clockWork.clearWaypoints = clockWork.createDot("clockWork_clearWaypoints", 5, -13)
    clockWork.drive = clockWork.createDot("clockWork_drive", 6, -13)
    clockWork.driveLoop = clockWork.createDot("clockWork_driveLoop", 7, -13)
    clockWork.debug = clockWork.createDot("clockWork_debug", 13, -13)
    if clockWork.DEBUG_MOD then
        clockWork.debug.texture:SetColorTexture(1, 0, 0, 1)
    end

    clockWork.raid = {}

    table.insert(clockWork.raid, 1, clockWork.createDot("clockWork_raid1", 3, -1))
    table.insert(clockWork.raid, 2, clockWork.createDot("clockWork_raid2", 4, -1))
    table.insert(clockWork.raid, 3, clockWork.createDot("clockWork_raid3", 5, -1))
    table.insert(clockWork.raid, 4, clockWork.createDot("clockWork_raid4", 6, -1))
    table.insert(clockWork.raid, 5, clockWork.createDot("clockWork_raid5", 7, -1))
    table.insert(clockWork.raid, 6, clockWork.createDot("clockWork_raid6", 8, -1))
    table.insert(clockWork.raid, 7, clockWork.createDot("clockWork_raid7", 9, -1))
    table.insert(clockWork.raid, 8, clockWork.createDot("clockWork_raid8", 10, -1))
    table.insert(clockWork.raid, 9, clockWork.createDot("clockWork_raid9", 11, -1))
    table.insert(clockWork.raid, 10, clockWork.createDot("clockWork_raid10", 12, -1))

    table.insert(clockWork.raid, 11, clockWork.createDot("clockWork_raid11", 14, -3))
    table.insert(clockWork.raid, 12, clockWork.createDot("clockWork_raid12", 14, -4))
    table.insert(clockWork.raid, 13, clockWork.createDot("clockWork_raid13", 14, -5))
    table.insert(clockWork.raid, 14, clockWork.createDot("clockWork_raid14", 14, -6))
    table.insert(clockWork.raid, 15, clockWork.createDot("clockWork_raid15", 14, -7))
    table.insert(clockWork.raid, 16, clockWork.createDot("clockWork_raid16", 14, -8))
    table.insert(clockWork.raid, 17, clockWork.createDot("clockWork_raid17", 14, -9))
    table.insert(clockWork.raid, 18, clockWork.createDot("clockWork_raid18", 14, -10))
    table.insert(clockWork.raid, 19, clockWork.createDot("clockWork_raid19", 14, -11))
    table.insert(clockWork.raid, 20, clockWork.createDot("clockWork_raid20", 14, -12))

    table.insert(clockWork.raid, 21, clockWork.createDot("clockWork_raid21", 12, -1))
    table.insert(clockWork.raid, 22, clockWork.createDot("clockWork_raid22", 11, -1))
    table.insert(clockWork.raid, 23, clockWork.createDot("clockWork_raid23", 10, -1))
    table.insert(clockWork.raid, 24, clockWork.createDot("clockWork_raid24", 9, -1))
    table.insert(clockWork.raid, 25, clockWork.createDot("clockWork_raid25", 8, -1))
    table.insert(clockWork.raid, 26, clockWork.createDot("clockWork_raid26", 7, -1))
    table.insert(clockWork.raid, 27, clockWork.createDot("clockWork_raid27", 6, -1))
    table.insert(clockWork.raid, 28, clockWork.createDot("clockWork_raid28", 5, -1))
    table.insert(clockWork.raid, 29, clockWork.createDot("clockWork_raid29", 4, -1))
    table.insert(clockWork.raid, 30, clockWork.createDot("clockWork_raid30", 3, -1))

    table.insert(clockWork.raid, 31, clockWork.createDot("clockWork_raid31", 1, -12))
    table.insert(clockWork.raid, 32, clockWork.createDot("clockWork_raid32", 1, -11))
    table.insert(clockWork.raid, 33, clockWork.createDot("clockWork_raid33", 1, -10))
    table.insert(clockWork.raid, 34, clockWork.createDot("clockWork_raid34", 1, -9))
    table.insert(clockWork.raid, 35, clockWork.createDot("clockWork_raid35", 1, -8))
    table.insert(clockWork.raid, 36, clockWork.createDot("clockWork_raid36", 1, -7))
    table.insert(clockWork.raid, 37, clockWork.createDot("clockWork_raid37", 1, -6))
    table.insert(clockWork.raid, 38, clockWork.createDot("clockWork_raid38", 1, -5))
    table.insert(clockWork.raid, 39, clockWork.createDot("clockWork_raid39", 1, -4))
    table.insert(clockWork.raid, 40, clockWork.createDot("clockWork_raid40", 1, -3))

    clockWork.initKeys()
    clockWork.initCoords()
    clockWork.initLocalization()

    clockWork.resetCombat()

    clockWork.setAllBindings()
end

function clockWork.damageDone(arg1)

    --if (not clockWork.isPassiveDamage(arg1)) then
    clockWork.lastTimePlayerHit = time()
    clockWork.durationBeingHitWithoutRetaliating = clockWork.lastTimePlayerHasBeenHit - clockWork.lastTimePlayerHit
    --clockWork.printDebug("self : " .. tostring(clockWork.durationBeingHitWithoutRetaliating))
    --end
end

function clockWork.damageReceived(arg1)

    --        if UnitAffectingCombat("player") then
    clockWork.lastTimePlayerHasBeenHit = time()
    clockWork.durationBeingHitWithoutRetaliating = clockWork.lastTimePlayerHasBeenHit - clockWork.lastTimePlayerHit
    --clockWork.printDebug("creature : " .. tostring(clockWork.durationBeingHitWithoutRetaliating))
    --        end
end

local function onUpdate()

    -- clockWork.printDebug("local function onUpdate(")

    local now = GetTime()

    if (clockWork.nextUpdate < now) then

        if (C_Map.GetBestMapForUnit("player") == nil) then
            --clockWork.print("Player is nowhere to be found.")
            --return
        end

        --        clockWork.printDebug(clockWork.nextUpdate)

        if (clockWork.TOGGLE_ON_OFF and clockWork.ADDING_WP == false) then

            if (C_Map.GetBestMapForUnit("player") ~= nil) then
                clockWork.updatePositionCoordinates()
            end
            clockWork.rotation()
        end

        if clockWork.addWaypointList ~= nil and
                clockWork.ADDING_WP == false then

            --            clockWork.printDebug(tostring(clockWork.addWaypointList))
            --            clockWork.printDebug(tostring(clockWork.ADDING_WP))
            --            clockWork.printDebug(tostring(clockWork.waypointListIndex))

            local index = 0;
            local finished = true

            for coords in string.gfind(clockWork.addWaypointList, ".-;") do

                if index == clockWork.waypointListIndex then

                    finished = false
                    clockWork.print("Adding Waypoint : " .. coords)
                    clockWork.updatePositionFromCoordinates(coords)
                    clockWork.addWaypoint.texture:SetColorTexture(1, 1, 1, 1)
                    clockWork.ADDING_WP = true;
                end

                index = index + 1;
            end

            clockWork.waypointListIndex = clockWork.waypointListIndex + 1

            if (finished) then

                clockWork.addWaypointList = nil
                clockWork.waypointListIndex = 0
            end
        end

        clockWork.nextUpdate = now + clockWork.UPDATE_INTERVAL;
    end
end

local function onEvent(...)

    -- clockWork.printDebug("local function onEvent(")

    --clockWork.printDebug(event)

    --local numberOfArguments = select('#', ...)
    --clockWork.printDebug(numberOfArguments)

    --for index = 1, numberOfArguments do
    --    clockWork.printDebug(select(index, ...))
    --end

    --local frame = select(1, ...)
    local event = select(2, ...)
    --clockWork.printDebug(event)

    if event == nil then
        return
    else
        --clockWork.printDebug(event)
    end

    if (clockWork.playerGUID == nil) then
        clockWork.playerGUID = UnitGUID("player")
    end

    if event == "SPELLCAST_START" or event == "SPELLCAST_CHANNEL_START" then

        clockWork.CASTING = true
        clockWork.casting.texture:SetColorTexture(1, 1, 1, 1)

    elseif event == "SPELLCAST_STOP" or event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" then

        clockWork.CASTING = false
        clockWork.casting.texture:SetColorTexture(0, 0, 0, 1)
    end

    if event == "PLAYER_ENTERING_WORLD" then

        --clockWork.playerEnteringWorld()
        --return
    end

    if event == "ADDON_LOADED" then

        local addonName = select(3, ...)

        if addonName == "ClockWork" then

            clockWork.printDebug(select(3, ...) .. " Loaded")
            clockWork.playerEnteringWorld()
            clockWork.addonLoaded()
            clockWork.resetCombat()
            return
        end
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then

        --clockWork.printDebug("COMBAT_LOG_EVENT Values : ")

        local args = { CombatLogGetCurrentEventInfo() }
        --local numberOfArguments = select('#', args)

        --for i, value in pairs(args) do
        --    clockWork.printDebug(tostring (i) .. " = "  ..tostring(value))
        --end
        local subevent = args[2]
        --clockWork.printDebug("subevent = " .. tostring(subevent))
        local sourceGUID = args[4]
        --clockWork.printDebug("sourceGUID = " .. tostring(sourceGUID))
        local destGUID = args[8]
        --clockWork.printDebug("destGUID   = " .. tostring(destGUID))

        local amount
        if subevent == "SWING_DAMAGE" then
            amount = args[12]
        elseif subevent == "SPELL_DAMAGE" then
            amount = args[15]
        end

        if (clockWork.playerGUID == sourceGUID) then
            clockWork.damageDone()
        end

        if (clockWork.playerGUID == destGUID) then
            clockWork.damageReceived()
        end
    end

    if (clockWork.durationBeingHitWithoutRetaliating > 6) and not (event == "PLAYER_DEAD") then
        -- Si vivant && pas tapé depuis 6 secondes
        clockWork.stepBack.texture:SetColorTexture(1, 1, 1, 1)
    else
        clockWork.stepBack.texture:SetColorTexture(0, 0, 0, 1)
    end
end

clockWork.frame = CreateFrame("FRAME", "clockWork_MainFrame", UIParent)
clockWork.frame:SetPoint("TOPLEFT", 0, 0)
clockWork.frame:SetFrameStrata("MEDIUM")

clockWork.frame:SetScript("OnEvent", onEvent);
clockWork.frame:SetScript("OnUpdate", onUpdate);

clockWork.frame:RegisterEvent("PLAYER_ENTERING_WORLD");

clockWork.frame:RegisterEvent("UNIT_SPELLCAST_START")
clockWork.frame:RegisterEvent("UNIT_SPELLCAST_STOP")
clockWork.frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
clockWork.frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
clockWork.frame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
clockWork.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
clockWork.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
clockWork.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

clockWork.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--clockWork.frame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
--clockWork.frame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
--clockWork.frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
--clockWork.frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
--clockWork.frame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
--clockWork.frame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
--clockWork.frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
--clockWork.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
--clockWork.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
--clockWork.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")

clockWork.frame:RegisterEvent("ADDON_LOADED")

clockWork.frame:RegisterEvent("PLAYER_DEAD")

clockWork.frame.texture = clockWork.frame:CreateTexture("MEDIUM")
clockWork.frame.texture:SetAllPoints()
clockWork.frame.texture:SetColorTexture(0, 1, 0, 1)
