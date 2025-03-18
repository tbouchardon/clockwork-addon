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

function Clockwork:playerEnteringWorld()
    -- init Frames

    self.frame:SetWidth(16)
    self.frame:SetHeight(16)

    self.nextUpdate = 0
    self.addWaypointList = nil
    self.waypointListIndex = 0

    self.blackBackground3 = CreateFrame("FRAME", "clockWork_Background3", self.frame)
    self.blackBackground3:SetPoint("CENTER", 0, 0)
    self.blackBackground3:SetWidth(14)
    self.blackBackground3:SetHeight(14)
    self.blackBackground3:SetFrameStrata("MEDIUM");
    self.blackBackground3.texture = self.blackBackground3:CreateTexture(nil, "BACKGROUND")
    self.blackBackground3.texture:SetAllPoints()
    self.blackBackground3.texture:SetColorTexture(0, 0, 0, 1)

    self.blackBackground1 = CreateFrame("FRAME", "clockWork_Background1", self.frame)
    self.blackBackground1:SetPoint("CENTER", 0, 0)
    self.blackBackground1:SetSize(16, 8)
    self.blackBackground1:SetFrameStrata("MEDIUM");
    self.blackBackground1.texture = self.blackBackground1:CreateTexture(nil, "ARTWORK")
    self.blackBackground1.texture:SetAllPoints()
    self.blackBackground1.texture:SetColorTexture(0, 0, 0, 1)

    self.blackBackground2 = CreateFrame("FRAME", "clockWork_Background2", self.frame)
    self.blackBackground2:SetPoint("CENTER", 0, 0)
    self.blackBackground2:SetWidth(8)
    self.blackBackground2:SetHeight(16)
    self.blackBackground2:SetFrameStrata("MEDIUM");
    self.blackBackground2.texture = self.blackBackground2:CreateTexture(nil, "ARTWORK")
    self.blackBackground2.texture:SetAllPoints()
    self.blackBackground2.texture:SetColorTexture(0, 0, 0, 1)

    self.onOff = CreateFrame("FRAME", "clockWork_onOff", self.frame)
    self.onOff:SetPoint("CENTER", 0, 0)
    self.onOff:SetWidth(16)
    self.onOff:SetHeight(16)
    self.onOff:SetFrameStrata("DIALOG")
    self.onOff.texture = self.onOff:CreateTexture("DIALOG")
    self.onOff.texture:SetAllPoints()
    self.onOff.texture:SetColorTexture(0, 1, 0, 1)

    self.inCombat = self:createDot("clockWork_inCombat", 2, -2)
    self.casting = self:createDot("clockWork_casting", 3, -2)
    self.notRetaliating = self:createDot("clockWork_notRetaliating", 4, -2)

    self.playerHealth = self:createDot("clockWork_health", 12, -2)
    self.playerMana = self:createDot("clockWork_mana", 13, -2)
    self.numberOfTargets = self:createDot("clockWork_numberOfTargets", 2, -3)
    self.targets.count = 0
    self.targetReaction = self:createDot("clockWork_target_reaction", 11, -3)
    self.targetHealth = self:createDot("clockWork_target_health", 12, -3)
    self.targetMana = self:createDot("clockWork_target_mana", 13, -3)

    self.toggle = self:createDot("clockWork_toggle", 2, -13)
    self.targetNearestEnemy = self:createDot("clockWork_targetNearestEnemy", 3, -13)
    self.addWaypoint = self:createDot("clockWork_addWaypoint", 4, -13)
    self.clearWaypoints = self:createDot("clockWork_clearWaypoints", 5, -13)
    self.drive = self:createDot("clockWork_drive", 6, -13)
    self.driveLoop = self:createDot("clockWork_driveLoop", 7, -13)
    self.debug = self:createDot("clockWork_debug", 13, -13)
    if Clockwork.DEBUG_MOD then
        self.debug.texture:SetColorTexture(1, 0, 0, 1)
    end

    self.raid = {}

    table.insert(self.raid, 1, self:createDot("clockWork_raid1", 3, -1))
    table.insert(self.raid, 2, self:createDot("clockWork_raid2", 4, -1))
    table.insert(self.raid, 3, self:createDot("clockWork_raid3", 5, -1))
    table.insert(self.raid, 4, self:createDot("clockWork_raid4", 6, -1))
    table.insert(self.raid, 5, self:createDot("clockWork_raid5", 7, -1))
    table.insert(self.raid, 6, self:createDot("clockWork_raid6", 8, -1))
    table.insert(self.raid, 7, self:createDot("clockWork_raid7", 9, -1))
    table.insert(self.raid, 8, self:createDot("clockWork_raid8", 10, -1))
    table.insert(self.raid, 9, self:createDot("clockWork_raid9", 11, -1))
    table.insert(self.raid, 10, self:createDot("clockWork_raid10", 12, -1))

    table.insert(self.raid, 11, self:createDot("clockWork_raid11", 14, -3))
    table.insert(self.raid, 12, self:createDot("clockWork_raid12", 14, -4))
    table.insert(self.raid, 13, self:createDot("clockWork_raid13", 14, -5))
    table.insert(self.raid, 14, self:createDot("clockWork_raid14", 14, -6))
    table.insert(self.raid, 15, self:createDot("clockWork_raid15", 14, -7))
    table.insert(self.raid, 16, self:createDot("clockWork_raid16", 14, -8))
    table.insert(self.raid, 17, self:createDot("clockWork_raid17", 14, -9))
    table.insert(self.raid, 18, self:createDot("clockWork_raid18", 14, -10))
    table.insert(self.raid, 19, self:createDot("clockWork_raid19", 14, -11))
    table.insert(self.raid, 20, self:createDot("clockWork_raid20", 14, -12))

    table.insert(self.raid, 21, self:createDot("clockWork_raid21", 12, -1))
    table.insert(self.raid, 22, self:createDot("clockWork_raid22", 11, -1))
    table.insert(self.raid, 23, self:createDot("clockWork_raid23", 10, -1))
    table.insert(self.raid, 24, self:createDot("clockWork_raid24", 9, -1))
    table.insert(self.raid, 25, self:createDot("clockWork_raid25", 8, -1))
    table.insert(self.raid, 26, self:createDot("clockWork_raid26", 7, -1))
    table.insert(self.raid, 27, self:createDot("clockWork_raid27", 6, -1))
    table.insert(self.raid, 28, self:createDot("clockWork_raid28", 5, -1))
    table.insert(self.raid, 29, self:createDot("clockWork_raid29", 4, -1))
    table.insert(self.raid, 30, self:createDot("clockWork_raid30", 3, -1))

    table.insert(self.raid, 31, self:createDot("clockWork_raid31", 1, -12))
    table.insert(self.raid, 32, self:createDot("clockWork_raid32", 1, -11))
    table.insert(self.raid, 33, self:createDot("clockWork_raid33", 1, -10))
    table.insert(self.raid, 34, self:createDot("clockWork_raid34", 1, -9))
    table.insert(self.raid, 35, self:createDot("clockWork_raid35", 1, -8))
    table.insert(self.raid, 36, self:createDot("clockWork_raid36", 1, -7))
    table.insert(self.raid, 37, self:createDot("clockWork_raid37", 1, -6))
    table.insert(self.raid, 38, self:createDot("clockWork_raid38", 1, -5))
    table.insert(self.raid, 39, self:createDot("clockWork_raid39", 1, -4))
    table.insert(self.raid, 40, self:createDot("clockWork_raid40", 1, -3))

    self:initKeys()
    self:initCoords()
    self:initLocalization()

    self:resetCombat()

    self:setAllBindings()
