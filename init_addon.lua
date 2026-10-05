--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 17/02/2017
-- Time: 13:51
-- To change this template use File | Settings | File Templates.
--

-- Nom réel de l'addon (celui du dossier et du .toc, ex. "ClockWork"), transmis par WoW à chaque fichier chargé
local ADDON_NAME = ...

function Clockwork.addonLoaded()
    if Clockwork_ROTATIONS == nil then
        Clockwork_ROTATIONS = {};
    end
end

--- Règle l'échelle de la grille pour qu'un point de l'addon fasse exactement un pixel à l'écran.
--- WoW dessine l'interface dans un espace de 768 unités de haut, étiré à la hauteur réelle de la zone de jeu
--- (ex. 1009 px en fenêtré agrandi : x1,31, le QR code ferait 21x21 px) ; le Java lit le QR code pixel par pixel.
--- @return nil
function Clockwork:updatePixelScale()
    local _, height = GetPhysicalScreenSize()
    if not height or height <= 0 then return end

    local parent = self.frame:GetParent()
    local parentScale = parent and parent:GetEffectiveScale() or 1
    self.frame:SetScale(768 / height / parentScale)
end

function Clockwork:playerEnteringWorld()
    -- init Frames

    self.frame:SetWidth(16)
    self.frame:SetHeight(16)
    self:updatePixelScale()

    self.nextUpdate = 0
    self.addWaypointList = nil
    self.waypointListIndex = 0

    self.blackBackground3 = CreateFrame("FRAME", "clockWork_Background3", self.frame)
    self.blackBackground3:SetPoint("CENTER", 0, 0)
    self.blackBackground3:SetWidth(14)
    self.blackBackground3:SetHeight(14)
    self.blackBackground3:SetFrameStrata("TOOLTIP")
    self.blackBackground3:SetFrameLevel(2)
    self.blackBackground3.texture = self.blackBackground3:CreateTexture(nil, "BACKGROUND")
    self.blackBackground3.texture:SetAllPoints()
    self.blackBackground3.texture:SetColorTexture(0, 0, 0, 1)

    self.blackBackground1 = CreateFrame("FRAME", "clockWork_Background1", self.frame)
    self.blackBackground1:SetPoint("CENTER", 0, 0)
    self.blackBackground1:SetSize(16, 8)
    self.blackBackground1:SetFrameStrata("TOOLTIP")
    self.blackBackground1:SetFrameLevel(3)
    self.blackBackground1.texture = self.blackBackground1:CreateTexture(nil, "ARTWORK")
    self.blackBackground1.texture:SetAllPoints()
    self.blackBackground1.texture:SetColorTexture(0, 0, 0, 1)

    self.blackBackground2 = CreateFrame("FRAME", "clockWork_Background2", self.frame)
    self.blackBackground2:SetPoint("CENTER", 0, 0)
    self.blackBackground2:SetWidth(8)
    self.blackBackground2:SetHeight(16)
    self.blackBackground2:SetFrameStrata("TOOLTIP")
    self.blackBackground2:SetFrameLevel(3)
    self.blackBackground2.texture = self.blackBackground2:CreateTexture(nil, "ARTWORK")
    self.blackBackground2.texture:SetAllPoints()
    self.blackBackground2.texture:SetColorTexture(0, 0, 0, 1)

    self.onOff = CreateFrame("FRAME", "clockWork_onOff", self.frame)
    self.onOff:SetPoint("CENTER", 0, 0)
    self.onOff:SetWidth(16)
    self.onOff:SetHeight(16)
    self.onOff:SetFrameStrata("TOOLTIP")
    self.onOff:SetFrameLevel(20)
    self.onOff.texture = self.onOff:CreateTexture("DIALOG")
    self.onOff.texture:SetAllPoints()
    self.onOff.texture:SetColorTexture(0, 1, 0, 1)

    self.inCombat = self:createDot("clockWork_inCombat", 2, -2)
    self.casting = self:createDot("clockWork_casting", 3, -2)

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
    -- Pêche demandée au Java (blanc) : il pêche tant que la case est allumée
    self.fish = self:createDot("clockWork_fish", 12, -4)
    if Clockwork.DEBUG_MOD then
        self.debug.texture:SetColorTexture(1, 0, 0, 1)
    end

    self.raid = {}

    -- Raid 1-10: x=3 to 12, y=-1
    for i = 1, 10 do
        table.insert(self.raid, i, self:createDot("clockWork_raid" .. i, 2 + i, -1))
    end

    -- Raid 11-20: x=14, y=-3 to -12
    for i = 11, 20 do
        table.insert(self.raid, i, self:createDot("clockWork_raid" .. i, 14, -(i - 8)))
    end

    -- Raid 21-30: x=12 to 3, y=-14
    for i = 21, 30 do
        table.insert(self.raid, i, self:createDot("clockWork_raid" .. i, 12 - (i - 21), -14))
    end

    -- Raid 31-40: x=1, y=-12 to -3
    for i = 31, 40 do
        table.insert(self.raid, i, self:createDot("clockWork_raid" .. i, 1, -(12 - (i - 31))))
    end

    self:initKeys()
    self:initQrCodeV2()
    self:initCoords()
    self:initLocalization()

    self:resetCombat()

    self:setAllBindings()
