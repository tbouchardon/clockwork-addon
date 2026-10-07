-- Menu ClockWork : s'ouvre au survol, se referme 1,5 s après la sortie de la souris, sauf s'il est épinglé (clic sur le
-- titre). Interrupteurs à pastille regroupés par usage, toujours fidèles à l'état réel (commandes /clk comprises).
-- Position, épinglage et modes sont mémorisés dans la SavedVariable CLOCKWORK_SETTINGS.

local WIDTH = 170
local TITLE_HEIGHT = 22
local ROW_HEIGHT = 18
local CLOSE_DELAY = 1.5

local ON = { 0.25, 0.85, 0.35 }
local OFF = { 0.35, 0.35, 0.35 }

local frame = CreateFrame("Frame", "ClockworkMenuFrame", UIParent, "BackdropTemplate")
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:SetPoint("CENTER")
frame:SetFrameStrata("HIGH")
NineSliceUtil.ApplyLayout(frame, "Tooltip")
Clockwork.menu = frame

local content = {} -- éléments masqués quand le menu est replié
local toggles = {} -- interrupteurs, rafraîchis en continu

--- Pastille d'état.
local function dot(parent)
    local texture = parent:CreateTexture(nil, "ARTWORK")
    texture:SetSize(8, 8)
    return texture
end

local function paint(texture, on)
    local color = on and ON or OFF
    texture:SetColorTexture(color[1], color[2], color[3], 1)
end

-- Barre de titre : clic pour épingler, glisser pour déplacer
local title = CreateFrame("Button", nil, frame)
title:SetPoint("TOPLEFT")
title:SetPoint("TOPRIGHT")
title:SetHeight(TITLE_HEIGHT)
title:RegisterForDrag("LeftButton")
title:RegisterForClicks("LeftButtonUp")

local titleDot = dot(title)
titleDot:SetPoint("LEFT", 8, 0)

local titleText = title:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
titleText:SetPoint("LEFT", titleDot, "RIGHT", 6, 0)
titleText:SetText("Clockwork")

local pin = title:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
pin:SetPoint("RIGHT", -8, 0)

-- Contenu : groupes et lignes empilés sous le titre
local cursor = -TITLE_HEIGHT

local function header(text)
    cursor = cursor - 4
    local label = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", 8, cursor)
    label:SetText(text)
    label:SetTextColor(1, 0.82, 0)
    table.insert(content, label)
    cursor = cursor - 14
end

local function attachTooltip(button, tooltip)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltip, 1, 1, 1, 1, true)
        frame.clearTimer()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
        frame.startTimer()
    end)
end

--- Interrupteur : pastille + libellé ; l'état est lu par isOn() à chaque rafraîchissement.
local function toggle(text, tooltip, isOn, onClick)
    local button = CreateFrame("Button", nil, frame)
    button:SetPoint("TOPLEFT", 6, cursor)
    button:SetSize(WIDTH - 12, ROW_HEIGHT)
    button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    button.dot = dot(button)
    button.dot:SetPoint("LEFT", 6, 0)
    local label = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    label:SetPoint("LEFT", button.dot, "RIGHT", 8, 0)
    label:SetText(text)
    button.isOn = isOn
    button:SetScript("OnClick", function()
        onClick()
        frame.refresh()
    end)
    attachTooltip(button, tooltip)
    table.insert(content, button)
    table.insert(toggles, button)
    cursor = cursor - ROW_HEIGHT
end

