--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 17/02/2017
-- Time: 13:51
-- To change this template use File | Settings | File Templates.
--

function Clockwork.addonLoaded()

    if Clockwork_ROTATIONS == nil then
        Clockwork_ROTATIONS = {};
    end
end

function Clockwork.playerEnteringWorld()

    -- init Frames

    Clockwork.frame:SetWidth(16)
    Clockwork.frame:SetHeight(16)

    Clockwork.nextUpdate = 0
    Clockwork.addWaypointList = nil
    Clockwork.waypointListIndex = 0

    Clockwork.blackBackground3 = CreateFrame("FRAME", "clockWork_Background3", Clockwork.frame)
    Clockwork.blackBackground3:SetPoint("CENTER", 0, 0)
    Clockwork.blackBackground3:SetWidth(14)
    Clockwork.blackBackground3:SetHeight(14)
    Clockwork.blackBackground3:SetFrameStrata("MEDIUM");
    Clockwork.blackBackground3.texture = Clockwork.blackBackground3:CreateTexture(nil, "BACKGROUND")
    Clockwork.blackBackground3.texture:SetAllPoints()
    Clockwork.blackBackground3.texture:SetColorTexture(0, 0, 0, 1)

    Clockwork.blackBackground1 = CreateFrame("FRAME", "clockWork_Background1", Clockwork.frame)
    Clockwork.blackBackground1:SetPoint("CENTER", 0, 0)
    Clockwork.blackBackground1:SetSize(16, 8)
    Clockwork.blackBackground1:SetFrameStrata("MEDIUM");
    Clockwork.blackBackground1.texture = Clockwork.blackBackground1:CreateTexture(nil, "ARTWORK")
    Clockwork.blackBackground1.texture:SetAllPoints()
    Clockwork.blackBackground1.texture:SetColorTexture(0, 0, 0, 1)

    Clockwork.blackBackground2 = CreateFrame("FRAME", "clockWork_Background2", Clockwork.frame)
    Clockwork.blackBackground2:SetPoint("CENTER", 0, 0)
    Clockwork.blackBackground2:SetWidth(8)
    Clockwork.blackBackground2:SetHeight(16)
    Clockwork.blackBackground2:SetFrameStrata("MEDIUM");
    Clockwork.blackBackground2.texture = Clockwork.blackBackground2:CreateTexture(nil, "ARTWORK")
    Clockwork.blackBackground2.texture:SetAllPoints()
    Clockwork.blackBackground2.texture:SetColorTexture(0, 0, 0, 1)

    Clockwork.onOff = CreateFrame("FRAME", "clockWork_onOff", Clockwork.frame)
    Clockwork.onOff:SetPoint("CENTER", 0, 0)
    Clockwork.onOff:SetWidth(16)
    Clockwork.onOff:SetHeight(16)
    Clockwork.onOff:SetFrameStrata("DIALOG")
    Clockwork.onOff.texture = Clockwork.onOff:CreateTexture("DIALOG")
    Clockwork.onOff.texture:SetAllPoints()
    Clockwork.onOff.texture:SetColorTexture(0, 1, 0, 1)

    Clockwork.inCombat = Clockwork.createDot("clockWork_inCombat", 2, -2)
    Clockwork.casting = Clockwork.createDot("clockWork_casting", 3, -2)
    Clockwork.notRetaliating = Clockwork.createDot("clockWork_stepBack", 4, -2)

    Clockwork.playerHealth = Clockwork.createDot("clockWork_health", 12, -2)
    Clockwork.playerMana = Clockwork.createDot("clockWork_mana", 13, -2)
    Clockwork.numberOfTargets = Clockwork.createDot("clockWork_number_of_targets", 2, -3)
    Clockwork.targets.count = 0
    Clockwork.targetReaction = Clockwork.createDot("clockWork_target_reaction", 11, -3)
    Clockwork.targetHealth = Clockwork.createDot("clockWork_target_health", 12, -3)
    Clockwork.targetMana = Clockwork.createDot("clockWork_target_mana", 13, -3)

    Clockwork.toggle = Clockwork.createDot("clockWork_toggle", 2, -13)
    Clockwork.targetNearestEnemy = Clockwork.createDot("clockWork_targetNearestEnemy", 3, -13)
    Clockwork.addWaypoint = Clockwork.createDot("clockWork_addWaypoint", 4, -13)
    Clockwork.clearWaypoints = Clockwork.createDot("clockWork_clearWaypoints", 5, -13)
    Clockwork.drive = Clockwork.createDot("clockWork_drive", 6, -13)
    Clockwork.driveLoop = Clockwork.createDot("clockWork_driveLoop", 7, -13)
    Clockwork.debug = Clockwork.createDot("clockWork_debug", 13, -13)
    if Clockwork.DEBUG_MOD then
        Clockwork.debug.texture:SetColorTexture(1, 0, 0, 1)
    end

    Clockwork.raid = {}

    table.insert(Clockwork.raid, 1, Clockwork.createDot("clockWork_raid1", 3, -1))
    table.insert(Clockwork.raid, 2, Clockwork.createDot("clockWork_raid2", 4, -1))
    table.insert(Clockwork.raid, 3, Clockwork.createDot("clockWork_raid3", 5, -1))
    table.insert(Clockwork.raid, 4, Clockwork.createDot("clockWork_raid4", 6, -1))
    table.insert(Clockwork.raid, 5, Clockwork.createDot("clockWork_raid5", 7, -1))
    table.insert(Clockwork.raid, 6, Clockwork.createDot("clockWork_raid6", 8, -1))
    table.insert(Clockwork.raid, 7, Clockwork.createDot("clockWork_raid7", 9, -1))
    table.insert(Clockwork.raid, 8, Clockwork.createDot("clockWork_raid8", 10, -1))
    table.insert(Clockwork.raid, 9, Clockwork.createDot("clockWork_raid9", 11, -1))
    table.insert(Clockwork.raid, 10, Clockwork.createDot("clockWork_raid10", 12, -1))

    table.insert(Clockwork.raid, 11, Clockwork.createDot("clockWork_raid11", 14, -3))
    table.insert(Clockwork.raid, 12, Clockwork.createDot("clockWork_raid12", 14, -4))
    table.insert(Clockwork.raid, 13, Clockwork.createDot("clockWork_raid13", 14, -5))
    table.insert(Clockwork.raid, 14, Clockwork.createDot("clockWork_raid14", 14, -6))
    table.insert(Clockwork.raid, 15, Clockwork.createDot("clockWork_raid15", 14, -7))
    table.insert(Clockwork.raid, 16, Clockwork.createDot("clockWork_raid16", 14, -8))
    table.insert(Clockwork.raid, 17, Clockwork.createDot("clockWork_raid17", 14, -9))
    table.insert(Clockwork.raid, 18, Clockwork.createDot("clockWork_raid18", 14, -10))
    table.insert(Clockwork.raid, 19, Clockwork.createDot("clockWork_raid19", 14, -11))
    table.insert(Clockwork.raid, 20, Clockwork.createDot("clockWork_raid20", 14, -12))

    table.insert(Clockwork.raid, 21, Clockwork.createDot("clockWork_raid21", 12, -1))
    table.insert(Clockwork.raid, 22, Clockwork.createDot("clockWork_raid22", 11, -1))
    table.insert(Clockwork.raid, 23, Clockwork.createDot("clockWork_raid23", 10, -1))
    table.insert(Clockwork.raid, 24, Clockwork.createDot("clockWork_raid24", 9, -1))
    table.insert(Clockwork.raid, 25, Clockwork.createDot("clockWork_raid25", 8, -1))
    table.insert(Clockwork.raid, 26, Clockwork.createDot("clockWork_raid26", 7, -1))
    table.insert(Clockwork.raid, 27, Clockwork.createDot("clockWork_raid27", 6, -1))
    table.insert(Clockwork.raid, 28, Clockwork.createDot("clockWork_raid28", 5, -1))
    table.insert(Clockwork.raid, 29, Clockwork.createDot("clockWork_raid29", 4, -1))
    table.insert(Clockwork.raid, 30, Clockwork.createDot("clockWork_raid30", 3, -1))

    table.insert(Clockwork.raid, 31, Clockwork.createDot("clockWork_raid31", 1, -12))
    table.insert(Clockwork.raid, 32, Clockwork.createDot("clockWork_raid32", 1, -11))
    table.insert(Clockwork.raid, 33, Clockwork.createDot("clockWork_raid33", 1, -10))
    table.insert(Clockwork.raid, 34, Clockwork.createDot("clockWork_raid34", 1, -9))
    table.insert(Clockwork.raid, 35, Clockwork.createDot("clockWork_raid35", 1, -8))
    table.insert(Clockwork.raid, 36, Clockwork.createDot("clockWork_raid36", 1, -7))
    table.insert(Clockwork.raid, 37, Clockwork.createDot("clockWork_raid37", 1, -6))
    table.insert(Clockwork.raid, 38, Clockwork.createDot("clockWork_raid38", 1, -5))
    table.insert(Clockwork.raid, 39, Clockwork.createDot("clockWork_raid39", 1, -4))
    table.insert(Clockwork.raid, 40, Clockwork.createDot("clockWork_raid40", 1, -3))

    Clockwork.initKeys()
    Clockwork.initCoords()
    Clockwork.initLocalization()

    Clockwork.resetCombat()

    Clockwork.setAllBindings()