end

function Clockwork:onUpdate()
    local now = GetTime()

    if self.nextUpdate and (self.nextUpdate < now) then
        local bestMap = C_Map.GetBestMapForUnit("player")
        if (bestMap == nil) then
            Clockwork.log.debug("Player is nowhere to be found.")
            --return
        end

        if (Clockwork.TOGGLE_ON_OFF and Clockwork.ADDING_WP == false) then
            if (bestMap ~= nil) then
                self:updatePositionCoordinates()
            end
            self:rotation()
        end

        if self.addWaypointList ~= nil and Clockwork.ADDING_WP == false then
            local index = 0
            local finished = true

            for coords in string.gmatch(self.addWaypointList, ".-;") do
                if index == self.waypointListIndex then
                    finished = false
                    Clockwork.log.notice("Adding Waypoint : " .. coords)
                    self:updatePositionFromCoordinates(coords)
                    self.addWaypoint.texture:SetColorTexture(1, 1, 1, 1)
                    Clockwork.ADDING_WP = true;
                end
                index = index + 1
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

function Clockwork:updateNumberOfTargets()
    if self.targets.list ~= nil then
        for i, t in pairs(self.targets.list) do
            if (GetTime() - t > 5) then
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

    local multiTarget = self.targets.count >= self.targets.multiTargetModTrigger

    if (self.targets.multiTargetMod ~= multiTarget) then
        Clockwork.log.debug(Clockwork.ternary(multiTarget, "Multi targets mod", "Single target mod"))
    end

    self.targets.multiTargetMod = multiTarget
end

--[[---------------------------------------------------------------------------
Event Handling
---------------------------------------------------------------------------]]--

local eventHandlers

local function handleSpellcastStart(self, unit, _, spellID)
    if unit == "target" then
        Clockwork.recordTargetCast(spellID)
        return
    end
    if unit ~= "player" then return end
    self.CASTING = true
    self.casting.texture:SetColorTexture(1, 1, 1, 1)
    Clockwork.currentCast = { spellID = spellID, channel = false }
end

local function handleChannelStart(self, unit, _, spellID)
    handleSpellcastStart(self, unit, nil, spellID)
    if unit == "player" then Clockwork.currentCast.channel = true end
end

local function handleSpellcastStop(self, unit)
    if unit == "target" then
        Clockwork.targetCast = nil
        return
    end
    if unit ~= "player" then return end
    self.CASTING = false
    self.casting.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.currentCast = nil
end