end

function Clockwork:damageDone(arg1)
    --if (not self.isPassiveDamage(arg1)) then
    self.lastTimePlayerHit = time()
    self.durationBeingHitWithoutRetaliating = self.lastTimePlayerHasBeenHit - self.lastTimePlayerHit
    --Clockwork.log.debug("self : " .. tostring(Clockwork.durationBeingHitWithoutRetaliating))
    --end
end

function Clockwork:damageReceived(arg1)
    --        if UnitAffectingCombat("player") then
    self.lastTimePlayerHasBeenHit = time()
    self.durationBeingHitWithoutRetaliating = self.lastTimePlayerHasBeenHit - self.lastTimePlayerHit
    --Clockwork.log.debug("creature : " .. tostring(Clockwork.durationBeingHitWithoutRetaliating))
    --        end
end

function Clockwork:onUpdate()
    -- Clockwork.log.debug("local function onUpdate(")
    local now = GetTime()

    if self.nextUpdate and (self.nextUpdate < now) then
        if (C_Map.GetBestMapForUnit("player") == nil) then
            Clockwork.log.debug("Player is nowhere to be found.")
            --return
        end

        --        Clockwork.log.debug(Clockwork.nextUpdate)

        if (Clockwork.TOGGLE_ON_OFF and Clockwork.ADDING_WP == false) then
            if (C_Map.GetBestMapForUnit("player") ~= nil) then
                self:updatePositionCoordinates()
            end
            self:rotation()
        end

        if self.addWaypointList ~= nil and
            Clockwork.ADDING_WP == false then
            --            Clockwork.log.debug(tostring(Clockwork.addWaypointList))
            --            Clockwork.log.debug(tostring(Clockwork.ADDING_WP))
            --            Clockwork.log.debug(tostring(Clockwork.waypointListIndex))

            local index = 0;
            local finished = true

            for coords in string.gmatch(self.addWaypointList, ".-;") do
                if index == self.waypointListIndex then
                    finished = false
                    Clockwork.log.notice("Adding Waypoint : " .. coords)
                    self:updatePositionFromCoordinates(coords)
                    self.addWaypoint.texture:SetColorTexture(1, 1, 1, 1)
                    Clockwork.ADDING_WP = true;
                end

                index = index + 1;
            end

            self.waypointListIndex = self.waypointListIndex + 1

            if (finished) then
                self.addWaypointList = nil
                self.waypointListIndex = 0
            end
        end

        self.nextUpdate = now + Clockwork.UPDATE_INTERVAL;
    end
