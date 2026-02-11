-- Create the main menu frame, replacing menu.xml
local frame = CreateFrame("Frame", "ClockworkMenuFrame", UIParent, "BackdropTemplate")
frame:SetMovable(true)
frame:SetPoint("CENTER")
frame:SetClampedToScreen(true)

-- "Dialog"	            Épais, biseauté, gris classique.	    Grandes fenêtres de configuration.
-- "Tooltip"	        Fin (1px), noir translucide, moderne.	Menu discret de combat (Recommandé).
-- "GenericGoldBorder"	Bordure dorée fine, angles droits.	    Menus de prestige ou de loot.
-- "IdentifiedItem"	    Très sombre, presque plat, futuriste.   Addons techniques ou "dark mode".
NineSliceUtil.ApplyLayout(frame, "Tooltip")

-- L'atlas de Blizzard est parfois un peu clair, on peut ajouter une texture de fond
--local bg = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
--bg:SetAllPoints(frame)
--bg:SetColorTexture(0, 0, 0, 0.8) -- Noir pur à 80%
--frame.CustomBG = bg

local titleText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
titleText:SetPoint("TOP", frame, "TOP", 0, -5)
titleText:SetText("Clockwork")

local buttons = {}

local function createMenuButton(name, parent, relativeTo, text, tooltip)
    local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    button:SetSize(120, 25)
    if relativeTo then
        button:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, -2)
    else
        button:SetPoint("TOPLEFT", 8, -25)
    end
    button:SetText(text)
    button.tooltip = tooltip
    table.insert(buttons, button)
    return button
end

-- Functions to expand/collapse
function frame.Expand()
    frame:SetSize(137, 250)
    for _, button in ipairs(buttons) do
        button:Show()
    end
end

function frame.Collapse()
    frame:SetSize(137, 25)
    for _, button in ipairs(buttons) do
        button:Hide()
    end
end

-- Timer functions
function frame.clearTimer()
    if Clockwork.menuFrameTimer then
        Clockwork.menuFrameTimer:Cancel()
        Clockwork.menuFrameTimer = nil
    end
end

function frame.startTimer()
    frame:clearTimer() -- Ensure no other timer is running
    Clockwork.menuFrameTimer = C_Timer.NewTimer(1, function()
        if not frame:IsMouseOver() then
            Clockwork.log.debug("ClockworkMenuFrame : Hiding menu")
            frame:Collapse()
        end
    end)
end

-- Main frame scripts
frame:SetScript("OnLoad", function(self)
end)

frame:RegisterForDrag("LeftButton")
frame:Collapse()

frame:SetScript("OnEnter", function(self)
    Clockwork.log.debug("ClockworkMenuFrame : Enter")
    self:Expand()
    self:clearTimer()
end)

frame:SetScript("OnLeave", function(self)
    Clockwork.log.debug("ClockworkMenuFrame : Leave")
    self:startTimer()
end)

frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)

frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

-- Buttons
local btnToggle = createMenuButton("ClockworkMenuButtonToggle", frame, nil, "Off - Toggle", "Toggle Clockwork On/Off")
btnToggle:SetScript("OnClick", function()
    Clockwork:clickToggle()
    btnToggle:SetText(Clockwork.TOGGLE_ON_OFF and "On - Toggle" or "Off - Toggle")
end)

local btnAggro = createMenuButton("ClockworkMenuButtonAggro", frame, btnToggle, "On - Aggro", "Allow Aggro in combat On/Off")
btnAggro:SetScript("OnClick", function()
    Clockwork.AGGRO_MOD = not Clockwork.AGGRO_MOD
    btnAggro:SetText(Clockwork.AGGRO_MOD and "On - Aggro" or "Off - Aggro")
    Clockwork.log.notice("Aggro Mod : " .. (Clockwork.AGGRO_MOD and "On" or "Off"))
end)

local btnTNE = createMenuButton("ClockworkMenuButtonTNE", frame, btnAggro, "Off - TNE", "Auto Target Next Enemy On/Off")
btnTNE:SetScript("OnClick", function()
    Clockwork:clickTNE()
    btnTNE:SetText(Clockwork.TARGET_NEAREST_ENEMY and "On - TNE" or "Off - TNE")
end)

local btnDrive = createMenuButton("ClockworkMenuButtonDrive", frame, btnTNE, "Off - Drive", "Start/Stop GPS !!")
btnDrive:SetScript("OnClick", function()
    Clockwork:clickDrive()
    btnDrive:SetText(Clockwork.DRIVE_MOD and "On - Drive" or "Off - Drive")
end)

local btnLoop = createMenuButton("ClockworkMenuButtonLoop", frame, btnDrive, "Off - Loop WP", "Loop through waypoints")
btnLoop:SetScript("OnClick", function()
    Clockwork:clickLoop()
    btnLoop:SetText(Clockwork.DRIVE_LOOP and "On - Loop WP" or "Off - Loop WP")
end)

local btnDebug = createMenuButton("ClockworkMenuButtonDebug", frame, btnLoop, "Off - Debug", "Toggle debug mod On/Off")
btnDebug:SetScript("OnClick", function()
    Clockwork:clickDebug()
    btnDebug:SetText(Clockwork.DEBUG_MOD and "On - Debug" or "Off - Debug")
end)

local btnAddWP = createMenuButton("ClockworkMenuButtonAddWP", frame, btnDebug, "Add Waypoint", "Add a waypoint at current position")
btnAddWP:SetScript("OnClick", function() Clockwork:clickAddWp() end)

local btnClearWP = createMenuButton("ClockworkMenuButtonClearWP", frame, btnAddWP, "Clear Waypoints", "Clear every waypoints")
btnClearWP:SetScript("OnClick", function() Clockwork:clickClearWp() end)

-- Add common scripts to all buttons
for _, button in ipairs(buttons) do
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.tooltip)
        frame:clearTimer()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
        frame:startTimer()
    end)
end