local function handleAddonLoaded(self, addonName)
    if addonName == ADDON_NAME then
        Clockwork.log.debug(addonName .. " Loaded")
        self:playerEnteringWorld()
        self:addonLoaded()
        self:resetCombat()
        -- Réglages mémorisés (position du menu, modes) : SavedVariables disponibles et grille créée
        Clockwork.guard("applySettings", Clockwork.applySettings)
        return true -- Stop further processing
    end
end

local function handlePlayerEnteringWorld(self)

    -- Initialize player state
    if (self.player.GUID == nil) then self.player.GUID = UnitGUID("player") end
    if (self.player.class == nil) then
        local className, classFilename, classID = UnitClass("player")
        self.player.class = { className = className, classFilename = classFilename, classId = classID }
    end
    if (self.player.specialization == nil and self.player.class.classId ~= nil) then
        local currentSpec = GetSpecialization()
        if currentSpec ~= nil then
            local id, name, description, icon, role = GetSpecializationInfoForClassID(self.player.class.classId, currentSpec)
            self.player.specialization = { id = id, name = name, description = description, icon = icon, role = role }
        end
    end

    self:updateBindings()
end

local function handlePetChanged(self, unit)
    if unit == "player" then
        if (UnitExists("pet")) then
            self.pet.GUID = UnitGUID("pet")
        else
            self.pet.GUID = nil
        end
        Clockwork.log.debug("Pet GUID updated: " .. tostring(self.pet.GUID))
    end
end

local function handleUpdateShapeshiftForm(self)
    local index = GetShapeshiftForm()
    Clockwork.log.debug("Shapeshift form changed to " .. tostring(index))
    self:updateBindings()
end

local function handleSpecializationChanged(self)
    if self.player.class.classId ~= nil then
        Clockwork.log.debug("Specialization changed")
        local id, name, description, icon, role = GetSpecializationInfoForClassID(self.player.class.classId, GetSpecialization())
        self.player.specialization = { id = id, name = name, description = description, icon = icon, role = role }
        self:updateCommandBindingMap()
    end
end

eventHandlers = {
    ["UNIT_SPELLCAST_START"] = handleSpellcastStart,
    ["UNIT_SPELLCAST_CHANNEL_START"] = handleChannelStart,
    ["UNIT_SPELLCAST_STOP"] = handleSpellcastStop,
    ["UNIT_SPELLCAST_CHANNEL_STOP"] = handleSpellcastStop,
    ["UNIT_SPELLCAST_FAILED"] = handleSpellcastStop,
    ["UNIT_SPELLCAST_INTERRUPTED"] = handleSpellcastStop,
    ["UNIT_AURA"] = function(_, unit, updateInfo) Clockwork.recordUnitAura(unit, updateInfo) end,
    ["DISPLAY_SIZE_CHANGED"] = function(self) self:updatePixelScale() end,
    ["UI_SCALE_CHANGED"] = function(self) self:updatePixelScale() end,
    ["UNIT_SPELLCAST_SUCCEEDED"] = function(_, unit, castGUID, spellId)
        Clockwork.recordCastSucceeded(unit, castGUID, spellId)
        if unit == "player" then Clockwork.recordOwnCast(spellId) end
    end,
    ["SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"] = function(_, spellId) Clockwork.recordOverlayGlow("allumé", spellId) end,
    ["SPELL_ACTIVATION_OVERLAY_GLOW_HIDE"] = function(_, spellId) Clockwork.recordOverlayGlow("éteint", spellId) end,
    ["ADDON_LOADED"] = handleAddonLoaded,
    ["PLAYER_ENTERING_WORLD"] = handlePlayerEnteringWorld,
    ["UNIT_PET"] = handlePetChanged,
    ["UPDATE_SHAPESHIFT_FORM"] = handleUpdateShapeshiftForm,
    ["ACTIONBAR_SLOT_CHANGED"] = function(self) self:updateBindings() end,
    ["UPDATE_BINDINGS"] = function(self) self:updateBindings() end,
    ["PLAYER_SPECIALIZATION_CHANGED"] = handleSpecializationChanged,
    ["PLAYER_TARGET_CHANGED"] = function() Clockwork.recordTargetChanged() end,
    ["UNIT_SPELLCAST_INTERRUPTIBLE"] = function(_, unit) Clockwork.recordTargetInterruptible(unit, true) end,
    ["UNIT_SPELLCAST_NOT_INTERRUPTIBLE"] = function(_, unit) Clockwork.recordTargetInterruptible(unit, false) end,
}