end

function Clockwork:onEvent(...)
    -- Clockwork.log.debug("local function onEvent(")

    --local numberOfArguments = select('#', ...)
    --Clockwork.log.debug(numberOfArguments)

    --for index = 1, numberOfArguments do
    --    Clockwork.log.debug(select(index, ...))
    --end

    --local frame = select(1, ...)
    local event = select(1, ...)

    --Clockwork.log.debug(event)

    if event == nil then
        return
    else
        --Clockwork.log.debug(event)
    end

    if (self.player.GUID == nil) then
        self.player.GUID = UnitGUID("player")
    end

    if (self.player.class == nil) then
        local className, classFilename, classID = UnitClass("player")
        self.player.class = { className = className, filename = classFilename, classID = classID }
    end

    if (self.player.specialization == nil and self.player.class.classID ~= nil) then
        local currentSpec = GetSpecialization()
        if currentSpec ~= nil then
            local id, name, description, icon, role = GetSpecializationInfoForClassID(self.player.class.classID,
                currentSpec)
            self.player.specialization = { id = id, name = name, description = description, icon = icon, role = role }
        end
    end

    if (self.pet.GUID == nil) then
        if (UnitExists("pet")) then
            self.pet.GUID = UnitGUID("pet")
        end
    else
        if (not UnitExists("pet")) then
            self.pet.GUID = nil
        end
    end

    if event == "SPELLCAST_START" or event == "SPELLCAST_CHANNEL_START" then
        Clockwork.CASTING = true
        self.casting.texture:SetColorTexture(1, 1, 1, 1)
    elseif event == "SPELLCAST_STOP" or event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" then
        Clockwork.CASTING = false
        self.casting.texture:SetColorTexture(0, 0, 0, 1)
    end

    if event == "PLAYER_ENTERING_WORLD" then
        Clockwork:updateAllActionSlotBindings()
        Clockwork:updateSpellIdToSlotLookup()
    end

    if event == "ADDON_LOADED" then
        local addonName = select(2, ...)

        if addonName == "Clockwork" then
            Clockwork.log.debug(select(2, ...) .. " Loaded")
            Clockwork:playerEnteringWorld()
            Clockwork:addonLoaded()
            Clockwork:resetCombat()
            return
        end
    end

    if event == "UPDATE_SHAPESHIFT_FORM" then
        local index = GetShapeshiftForm()
        Clockwork.log.debug("Shapeshift form changed to " .. tostring(index))
        if index == 1 then
            Clockwork.actionSlotOffset = 8 * 12
        elseif index == 2 then
            Clockwork.actionSlotOffset = 6 * 12
        elseif index == 3 then
            Clockwork.actionSlotOffset = 0
        else
            Clockwork.actionSlotOffset = 0
        end
        Clockwork:updateAllActionSlotBindings()
        Clockwork:updateSpellIdToSlotLookup()
    end

    if event == "ACTIONBAR_SLOT_CHANGED" then
        Clockwork:updateAllActionSlotBindings()
        Clockwork:updateSpellIdToSlotLookup()
    end

    if event == "PLAYER_SPECIALIZATION_CHANGED" and self.player.class.classID ~= nil then
        Clockwork.log.debug("Specialization changed")
        local id, name, description, icon, role = GetSpecializationInfoForClassID(self.player.class.classID,
            GetSpecialization())
        self.player.specialization = { id = id, name = name, description = description, icon = icon, role = role }
        Clockwork:updateAllActionSlotBindings()
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
        if (sourceGUID == self.player.GUID or sourceGUID == self.pet.GUID)
            and destGUID ~= self.pet.GUID
            and destGUID ~= self.player.GUID
            and not Clockwork.emptyOrNil(destGUID)
        then
            if self.targets.list[tostring(destGUID)] == nil then
                --Clockwork.log.debug("Unit added")
                --Clockwork.log.debug(tostring(subevent) .. "," .. tostring(sourceGUID) .. ", " .. tostring(sourceName) .. ", " .. tostring(destGUID) .. ", " .. tostring(destName))
            else
                --Clockwork.log.debug("Unit updated")
            end

            self.targets.list[tostring(destGUID)] = GetTime()
            self:updateNumberOfTargets()
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

            if self.targets.list[tostring(destGUID)] ~= nil then
                self.targets.list[tostring(destGUID)] = nil
                --Clockwork.log.debug("Unit removed")
                self:updateNumberOfTargets()
            end
        end
        --end

        if (self.player.GUID == sourceGUID) then
            Clockwork:damageDone()
        end

        if (self.player.GUID == destGUID) then
            Clockwork:damageReceived()
        end
    end

    if (self.notRetaliating) then
        if (self.durationBeingHitWithoutRetaliating > 6) and not (event == "PLAYER_DEAD") then
            -- Si vivant && pas tapé depuis 6 secondes
            self.notRetaliating.texture:SetColorTexture(1, 1, 1, 1)
        else
            self.notRetaliating.texture:SetColorTexture(0, 0, 0, 1)
        end
    end
