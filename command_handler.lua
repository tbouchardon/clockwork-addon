--Chat commands

function Clockwork:commandHandler(msg)
    -- Clockwork.log.debug("local function commandHandler(" .. tostring(msg))

    Clockwork.log.debug("Command Handler")

    Clockwork.log.debug("msg : " .. tostring(msg))
    local command, argument = (msg or ""):match("^(%S*)%s*(.-)$")
    if msg == 'toggle' then
        self:clickToggle()
    elseif (msg == 'tne') then
        self:clickTNE()
    elseif command == 'route' then
        self:routeCommand(argument)
    elseif command == 'wp' then
        if argument == 'add' then Clockwork.addRoutePoint()
        elseif argument == 'undo' then Clockwork.undoRoutePoint()
        elseif argument == 'clear' then Clockwork.clearRoute()
        else Clockwork.log.notice("/clk wp add | undo | clear") end
    elseif (msg == 'aggro') then
        self:clickAggro()
    elseif (msg == 'fish') then
        self:clickFish()
    elseif (msg == 'healer') then
        self:clickHealer()
    elseif (msg == 'loot') then
        self:clickLoot()
    elseif (msg == 'multi') then
        self:clickMulti()
    elseif (msg == 'drive') then
        self:clickDrive()
    elseif (msg == 'debug') then
        self:clickDebug()
    elseif (msg == 'list actions') then
        self:reportActionButtons()
    elseif (msg == 'list bindings') then
        self:reportBindings()
    elseif (msg == 'testsecret') then
        Clockwork.testSecrets()
    elseif (msg == 'errors') then
        Clockwork.showTextWindow(Clockwork.guardReport())
    elseif (msg == 'errors reset') then
        Clockwork.guardReset()
        Clockwork.log.notice("Compteurs d'erreurs remis à zéro")
    else
        Clockwork.log.notice("------------ Clockwork ------------")
        Clockwork.log.notice("/clockWork toggle         -- Turn Clockwork On [Blush]/Off")
        Clockwork.log.notice("/clockWork tne            -- Target Nearest Enemy : On/Off")
        Clockwork.log.notice("/clockWork route ...      -- Parcours : new, use, rename, delete, loop, reverse, list, export, import")
        Clockwork.log.notice("/clockWork wp add|undo|clear -- Points du parcours actif")
        Clockwork.log.notice("/clockWork aggro          -- Aggro : On/Off")
        Clockwork.log.notice("/clockWork fish           -- Pêche automatique : On/Off")
        Clockwork.log.notice("/clockWork healer         -- Mode soigneur (soigner les autres membres) : On/Off")
        Clockwork.log.notice("/clockWork multi          -- Mode multi-cibles (DoT répartis, sorts de zone) : On/Off")
        Clockwork.log.notice("/clockWork drive          -- Start Autopilote")
        Clockwork.log.notice("/clockWork loot           -- Ramassage du butin après combat : On/Off")
        Clockwork.log.notice("/clockWork debug          -- Debug Mod : On/Off")
        Clockwork.log.notice("/clockWork testsecret     -- Tester les valeurs secrètes (à lancer en combat)")
        Clockwork.log.notice("/clockWork errors [reset] -- Blocs du QR code en erreur")
        Clockwork.log.notice("Debug : ")
        if Clockwork.DEBUG_MOD then Clockwork.log.notice("/clockWork list actions   -- List all actions slots") end
        if Clockwork.DEBUG_MOD then Clockwork.log.notice("/clockWork list bindings  -- List all bindings") end
    end
end

SlashCmdList['CLOCKWORK_SLASHCMD'] = function (...) Clockwork.commandHandler(Clockwork, ...) end
SLASH_CLOCKWORK_SLASHCMD1 = '/clockwork'
SLASH_CLOCKWORK_SLASHCMD2 = '/clk'

function Clockwork:clickToggle()
    if Clockwork.TOGGLE_ON_OFF == false then
        Clockwork.TOGGLE_ON_OFF = true
        self.toggle.texture:SetColorTexture(1, 1, 1, 1)
        self.onOff:Hide()
        Clockwork.log.notice("On")
    else
        Clockwork.TOGGLE_ON_OFF = false
        self.toggle.texture:SetColorTexture(0, 0, 0, 1)
        self.onOff:Show()
        Clockwork.log.notice("Off")
    end