end

function Clockwork.damageDone(arg1)

    --if (not Clockwork.isPassiveDamage(arg1)) then
    Clockwork.lastTimePlayerHit = time()
    Clockwork.durationBeingHitWithoutRetaliating = Clockwork.lastTimePlayerHasBeenHit - Clockwork.lastTimePlayerHit
    --Clockwork.log.debug("self : " .. tostring(Clockwork.durationBeingHitWithoutRetaliating))
    --end
end

function Clockwork.damageReceived(arg1)

    --        if UnitAffectingCombat("player") then
    Clockwork.lastTimePlayerHasBeenHit = time()
    Clockwork.durationBeingHitWithoutRetaliating = Clockwork.lastTimePlayerHasBeenHit - Clockwork.lastTimePlayerHit
    --Clockwork.log.debug("creature : " .. tostring(Clockwork.durationBeingHitWithoutRetaliating))
    --        end
end

local function onUpdate()

    -- Clockwork.log.debug("local function onUpdate(")

    local now = GetTime()

    if (Clockwork.nextUpdate < now) then

        if (C_Map.GetBestMapForUnit("player") == nil) then
            Clockwork.log.debug("Player is nowhere to be found.")
            --return
        end

        --        Clockwork.log.debug(Clockwork.nextUpdate)

        if (Clockwork.TOGGLE_ON_OFF and Clockwork.ADDING_WP == false) then

            if (C_Map.GetBestMapForUnit("player") ~= nil) then
                Clockwork.updatePositionCoordinates()
            end
            Clockwork.rotation()
        end

        if Clockwork.addWaypointList ~= nil and
                Clockwork.ADDING_WP == false then

            --            Clockwork.log.debug(tostring(Clockwork.addWaypointList))
            --            Clockwork.log.debug(tostring(Clockwork.ADDING_WP))
            --            Clockwork.log.debug(tostring(Clockwork.waypointListIndex))

            local index = 0;
            local finished = true

            for coords in string.gmatch(Clockwork.addWaypointList, ".-;") do

                if index == Clockwork.waypointListIndex then

                    finished = false
                    Clockwork.log.notice("Adding Waypoint : " .. coords)
                    Clockwork.updatePositionFromCoordinates(coords)
                    Clockwork.addWaypoint.texture:SetColorTexture(1, 1, 1, 1)
                    Clockwork.ADDING_WP = true;
                end

                index = index + 1;
            end

            Clockwork.waypointListIndex = Clockwork.waypointListIndex + 1

            if (finished) then

                Clockwork.addWaypointList = nil
                Clockwork.waypointListIndex = 0
            end
        end

        Clockwork.nextUpdate = now + Clockwork.UPDATE_INTERVAL;
    end