--- Ligne de boutons d'action (sans état).
local function actions(list)
    local width = (WIDTH - 12 - 4 * (#list - 1)) / #list
    for index, action in ipairs(list) do
        local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        button:SetSize(width, ROW_HEIGHT + 2)
        button:SetPoint("TOPLEFT", 6 + (index - 1) * (width + 4), cursor - 1)
        button:SetText(action[1])
        button:GetFontString():SetFontObject("GameFontHighlightSmall")
        button:SetScript("OnClick", action[3])
        attachTooltip(button, action[2])
        table.insert(content, button)
    end
    cursor = cursor - ROW_HEIGHT - 4
end

header("Combat")
toggle("Activation", "Allume ou éteint ClockWork : le Java n'agit que s'il est actif (/clk toggle).",
    function() return Clockwork.TOGGLE_ON_OFF end, function() Clockwork:clickToggle() end)
toggle("Aggro", "Attaquer aussi une cible qui n'est pas encore en combat. Sans aggro, en combat, ne combattre que ce qui est en combat.",
    function() return Clockwork.AGGRO_MOD end, function() Clockwork:clickAggro() end)
toggle("Multi-cibles", "Les rotations répartissent leurs DoT entre plusieurs ennemis et utilisent leurs sorts de zone (/clk multi).",
    function() return Clockwork.MULTI_MOD end, function() Clockwork:clickMulti() end)
toggle("Mode soigneur", "Le cerveau Java soigne aussi les autres membres du groupe. Allumé d'office pour une spécialisation de soin (/clk healer).",
    function() return Clockwork.HEALER_MOD end, function() Clockwork:clickHealer() end)
toggle("Ciblage auto", "Cibler l'ennemi le plus proche quand il n'y a rien à faire (/clk tne).",
    function() return Clockwork.TARGET_NEAREST_ENEMY end, function() Clockwork:clickTNE() end)

header("Déplacement")

-- Parcours actif : un clic ouvre la liste des parcours et leur gestion (nouveau, renommer, exporter, supprimer...)
local routeSelector = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
routeSelector:SetSize(WIDTH - 12, ROW_HEIGHT + 2)
routeSelector:SetPoint("TOPLEFT", 6, cursor - 1)
routeSelector:SetText("Aucun parcours")
routeSelector:GetFontString():SetFontObject("GameFontHighlightSmall")
routeSelector:SetScript("OnClick", function(self) Clockwork.showRouteMenu(self) end)
attachTooltip(routeSelector, "Parcours actif : un clic pour en choisir un autre, en créer, le renommer, l'exporter, le supprimer...")
table.insert(content, routeSelector)
cursor = cursor - ROW_HEIGHT - 4

actions({
    { "+ Point", "Ajouter la position actuelle au parcours actif (/clk wp add).", function() Clockwork.addRoutePoint() end },
    { "Annuler", "Retirer le dernier point (/clk wp undo).", function() Clockwork.undoRoutePoint() end },
    { "Vider", "Retirer tous les points du parcours actif (/clk wp clear).", function() Clockwork.clearRoute() end },
})
toggle("Boucle", "Recommencer le parcours actif une fois terminé (/clk route loop).",
    function() local route = Clockwork.activeRoute() return route and route.loop end, function() Clockwork.toggleRouteLoop() end)
toggle("Pilote automatique", "Suivre le parcours actif ; le Java rejoint d'abord le point le plus proche (/clk drive).",
    function() return Clockwork.DRIVE_MOD end, function() Clockwork:clickDrive() end)
toggle("Ramassage", "Après un combat, ramasser le butin d'un cadavre à portée, au plus un petit pas en avant (/clk loot). Demande « Activer la touche d'interaction » (Options > Contrôles).",
    function() return Clockwork.LOOT_MOD end, function() Clockwork:clickLoot() end)

header("Pêche")
toggle("Pêche automatique", "Le Java lance la ligne et ferre tant que c'est allumé ; bouger la souris l'arrête (/clk fish).",
    function() return Clockwork.FISH_MOD end, function() Clockwork:clickFish() end)

-- Statistiques de pêche de la session (prises, poissons échappés, faux clics), d'après le résultat de chaque lancer
local fishingStats = frame:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
fishingStats:SetPoint("TOPLEFT", 8, cursor - 2)
fishingStats:SetPoint("TOPRIGHT", -8, cursor - 2)
fishingStats:SetJustifyH("LEFT")
table.insert(content, fishingStats)
cursor = cursor - 28

header("Outils")
toggle("Débogage", "Journal détaillé dans le chat (/clk debug).",
    function() return Clockwork.DEBUG_MOD end, function() Clockwork:clickDebug() end)
actions({
    { "Secrets", "Ce que le client autorise sur les valeurs secrètes (/clk testsecret, à lancer en combat).", function() Clockwork.testSecrets() end },
    { "Erreurs", "Blocs de la grille en erreur (/clk errors).", function() Clockwork.showTextWindow(Clockwork.guardReport()) end },
})

-- Ligne d'informations
cursor = cursor - 2
local info = frame:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
info:SetPoint("TOPLEFT", 8, cursor)
info:SetPoint("TOPRIGHT", -8, cursor)
info:SetJustifyH("LEFT")
table.insert(content, info)
cursor = cursor - 14

local EXPANDED_HEIGHT = -cursor + 6

--- Réglages mémorisés (SavedVariable, disponible à ADDON_LOADED).
local function settings()
    CLOCKWORK_SETTINGS = CLOCKWORK_SETTINGS or {}
    CLOCKWORK_SETTINGS.modes = CLOCKWORK_SETTINGS.modes or {}
    return CLOCKWORK_SETTINGS
end

-- Modes mémorisés d'une session à l'autre ; les actions (activation, pilote, pêche) repartent éteintes par prudence
local SAVED_MODES = {
    { key = "AGGRO_MOD", click = function() Clockwork:clickAggro() end },
    { key = "MULTI_MOD", click = function() Clockwork:clickMulti() end },
    { key = "TARGET_NEAREST_ENEMY", click = function() Clockwork:clickTNE() end },
    { key = "LOOT_MOD", click = function() Clockwork:clickLoot() end },
    { key = "DEBUG_MOD", click = function() Clockwork:clickDebug() end },
}

function frame.refresh()
    for _, button in ipairs(toggles) do paint(button.dot, button.isOn() == true) end
    paint(titleDot, Clockwork.TOGGLE_ON_OFF == true)
    pin:SetText(settings().pinned and "épinglé" or "")

    local spec = Clockwork.player and Clockwork.player.specialization and Clockwork.player.specialization.name or "?"
    local errors = 0
    for _ in pairs(Clockwork.guardErrors or {}) do errors = errors + 1 end
    info:SetText(string.format("%s · grille v%d · %s", spec, Clockwork.QR_VERSION or 0,
        errors == 0 and "aucune erreur" or (errors .. " bloc(s) en erreur")))

    for _, mode in ipairs(SAVED_MODES) do settings().modes[mode.key] = Clockwork[mode.key] == true end
    fishingStats:SetText(Clockwork.fishingSummary and Clockwork.fishingSummary() or "")
    local route = Clockwork.activeRoute and Clockwork.activeRoute()
    routeSelector:SetText(route and (Clockwork.activeRouteName() .. " · " .. #route.points .. " pt") or "Aucun parcours ▾")
end

function frame.Expand()
    frame:SetSize(WIDTH, EXPANDED_HEIGHT)
    for _, element in ipairs(content) do element:Show() end
    frame.refresh()
end

function frame.Collapse()
    if settings().pinned then return end
    frame:SetSize(WIDTH, TITLE_HEIGHT)
    for _, element in ipairs(content) do element:Hide() end
end

function frame.clearTimer()
    if Clockwork.menuFrameTimer then
        Clockwork.menuFrameTimer:Cancel()
        Clockwork.menuFrameTimer = nil
    end
end

function frame.startTimer()
    frame.clearTimer()
    Clockwork.menuFrameTimer = C_Timer.NewTimer(CLOSE_DELAY, function()
        if not frame:IsMouseOver() then frame.Collapse() end
    end)
end

--- Applique les réglages mémorisés : position, épinglage, modes. Appelée à ADDON_LOADED, une fois la grille créée.
function Clockwork.applySettings()
    local saved = settings()
    if saved.position then
        frame:ClearAllPoints()
        frame:SetPoint(saved.position[1], UIParent, saved.position[2], saved.position[3], saved.position[4])
    end
    for _, mode in ipairs(SAVED_MODES) do
        local wanted = saved.modes[mode.key]
        if wanted ~= nil and (Clockwork[mode.key] == true) ~= wanted then mode.click() end
    end
    if saved.pinned then frame.Expand() else frame.Collapse() end
end

local function savePosition()
    local point, _, relativePoint, x, y = frame:GetPoint()
    settings().position = { point, relativePoint, x, y }
end

-- Survol : ouverture ; sortie : fermeture différée (sauf épinglé)
frame:SetScript("OnEnter", function()
    frame.Expand()
    frame.clearTimer()
end)
frame:SetScript("OnLeave", function() frame.startTimer() end)
title:SetScript("OnEnter", function()
    frame.Expand()
    frame.clearTimer()
end)
title:SetScript("OnLeave", function() frame.startTimer() end)
title:SetScript("OnClick", function()
    settings().pinned = not settings().pinned
    frame.Expand()
end)
title:SetScript("OnDragStart", function() frame:StartMoving() end)
title:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePosition()
end)

-- État rafraîchi en continu tant que le menu est ouvert (les commandes /clk changent aussi les modes)
local elapsedSinceRefresh = 0
frame:SetScript("OnUpdate", function(_, elapsed)
    elapsedSinceRefresh = elapsedSinceRefresh + elapsed
    if elapsedSinceRefresh < 0.25 then return end
    elapsedSinceRefresh = 0
    frame.refresh()
end)

--- Compartiment d'addons (bouton près de la minicarte) : affiche ou masque le menu, ouvert et épinglé.
function Clockwork_OnAddonCompartmentClick()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        settings().pinned = true
        frame.Expand()
    end
end

frame.Collapse()