end

function Clockwork:clickTNE()
    if Clockwork.TARGET_NEAREST_ENEMY == false then
        Clockwork.TARGET_NEAREST_ENEMY = true
        self.targetNearestEnemy.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.log.notice("Target Nearest Enemy : On")
    else
        Clockwork.TARGET_NEAREST_ENEMY = false
        Clockwork.targetNearestEnemy.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Target Nearest Enemy : Off")
    end
end

--- /clk route ... : parcours du pilote automatique (routes.lua).
function Clockwork:routeCommand(argument)
    local action, name = argument:match("^(%S*)%s*(.-)$")
    if action == 'new' then Clockwork.newRoute(name)
    elseif action == 'use' then
        if CLOCKWORK_ROUTES and CLOCKWORK_ROUTES[name] then Clockwork.useRoute(name) else Clockwork.log.notice("Parcours inconnu : " .. name) end
    elseif action == 'rename' then Clockwork.renameRoute(name)
    elseif action == 'delete' then StaticPopup_Show("CLOCKWORK_ROUTE_DELETE", Clockwork.activeRouteName())
    elseif action == 'loop' then Clockwork.toggleRouteLoop()
    elseif action == 'reverse' then Clockwork.reverseRoute()
    elseif action == 'export' then Clockwork.showTextWindow(Clockwork.exportRoute() or "Aucun parcours actif")
    elseif action == 'import' then Clockwork.importRoute(name)
    elseif action == 'list' then
        for _, routeName in ipairs(Clockwork.routeNames()) do
            local route = CLOCKWORK_ROUTES[routeName]
            Clockwork.log.notice((routeName == Clockwork.activeRouteName() and "> " or "  ") .. routeName .. " : " .. #route.points .. " point(s)")
        end
    else
        Clockwork.log.notice("/clk route new <nom> | use <nom> | rename <nom> | delete | loop | reverse | list | export | import <texte>")
    end
end

--- Aggro : attaquer aussi une cible qui n'est pas encore en combat (lu par le Java en (10, 2)).
function Clockwork:clickAggro()
    Clockwork.AGGRO_MOD = not Clockwork.AGGRO_MOD
    Clockwork.log.notice("Aggro : " .. (Clockwork.AGGRO_MOD and "On" or "Off"))
end

--- Multi-cibles : les rotations répartissent leurs DoT et utilisent leurs sorts de zone (lu par le Java en (10, 2)).
function Clockwork:clickMulti()
    Clockwork.MULTI_MOD = not Clockwork.MULTI_MOD
    Clockwork.log.notice("Multi-cibles : " .. (Clockwork.MULTI_MOD and "On" or "Off"))
end

--- Pêche : le Java lance la ligne et ferre tant que la case (12, 4) est allumée. Bouger la souris l'arrête aussi.
function Clockwork:clickFish()
    Clockwork.FISH_MOD = not Clockwork.FISH_MOD
    self.fish.texture:SetColorTexture(Clockwork.FISH_MOD and 1 or 0, Clockwork.FISH_MOD and 1 or 0, Clockwork.FISH_MOD and 1 or 0, 1)
    Clockwork.log.notice("Pêche : " .. (Clockwork.FISH_MOD and "On" or "Off"))
end

function Clockwork:clickDrive()
    if Clockwork.DRIVE_MOD == false then
        Clockwork.DRIVE_MOD = true
        self.drive.texture:SetColorTexture(1, 1, 1, 1)
        Clockwork.log.notice("Drive Mod : On")
    else
        Clockwork.DRIVE_MOD = false
        self.drive.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Drive Mod : Off")
    end
end

function Clockwork:clickDebug()
    if Clockwork.DEBUG_MOD == false then
        Clockwork.DEBUG_MOD = true
        Clockwork.LOG_LEVEL = 'DEBUG'
        self.debug.texture:SetColorTexture(1, 0, 0, 1)
        Clockwork.log.notice("Debug Mod : On")
        Clockwork.log.debug("UnitClass : " .. UnitClass("player"))
    else
        Clockwork.DEBUG_MOD = false
        Clockwork.LOG_LEVEL = 'NOTICE'
        self.debug.texture:SetColorTexture(0, 0, 0, 1)
        Clockwork.log.notice("Debug Mod : Off")
    end
end
