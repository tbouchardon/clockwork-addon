--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 17/02/2017
-- Time: 13:51
-- To change this template use File | Settings | File Templates.
--

function ksuto.playerEnteringWorld()

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
    ksuto.casting = ksuto.createDot("ksuto_casting", 3, -2)
    ksuto.stepBack = ksuto.createDot("ksuto_stepBack", 4, -2)

    ksuto.playerHealth = ksuto.createDot("ksuto_health", 12, -2)
    ksuto.playerMana = ksuto.createDot("ksuto_mana", 13, -2)
    ksuto.targetReaction = ksuto.createDot("ksuto_target_reaction", 11, -3)
    ksuto.targetHealth = ksuto.createDot("ksuto_target_health", 12, -3)
    ksuto.targetMana = ksuto.createDot("ksuto_target_mana", 13, -3)

    ksuto.toggle = ksuto.createDot("ksuto_toggle", 2, -13)
    ksuto.targetNearestEnemy = ksuto.createDot("ksuto_targetNearestEnemy", 3, -13)
    ksuto.addWaypoint = ksuto.createDot("ksuto_addWaypoint", 4, -13)
    ksuto.clearWaypoints = ksuto.createDot("ksuto_clearWaypoints", 5, -13)
    ksuto.drive = ksuto.createDot("ksuto_drive", 6, -13)
    ksuto.driveLoop = ksuto.createDot("ksuto_driveLoop", 7, -13)
    ksuto.debug = ksuto.createDot("ksuto_debug", 13, -13)
    if ksuto.DEBUG_MOD then ksuto.debug.texture:SetTexture(1, 0, 0, 1) end

    ksuto.raid = {}

    table.insert(ksuto.raid, 1, ksuto.createDot("ksuto_raid1", 3, -1))
    table.insert(ksuto.raid, 2, ksuto.createDot("ksuto_raid2", 4, -1))
    table.insert(ksuto.raid, 3, ksuto.createDot("ksuto_raid3", 5, -1))
    table.insert(ksuto.raid, 4, ksuto.createDot("ksuto_raid4", 6, -1))
    table.insert(ksuto.raid, 5, ksuto.createDot("ksuto_raid5", 7, -1))
    table.insert(ksuto.raid, 6, ksuto.createDot("ksuto_raid6", 8, -1))
    table.insert(ksuto.raid, 7, ksuto.createDot("ksuto_raid7", 9, -1))
    table.insert(ksuto.raid, 8, ksuto.createDot("ksuto_raid8", 10, -1))
    table.insert(ksuto.raid, 9, ksuto.createDot("ksuto_raid9", 11, -1))
    table.insert(ksuto.raid, 10, ksuto.createDot("ksuto_raid10", 12, -1))

    table.insert(ksuto.raid, 11, ksuto.createDot("ksuto_raid11", 14, -3))
    table.insert(ksuto.raid, 12, ksuto.createDot("ksuto_raid12", 14, -4))
    table.insert(ksuto.raid, 13, ksuto.createDot("ksuto_raid13", 14, -5))
    table.insert(ksuto.raid, 14, ksuto.createDot("ksuto_raid14", 14, -6))
    table.insert(ksuto.raid, 15, ksuto.createDot("ksuto_raid15", 14, -7))
    table.insert(ksuto.raid, 16, ksuto.createDot("ksuto_raid16", 14, -8))
    table.insert(ksuto.raid, 17, ksuto.createDot("ksuto_raid17", 14, -9))
    table.insert(ksuto.raid, 18, ksuto.createDot("ksuto_raid18", 14, -10))
    table.insert(ksuto.raid, 19, ksuto.createDot("ksuto_raid19", 14, -11))
    table.insert(ksuto.raid, 20, ksuto.createDot("ksuto_raid20", 14, -12))

    table.insert(ksuto.raid, 21, ksuto.createDot("ksuto_raid21", 12, -1))
    table.insert(ksuto.raid, 22, ksuto.createDot("ksuto_raid22", 11, -1))
    table.insert(ksuto.raid, 23, ksuto.createDot("ksuto_raid23", 10, -1))
    table.insert(ksuto.raid, 24, ksuto.createDot("ksuto_raid24", 9, -1))
    table.insert(ksuto.raid, 25, ksuto.createDot("ksuto_raid25", 8, -1))
    table.insert(ksuto.raid, 26, ksuto.createDot("ksuto_raid26", 7, -1))
    table.insert(ksuto.raid, 27, ksuto.createDot("ksuto_raid27", 6, -1))
    table.insert(ksuto.raid, 28, ksuto.createDot("ksuto_raid28", 5, -1))
    table.insert(ksuto.raid, 29, ksuto.createDot("ksuto_raid29", 4, -1))
    table.insert(ksuto.raid, 30, ksuto.createDot("ksuto_raid30", 3, -1))

    table.insert(ksuto.raid, 31, ksuto.createDot("ksuto_raid31", 1, -12))
    table.insert(ksuto.raid, 32, ksuto.createDot("ksuto_raid32", 1, -11))
    table.insert(ksuto.raid, 33, ksuto.createDot("ksuto_raid33", 1, -10))
    table.insert(ksuto.raid, 34, ksuto.createDot("ksuto_raid34", 1, -9))
    table.insert(ksuto.raid, 35, ksuto.createDot("ksuto_raid35", 1, -8))
    table.insert(ksuto.raid, 36, ksuto.createDot("ksuto_raid36", 1, -7))
    table.insert(ksuto.raid, 37, ksuto.createDot("ksuto_raid37", 1, -6))
    table.insert(ksuto.raid, 38, ksuto.createDot("ksuto_raid38", 1, -5))
    table.insert(ksuto.raid, 39, ksuto.createDot("ksuto_raid39", 1, -4))
    table.insert(ksuto.raid, 40, ksuto.createDot("ksuto_raid40", 1, -3))

    ksuto.initKeys()
    ksuto.initCoords()
    ksuto.initLocalization()

    ksuto.resetCombat()