function Clockwork:onEvent(event, ...)
    if event == nil then return end
    Clockwork.log.debug(event)

    local handler = eventHandlers[event]
    if handler then
        handler(self, ...)
    end
end

Clockwork.frame = CreateFrame("FRAME") --, "ClockworkFrame", UIParent)
-- Register Events
-- COMBAT_LOG_EVENT_UNFILTERED est réservé à l'interface de Blizzard en 12.x (abonnement bloqué, aucun événement reçu) :
-- le compteur de cibles et la détection « frappé sans riposter » qui s'appuyaient dessus ne sont plus alimentés.
local eventsToRegister = {
    "PLAYER_ENTERING_WORLD",
    "UPDATE_SHAPESHIFT_FORM",
    "ACTIONBAR_SLOT_CHANGED",
    "UPDATE_BINDINGS",
    "UNIT_SPELLCAST_START",
    "UNIT_SPELLCAST_STOP",
    "UNIT_SPELLCAST_FAILED",
    "UNIT_SPELLCAST_INTERRUPTED",
    "UNIT_SPELLCAST_DELAYED",
    "UNIT_SPELLCAST_CHANNEL_START",
    "UNIT_SPELLCAST_CHANNEL_UPDATE",
    "UNIT_SPELLCAST_CHANNEL_STOP",
    "UNIT_AURA",
    "DISPLAY_SIZE_CHANGED",
    "UI_SCALE_CHANGED",
    "UNIT_SPELLCAST_SUCCEEDED",
    "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW",
    "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE",
    "ADDON_LOADED",
    "PLAYER_DEAD",
    "PLAYER_SPECIALIZATION_CHANGED",
    "PLAYER_TARGET_CHANGED",
    "UNIT_SPELLCAST_INTERRUPTIBLE",
    "UNIT_SPELLCAST_NOT_INTERRUPTIBLE",
    "UNIT_PET"
}
-- EventRegistry:RegisterCallback n'écoute que les événements déclenchés par EventRegistry:TriggerEvent, pas ceux du jeu :
-- l'abonnement se fait sur la frame. Un événement refusé par le client (ex. journal de combat en 12.0) est ignoré
-- et noté dans Clockwork.refusedEvents, sans empêcher l'abonnement aux autres.
Clockwork.refusedEvents = {}
for _, eventName in ipairs(eventsToRegister) do
    local ok, err = pcall(Clockwork.frame.RegisterEvent, Clockwork.frame, eventName)
    if not ok then
        Clockwork.refusedEvents[eventName] = tostring(err)
        Clockwork.log.warning("Événement " .. eventName .. " refusé : " .. tostring(err))
    end
end

Clockwork.frame:SetPoint("TOPLEFT", 0, 0)
-- Niveau le plus haut : les effets plein écran (halo rouge de vie basse...) teintaient la grille, illisible pour le Java
Clockwork.frame:SetFrameStrata("TOOLTIP")
Clockwork.frame:SetFrameLevel(1)

Clockwork.frame:SetScript("OnEvent", function (self, event, ...) Clockwork:onEvent(event, ...) end);
Clockwork.frame:SetScript("OnUpdate", function (self, elapsed) Clockwork:onUpdate() end);

Clockwork.frame.texture = Clockwork.frame:CreateTexture("MEDIUM")
Clockwork.frame.texture:SetAllPoints()
Clockwork.frame.texture:SetColorTexture(0, 1, 0, 1)

Clockwork.log.debug("Clockwork addon initialized")