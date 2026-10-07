-- Parcours du pilote automatique, tenus par l'addon et partagés par tous les personnages du compte.
--
-- CLOCKWORK_ROUTES (compte)        : [nom] = { map = carte (zone), loop = boucle, points = { {x, y}, ... }, updated = date }
-- CLOCKWORK_CHARACTER (personnage) : active = parcours actif, lastByMap = { [carte] = dernier parcours utilisé }
--
-- Coordonnées relatives à la carte de zone du parcours (0 à 1) : WoW donne la position du joueur sur une carte qui contient
-- sa zone actuelle, un parcours tracé sur une zone reste donc valable dans ses sous-zones (village, grotte...).
--
-- Grille : le parcours actif occupe les cases libres des blocs 3 et 4 (celles que les touches n'utilisent pas), dans
-- l'ordre (bloc 3 puis 4, ligne par ligne) :
--   1 : révision, 24 bits (change à chaque modification ou changement de parcours : le Java relit alors le parcours)
--   2 : carte du parcours, 24 bits (0 = aucun parcours)
--   3 : R = nombre de points / 255, G = boucle, B = le joueur est sur la carte du parcours
--   4, 5 : position du joueur sur la carte du parcours, x puis y, 24 bits (fraction × 16777215)
--   puis chaque point : x, y (24 bits chacun)
-- Le Java ne garde rien : plus d'accusé de réception tapé dans le chat.
--
-- Au changement de zone, le dernier parcours utilisé sur la nouvelle carte devient actif, et l'automate est coupé
-- (activation et pilote) : un parcours ne se lance jamais seul.

Clockwork.ROUTE_MAX_POINTS = 130

local FRACTION = 16777215
local routeCells = {}
local revision = 0

-- --- Données ---------------------------------------------------------------------------------------------------------

local function routes()
    CLOCKWORK_ROUTES = CLOCKWORK_ROUTES or {}
    return CLOCKWORK_ROUTES
end

local function character()
    CLOCKWORK_CHARACTER = CLOCKWORK_CHARACTER or {}
    CLOCKWORK_CHARACTER.lastByMap = CLOCKWORK_CHARACTER.lastByMap or {}
    return CLOCKWORK_CHARACTER
end

local function changed()
    revision = (revision + 1) % 16777216
    if Clockwork.refreshRouteMap then Clockwork.refreshRouteMap() end
    if Clockwork.menu and Clockwork.menu.refresh then Clockwork.menu.refresh() end
end

--- Carte de zone d'une carte : on remonte les cartes parentes tant qu'elles sont plus fines qu'une zone (donjon, micro...).
function Clockwork.zoneMapOf(mapID)
    local current = mapID
    while current do
        local info = C_Map.GetMapInfo(current)
        if not info then return mapID end
        if info.mapType <= Enum.UIMapType.Zone then
            return info.mapType == Enum.UIMapType.Zone and current or mapID
        end
        current = info.parentMapID
    end
    return mapID
end

--- Carte de zone où se trouve le joueur.
function Clockwork.currentZoneMap()
    local mapID = C_Map.GetBestMapForUnit("player")
    return mapID and Clockwork.zoneMapOf(mapID)
end

function Clockwork.activeRouteName()
    local name = character().active
    if name and routes()[name] then return name end
    return nil
end

function Clockwork.activeRoute()
    local name = Clockwork.activeRouteName()
    return name and routes()[name]
end

--- Position du joueur sur la carte du parcours, ou nil s'il n'y est pas.
local function playerOn(route)
    local position = route and C_Map.GetPlayerMapPosition(route.map, "player")
    if not position then return nil end
    local x, y = position:GetXY()
    if x == 0 and y == 0 then return nil end
    return x, y
end

local function mapName(mapID)
    local info = mapID and C_Map.GetMapInfo(mapID)
    return info and info.name or tostring(mapID)
end

--- Parcours, ceux de la carte actuelle en premier, puis par nom.
function Clockwork.routeNames()
    local here, names = Clockwork.currentZoneMap(), {}
    for name in pairs(routes()) do table.insert(names, name) end
    table.sort(names, function(a, b)
        local aHere, bHere = routes()[a].map == here, routes()[b].map == here
        if aHere ~= bHere then return aHere end
        return a < b
    end)
    return names
end

function Clockwork.useRoute(name)
    local route = name and routes()[name]
    character().active = route and name or nil
    if route then character().lastByMap[route.map] = name end
    changed()
end

function Clockwork.newRoute(name)
    name = name and strtrim(name) or ""
    if name == "" then return Clockwork.log.notice("Parcours : nom vide") end
    if routes()[name] then return Clockwork.log.notice("Parcours : « " .. name .. " » existe déjà") end
    local map = Clockwork.currentZoneMap()
    if not map then return Clockwork.log.notice("Parcours : position inconnue ici") end
    routes()[name] = { map = map, loop = true, points = {}, updated = time() }
    Clockwork.useRoute(name)
    Clockwork.log.notice("Parcours « " .. name .. " » créé sur " .. mapName(map))
end

function Clockwork.renameRoute(newName)
    local old = Clockwork.activeRouteName()
    newName = newName and strtrim(newName) or ""
    if not old or newName == "" or routes()[newName] then return Clockwork.log.notice("Parcours : renommage impossible") end
    routes()[newName], routes()[old] = routes()[old], nil
    for map, name in pairs(character().lastByMap) do
        if name == old then character().lastByMap[map] = newName end
    end
    Clockwork.useRoute(newName)
end

function Clockwork.duplicateRoute(newName)
    local route = Clockwork.activeRoute()
    newName = newName and strtrim(newName) or ""
    if not route or newName == "" or routes()[newName] then return Clockwork.log.notice("Parcours : copie impossible") end
    local points = {}
    for _, point in ipairs(route.points) do table.insert(points, { point[1], point[2] }) end
    routes()[newName] = { map = route.map, loop = route.loop, points = points, updated = time() }
    Clockwork.useRoute(newName)
end

function Clockwork.deleteRoute()
    local name = Clockwork.activeRouteName()
    if not name then return end
    routes()[name] = nil
    for map, last in pairs(character().lastByMap) do
        if last == name then character().lastByMap[map] = nil end
    end
    Clockwork.useRoute(nil)
    Clockwork.log.notice("Parcours « " .. name .. " » supprimé")
end

local function edit(action)
    local route = Clockwork.activeRoute()
    if not route then return Clockwork.log.notice("Parcours : aucun parcours actif (en créer un dans le menu)") end
    action(route)
    route.updated = time()
    changed()
end

function Clockwork.addRoutePoint()
    edit(function(route)
        local x, y = playerOn(route)
        if not x then return Clockwork.log.notice("Parcours : tu n'es pas sur la carte de ce parcours (" .. mapName(route.map) .. ")") end
        if #route.points >= Clockwork.ROUTE_MAX_POINTS then
            return Clockwork.log.notice("Parcours : " .. Clockwork.ROUTE_MAX_POINTS .. " points au plus (place dans la grille)")
        end
        table.insert(route.points, { math.floor(x * 10000 + 0.5) / 10000, math.floor(y * 10000 + 0.5) / 10000 })
    end)
end

function Clockwork.undoRoutePoint()
    edit(function(route) table.remove(route.points) end)
end

function Clockwork.clearRoute()
    edit(function(route) route.points = {} end)
end

function Clockwork.reverseRoute()
    edit(function(route)
        local reversed = {}
        for index = #route.points, 1, -1 do table.insert(reversed, route.points[index]) end
        route.points = reversed
    end)
end

function Clockwork.toggleRouteLoop()
    edit(function(route) route.loop = not route.loop end)
end

-- --- Partage ---------------------------------------------------------------------------------------------------------

--- Texte d'un parcours : CW1;nom;carte;boucle;x,y;x,y;...
function Clockwork.exportRoute()
    local name, route = Clockwork.activeRouteName(), Clockwork.activeRoute()
    if not route then return nil end
    local parts = { "CW1", (name:gsub(";", ",")), tostring(route.map), route.loop and "1" or "0" }
    for _, point in ipairs(route.points) do
        table.insert(parts, string.format("%.4f,%.4f", point[1], point[2]))
    end
    return table.concat(parts, ";")
end

function Clockwork.importRoute(text)
    local fields = { strsplit(";", strtrim(text or "")) }
    if fields[1] ~= "CW1" or #fields < 4 then return Clockwork.log.notice("Parcours : texte non reconnu (export ClockWork attendu)") end
    local name, map = fields[2], tonumber(fields[3])
    if not map then return Clockwork.log.notice("Parcours : carte illisible") end
    while routes()[name] do name = name .. " (import)" end
    local points = {}
    for index = 5, #fields do
        local x, y = strsplit(",", fields[index])
        x, y = tonumber(x), tonumber(y)
        if x and y and #points < Clockwork.ROUTE_MAX_POINTS then table.insert(points, { x, y }) end
    end
    routes()[name] = { map = map, loop = fields[4] == "1", points = points, updated = time() }
    Clockwork.useRoute(name)
    Clockwork.log.notice("Parcours « " .. name .. " » importé : " .. #points .. " point(s) sur " .. mapName(map))
end

-- --- Changement de zone ----------------------------------------------------------------------------------------------

--- Nouvelle zone : le parcours actif est gardé tant que le joueur est sur sa carte ; sinon, le dernier utilisé sur la
--- nouvelle carte le remplace, et l'automate est coupé.
function Clockwork.onZoneChanged()
    local active = Clockwork.activeRoute()
    if active and playerOn(active) then return end
    local map = Clockwork.currentZoneMap()
    local next = map and character().lastByMap[map]
    if next and not routes()[next] then next = nil end
    if next == Clockwork.activeRouteName() then return end

    Clockwork.useRoute(next)
    if Clockwork.TOGGLE_ON_OFF then Clockwork:clickToggle() end
    if Clockwork.DRIVE_MOD then Clockwork:clickDrive() end
    Clockwork.log.notice("Changement de zone : parcours " .. (next and ("« " .. next .. " »") or "aucun") .. ", automate coupé")
end

-- --- Grille ----------------------------------------------------------------------------------------------------------

--- Cases des touches d'un bloc (mêmes formules que qrcode_v2.lua et QrCodeV2Reader) : les autres sont libres.
local function keyCells()
    local cells = {}
    local function mark(x, y) cells[x .. "," .. y] = true end
    for position = 1, 18 do
        if position <= 12 then mark(position + 1, 6); mark(position + 1, 9)
        else mark(position - 11, 12); mark(position - 5, 12) end
        if position <= 8 then mark(position + 2, 3)
        elseif position <= 12 then mark(position - 7, 7)
        elseif position <= 16 then mark(position - 11, 10)
        else mark(position - 9, 2) end
    end
    return cells
end

--- Cases libres des blocs 3 (0, 16) et 4 (16, 16), dans l'ordre de la grille.
function Clockwork.routeCellPositions()
    local used, positions = keyCells(), {}
    for _, block in ipairs({ { 0, 16 }, { 16, 16 } }) do
        for y = 1, 14 do
            for x = 1, 14 do
                if not used[x .. "," .. y] then table.insert(positions, { block[1] + x, block[2] + y }) end
            end
        end
    end
    return positions
end

function Clockwork:initRouteCells()
    for index, position in ipairs(Clockwork.routeCellPositions()) do
        routeCells[index] = self:createDot("route" .. index, position[1], -position[2])
    end
end

local function set24(cell, value)
    value = math.max(0, math.min(math.floor(value + 0.5), 16777215))
    cell.texture:SetColorTexture(math.floor(value / 65536) / 255, math.floor(value / 256) % 256 / 255, value % 256 / 255, 1)
end

function Clockwork:updateRouteCells()
    local route = Clockwork.activeRoute()
    for _, cell in ipairs(routeCells) do cell.texture:SetColorTexture(0, 0, 0, 1) end
    set24(routeCells[1], revision)
    if not route then return end

    local x, y = playerOn(route)
    set24(routeCells[2], route.map)
    routeCells[3].texture:SetColorTexture(#route.points / 255, route.loop and 1 or 0, x and 1 or 0, 1)
    set24(routeCells[4], (x or 0) * FRACTION)
    set24(routeCells[5], (y or 0) * FRACTION)
    for index, point in ipairs(route.points) do
        set24(routeCells[4 + index * 2], point[1] * FRACTION)
        set24(routeCells[5 + index * 2], point[2] * FRACTION)
    end
end

-- --- Fenêtres de saisie ----------------------------------------------------------------------------------------------

local function namePopup(key, title, action)
    StaticPopupDialogs[key] = {
        text = title,
        button1 = OKAY,
        button2 = CANCEL,
        hasEditBox = true,
        maxLetters = 0,
        OnAccept = function(dialog) action(dialog:GetEditBox():GetText()) end,
        EditBoxOnEnterPressed = function(editBox)
            action(editBox:GetText())
            editBox:GetParent():Hide()
        end,
        EditBoxOnEscapePressed = function(editBox) editBox:GetParent():Hide() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
end

namePopup("CLOCKWORK_ROUTE_NEW", "Nom du nouveau parcours (carte actuelle) :", Clockwork.newRoute)
namePopup("CLOCKWORK_ROUTE_RENAME", "Nouveau nom du parcours :", Clockwork.renameRoute)
namePopup("CLOCKWORK_ROUTE_DUPLICATE", "Nom de la copie :", Clockwork.duplicateRoute)
namePopup("CLOCKWORK_ROUTE_IMPORT", "Coller le texte exporté d'un parcours :", Clockwork.importRoute)

StaticPopupDialogs["CLOCKWORK_ROUTE_DELETE"] = {
    text = "Supprimer le parcours « %s » ?",
    button1 = DELETE,
    button2 = CANCEL,
    OnAccept = function() Clockwork.deleteRoute() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

--- Menu contextuel des parcours : choisir, créer, gérer, partager.
function Clockwork.showRouteMenu(owner)
    MenuUtil.CreateContextMenu(owner, function(_, root)
        root:CreateTitle("Parcours")
        local here = Clockwork.currentZoneMap()
        for _, name in ipairs(Clockwork.routeNames()) do
            local route = routes()[name]
            local label = name .. " (" .. #route.points .. " pt" .. (route.map ~= here and (", " .. mapName(route.map)) or "") .. ")"
            root:CreateRadio(label, function() return Clockwork.activeRouteName() == name end, function() Clockwork.useRoute(name) end)
        end
        root:CreateDivider()
        root:CreateButton("Nouveau...", function() StaticPopup_Show("CLOCKWORK_ROUTE_NEW") end)
        if Clockwork.activeRoute() then
            root:CreateButton("Renommer...", function() StaticPopup_Show("CLOCKWORK_ROUTE_RENAME") end)
            root:CreateButton("Dupliquer...", function() StaticPopup_Show("CLOCKWORK_ROUTE_DUPLICATE") end)
            root:CreateButton("Inverser le sens", Clockwork.reverseRoute)
            root:CreateButton("Exporter", function() Clockwork.showTextWindow(Clockwork.exportRoute()) end)
        end
        root:CreateButton("Importer...", function() StaticPopup_Show("CLOCKWORK_ROUTE_IMPORT") end)
        if Clockwork.activeRoute() then
            root:CreateDivider()
            root:CreateButton("|cffff4040Supprimer...|r", function() StaticPopup_Show("CLOCKWORK_ROUTE_DELETE", Clockwork.activeRouteName()) end)
        end
    end)
end

-- --- Carte du monde --------------------------------------------------------------------------------------------------

--- Le parcours actif dessiné sur la carte du monde quand elle affiche sa carte : points et tracé (premier point en vert).
--- La carte du monde peut être chargée après l'addon : tout est créé une fois Blizzard_WorldMap prêt.
local provider
local drawn = {}

local function installMapProvider()
    provider = CreateFromMixins(MapCanvasDataProviderMixin)

    function provider:RemoveAllData()
        for _, region in ipairs(drawn) do region:Hide() end
    end

    function provider:RefreshAllData()
        self:RemoveAllData()
        local map, route = self:GetMap(), Clockwork.activeRoute()
        if not route or #route.points == 0 or map:GetMapID() ~= route.map then return end

        local canvas = map:GetCanvas()
        local width, height = canvas:GetSize()
        local scale = 1 / map:GetCanvasScale()
        local used = 0
        local function region(kind)
            used = used + 1
            local existing = drawn[used]
            if existing and existing.kind == kind then existing:Show() return existing end
            local created = kind == "line" and canvas:CreateLine(nil, "OVERLAY") or canvas:CreateTexture(nil, "OVERLAY")
            created.kind = kind
            if existing then existing:Hide() end
            drawn[used] = created
            return created
        end

        local count = #route.points
        for index = 1, route.loop and count or count - 1 do
            local a, b = route.points[index], route.points[index % count + 1]
            local line = region("line")
            line:SetColorTexture(1, 0.82, 0, 0.8)
            line:SetThickness(3 * scale)
            line:SetStartPoint("TOPLEFT", canvas, a[1] * width, -a[2] * height)
            line:SetEndPoint("TOPLEFT", canvas, b[1] * width, -b[2] * height)
        end
        for index, point in ipairs(route.points) do
            local dot = region("dot")
            dot:SetColorTexture(index == 1 and 0.2 or 1, index == 1 and 1 or 0.6, 0.1, 1)
            dot:SetSize(8 * scale, 8 * scale)
            dot:ClearAllPoints()
            dot:SetPoint("CENTER", canvas, "TOPLEFT", point[1] * width, -point[2] * height)
        end
        for index = used + 1, #drawn do drawn[index]:Hide() end
    end

    function provider:OnMapChanged()
        self:RefreshAllData()
    end

    function provider:OnCanvasScaleChanged()
        self:RefreshAllData()
    end

    WorldMapFrame:AddDataProvider(provider)
end

function Clockwork.refreshRouteMap()
    if provider and WorldMapFrame:IsShown() then provider:RefreshAllData() end
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_WorldMap", installMapProvider)