end

function ksuto.damageDone(arg1)

    if (not ksuto.isPassiveDamage(arg1)) then
        ksuto.selfHit = time()
        ksuto.deltaSelfHitCreatureHit = ksuto.creatureHit - ksuto.selfHit
        ksuto.printDebug("self : " .. tostring(ksuto.deltaSelfHitCreatureHit))
    end
end

function ksuto.damageReceived(arg1)

    --        if UnitAffectingCombat("player") then
    ksuto.creatureHit = time()
    ksuto.deltaSelfHitCreatureHit = ksuto.creatureHit - ksuto.selfHit
    ksuto.printDebug("creature : " .. tostring(ksuto.deltaSelfHitCreatureHit))
    --        end
end

local function onUpdate()

    -- ksuto.printDebug("local function onUpdate(")

    local now = GetTime()

    if (ksuto.nextUpdate < now) then

        --        ksuto.printDebug(ksuto.nextUpdate)

        if (ksuto.TOGGLE_ON_OFF and ksuto.ADDING_WP == false) then

            ksuto.updatePositionCoordinates()
            ksuto.rotation()
        end

        if ksuto.addWaypointList ~= nil and
                ksuto.ADDING_WP == false then

            --            ksuto.printDebug(tostring(ksuto.addWaypointList))
            --            ksuto.printDebug(tostring(ksuto.ADDING_WP))
            --            ksuto.printDebug(tostring(ksuto.waypointListIndex))

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

            ksuto.waypointListIndex = ksuto.waypointListIndex + 1

            if (finished) then

                ksuto.addWaypointList = nil
                ksuto.waypointListIndex = 0
            end
        end

        ksuto.nextUpdate = now + ksuto.UPDATE_INTERVAL;
    end
end

local function onEvent()

    -- ksuto.printDebug("local function onEvent(")

    ksuto.printDebug("event = " .. event)

    -- if (arg1) then ksuto.printDebug("arg1 = " .. arg1) end
    -- if (arg2) then ksuto.printDebug("arg2 = " .. arg2) end
    -- if (arg3) then ksuto.printDebug("arg3 = " .. arg3) end
    -- if (arg4) then ksuto.printDebug("arg4 = " .. arg4) end
    -- if (arg5) then ksuto.printDebug("arg5 = " .. arg5) end
    -- if (arg6) then ksuto.printDebug("arg6 = " .. arg6) end
    -- if (arg7) then ksuto.printDebug("arg7 = " .. arg7) end
    -- if (arg8) then ksuto.printDebug("arg8 = " .. arg8) end
    -- if (arg9) then ksuto.printDebug("arg9 = " .. arg9) end

    if event == "SPELLCAST_START" or event == "SPELLCAST_CHANNEL_START" then

        ksuto.CASTING = true
        ksuto.casting.texture:SetTexture(1, 1, 1, 1)

    elseif event == "SPELLCAST_STOP" or event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" then

        ksuto.CASTING = false
        ksuto.casting.texture:SetTexture(0, 0, 0, 1)
    end

    if event == "PLAYER_ENTERING_WORLD" then

        ksuto.playerEnteringWorld()
    end

    if event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS"
            or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS"
            or event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"
            or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE"
            or event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"
            or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" then

        ksuto.damageReceived()
    end

    if event == "CHAT_MSG_COMBAT_SELF_HITS"
            or event == "CHAT_MSG_COMBAT_SELF_MISSES"
            or event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        --            or event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"

        ksuto.damageDone(arg1)
    end

    if (ksuto.deltaSelfHitCreatureHit > 6) and (not event == "PLAYER_DEAD") then -- Si vivant && pas tapé depuis 6 secondes
        ksuto.stepBack.texture:SetTexture(1, 1, 1, 1)
    else
        ksuto.stepBack.texture:SetTexture(0, 0, 0, 1)
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

ksuto.frame:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
ksuto.frame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
ksuto.frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
ksuto.frame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
ksuto.frame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
ksuto.frame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
ksuto.frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
ksuto.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
ksuto.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
ksuto.frame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")

ksuto.frame:RegisterEvent("PLAYER_DEAD")

ksuto.frame.texture = ksuto.frame:CreateTexture("MEDIUM")
ksuto.frame.texture:SetAllPoints()
ksuto.frame.texture:SetTexture(0, 1, 0, 1)

local btn = CreateFrame("BUTTON", "MyBindingHandlingButton")
SetBinding("ALT-CTRL-T", "CLICK " .. btn:GetName())
btn:SetScript("OnClick", function(self, button, down)
    print("You triggered the binding using", button)
end)