end

function Clockwork:updateNumberOfTargets()
    if self.targets.list ~= nil then
        for i, time in pairs(self.targets.list) do
            if (GetTime() - time > 5) then
                self.targets.list[i] = nil
            end
        end
        Clockwork.log.debug(tostring(Clockwork.tableLength(self.targets.list)))
        Clockwork.log.debug(tostring(Clockwork.tableLength(self.targets.list) / 255))
        self.targets.count = Clockwork.tableLength(self.targets.list)
        self.numberOfTargets.texture:SetColorTexture(self.targets.count / 255, 0, 0, 1)
    else
        self.targets.count = 0
        self.numberOfTargets.texture:SetColorTexture(0, 0, 0, 1)
    end

    multiTarget = self.targets.count >= self.targets.multiTargetModTrigger

    if (self.targets.multiTargetMod ~= multiTarget) then
        Clockwork.log.debug(Clockwork.ternary(multiTarget, "Multi targets mod", "Single target mod"))
    end

    self.targets.multiTargetMod = multiTarget
end

Clockwork.frame = CreateFrame("FRAME", "clockWork_MainFrame", UIParent)
Clockwork.frame:SetPoint("TOPLEFT", 0, 0)
Clockwork.frame:SetFrameStrata("MEDIUM")

Clockwork.frame:SetScript("OnEvent", function (self, event, ...) Clockwork:onEvent(event, ...) end);
Clockwork.frame:SetScript("OnUpdate", function () Clockwork:onUpdate() end);

Clockwork.frame:RegisterEvent("PLAYER_ENTERING_WORLD");

Clockwork.frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM");

Clockwork.frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED");

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

Clockwork.frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

Clockwork.frame.texture = Clockwork.frame:CreateTexture("MEDIUM")
Clockwork.frame.texture:SetAllPoints()
Clockwork.frame.texture:SetColorTexture(0, 1, 0, 1)