end

local function onEvent(...)

    -- Clockwork.log.debug("local function onEvent(")

    --Clockwork.log.debug(event)

    --local numberOfArguments = select('#', ...)
    --Clockwork.log.debug(numberOfArguments)

    --for index = 1, numberOfArguments do
    --    Clockwork.log.debug(select(index, ...))
    --end

    --local frame = select(1, ...)
    local event = select(2, ...)
    --Clockwork.log.debug(event)

    if event == nil then
        return
    else
        --Clockwork.log.debug(event)
    end

    if (Clockwork.player.GUID == nil) then
        Clockwork.player.GUID = UnitGUID("player")
    end

    if (Clockwork.pet.GUID == nil) then
        if (UnitExists("pet")) then
            Clockwork.pet.GUID = UnitGUID("pet")
        end
    else
        if (not UnitExists("pet")) then
            Clockwork.pet.GUID = nil
        end
    end

    if event == "SPELLCAST_START" or event == "SPELLCAST_CHANNEL_START" then

        Clockwork.CASTING = true
        Clockwork.casting.texture:SetColorTexture(1, 1, 1, 1)

    elseif event == "SPELLCAST_STOP" or event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" then

        Clockwork.CASTING = false
        Clockwork.casting.texture:SetColorTexture(0, 0, 0, 1)
    end

    if event == "PLAYER_ENTERING_WORLD" then

        --Clockwork.playerEnteringWorld()
        --return
    end

    if event == "ADDON_LOADED" then

        local addonName = select(3, ...)

        if addonName == "Clockwork" then

            Clockwork.log.debug(select(3, ...) .. " Loaded")
            Clockwork.playerEnteringWorld()
            Clockwork.addonLoaded()
            Clockwork.resetCombat()
            return
        end
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then

        --Clockwork.log.debug("COMBAT_LOG_EVENT Values : ")

        local args = { CombatLogGetCurrentEventInfo() }
        --local numberOfArguments = select('#', args)

        --for i, value in pairs(args) do
        --    Clockwork.log.debug(tostring (i) .. " = "  ..tostring(value))
        --end
        local subevent = args[2]
        --Clockwork.log.debug("subevent = " .. tostring(subevent))
        local sourceGUID = args[4]
        local sourceName = args[5]
        --Clockwork.log.debug("sourceGUID = " .. tostring(sourceGUID))
        local destGUID = args[8]
        local destName = args[9]

        --string.find(sourceGUID, "Pet") == true or
        if (sourceGUID == Clockwork.player.GUID or sourceGUID == Clockwork.pet.GUID)
                and destGUID ~= Clockwork.pet.GUID
                and destGUID ~= Clockwork.player.GUID
                and not Clockwork.emptyOrNil(destGUID)
        then

            if Clockwork.targets.list[tostring(destGUID)] == nil then
                --Clockwork.log.debug("Unit added")
                --Clockwork.log.debug(tostring(subevent) .. "," .. tostring(sourceGUID) .. ", " .. tostring(sourceName) .. ", " .. tostring(destGUID) .. ", " .. tostring(destName))

            else
                --Clockwork.log.debug("Unit updated")
            end

            Clockwork.targets.list[tostring(destGUID)] = GetTime()
            Clockwork.updateNumberOfTargets()
        end

        local amount
        if subevent == "SWING_DAMAGE" then
            amount = args[12]
        elseif subevent == "SPELL_DAMAGE" then
            amount = args[15]
        end

        --if (sourceGUID ~= Clockwork.player.GUID and string.find(sourceGUID, "Pet") == false) then

        if subevent == "UNIT_DIED" or
                subevent == "UNIT_DESTROYED" or
                subevent == "SPELL_INSTAKILL" or
                --subevent == "PARTY_KILL" or 
                subevent == "UNIT_DISSIPATES" then

            --Clockwork.log.debug(tostring(subevent) .. "," .. tostring(destGUID) .. " = " .. tostring(destName))

            if Clockwork.targets.list[tostring(destGUID)] ~= nil then

                Clockwork.targets.list[tostring(destGUID)] = nil
                --Clockwork.log.debug("Unit removed")
                Clockwork.updateNumberOfTargets()
            end
        end
        --end

        if (Clockwork.player.GUID == sourceGUID) then
            Clockwork.damageDone()
        end

        if (Clockwork.player.GUID == destGUID) then
            Clockwork.damageReceived()
        end
    end

    if (Clockwork.durationBeingHitWithoutRetaliating > 6) and not (event == "PLAYER_DEAD") then
        -- Si vivant && pas tapé depuis 6 secondes
        Clockwork.notRetaliating.texture:SetColorTexture(1, 1, 1, 1)
    else
        Clockwork.notRetaliating.texture:SetColorTexture(0, 0, 0, 1)
    end
end

function Clockwork.updateNumberOfTargets()

    if Clockwork.targets.list ~= nil then
        for i, time in pairs(Clockwork.targets.list) do
            if (GetTime() - time > 5) then
                Clockwork.targets.list[i] = nil
            end
        end
        Clockwork.log.debug(tostring(Clockwork.tableLength(Clockwork.targets.list)))
        Clockwork.log.debug(tostring(Clockwork.tableLength(Clockwork.targets.list) / 255))
        Clockwork.targets.count = Clockwork.tableLength(Clockwork.targets.list)
        Clockwork.numberOfTargets.texture:SetColorTexture(Clockwork.targets.count / 255, 0, 0, 1)
    else
        Clockwork.targets.count = 0
        Clockwork.numberOfTargets.texture:SetColorTexture(0, 0, 0, 1)
    end

    multiTarget = Clockwork.targets.count >= Clockwork.targets.multiTargetModTrigger

    if (Clockwork.targets.multiTargetMod ~= multiTarget) then
        Clockwork.log.debug(Clockwork.ternary(multiTarget, "Multi targets mod", "Single target mod"))
    end

    Clockwork.targets.multiTargetMod = multiTarget
end

Clockwork.frame = CreateFrame("FRAME", "clockWork_MainFrame", UIParent)
Clockwork.frame:SetPoint("TOPLEFT", 0, 0)
Clockwork.frame:SetFrameStrata("MEDIUM")

Clockwork.frame:SetScript("OnEvent", onEvent);
Clockwork.frame:SetScript("OnUpdate", onUpdate);

Clockwork.frame:RegisterEvent("PLAYER_ENTERING_WORLD");

Clockwork.frame:RegisterEvent("UNIT_SPELLCAST_START")
Clockwork.frame:RegisterEvent("UNIT_SPELLCAST_STOP")
Clockwork.frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
Clockwork.frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
Clockwork.frame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
Clockwork.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
Clockwork.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
Clockwork.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

Clockwork.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--Clockwork.frame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
--Clockwork.frame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
--Clockwork.frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
--Clockwork.frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
--Clockwork.frame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
--Clockwork.frame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
--Clockwork.frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
--Clockwork.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
--Clockwork.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
--Clockwork.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")

Clockwork.frame:RegisterEvent("ADDON_LOADED")

Clockwork.frame:RegisterEvent("PLAYER_DEAD")

Clockwork.frame.texture = Clockwork.frame:CreateTexture("MEDIUM")
Clockwork.frame.texture:SetAllPoints()
Clockwork.frame.texture:SetColorTexture(0, 1, 0, 1)
