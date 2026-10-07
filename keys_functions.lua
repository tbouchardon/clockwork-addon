-- Raccourcis des barres d'action : quelle combinaison de touches déclenche chaque emplacement de barre. La grille
-- (qrcode_v2.lua, buildKeySlotMap) s'en sert pour décrire le sort ou l'objet de chaque touche.

---Function to find the shortcut key for a specific action slot and parse modifiers.
---@param command string
---@return {key:string, shift:boolean, alt:boolean, ctrl:boolean, toString:string}|nil, string|nil
function Clockwork.getActionSlotBinding(command)
    if not command or type(command) ~= "string" then
        return nil, "Invalid command."
    end

    local binding = GetBindingKey(command);

    if not binding or binding == "" then
        return nil, "No shortcut assigned to this command."
    end

    local ctrl = binding:match("^CTRL%-")
    if ctrl then
        binding = binding:sub(6) -- Remove "CTRL-" from the binding
    end

    local alt = binding:match("^ALT%-")
    if alt then
        binding = binding:sub(5) -- Remove "ALT-" from the binding
    end

    local shift = binding:match("^SHIFT%-")
    if shift then
        binding = binding:sub(7) -- Remove "SHIFT-" from the binding
    end

    local key = binding -- The remaining part is the key

    local combinaison = {}
    if shift ~= nil then
        table.insert(combinaison, "Shift")
    end
    if alt ~= nil then
        table.insert(combinaison, "Alt")
    end
    if ctrl ~= nil then
        table.insert(combinaison, "Ctrl")
    end
    table.insert(combinaison, key)
    local modifiersString = table.concat(combinaison, "-")

    return {
        key = key,
        shift = shift ~= nil,
        alt = alt ~= nil,
        ctrl = ctrl ~= nil,
        toString = modifiersString
    };
end

---@return {key:string, shift:boolean, alt:boolean, ctrl:boolean, toString:string}[]
function Clockwork.getCommandBindingMap()
    local bindings = {}
    local keyString = ""

    for button = 1, 12 do
        keyString = "ACTIONBUTTON" .. button
        local binding = Clockwork.getActionSlotBinding(keyString)
        if binding ~= nil then bindings[keyString] = binding end
    end

    for bar = 1, 7 do
        for button = 1, 12 do
            keyString = "MULTIACTIONBAR" .. bar .. "BUTTON" .. button
            local binding = Clockwork.getActionSlotBinding(keyString)
            if binding ~= nil then bindings[keyString] = binding end
        end
    end

    return bindings
end

---@param actionSlot number
---@return string|nil, string|nil
function Clockwork.getActionSlotCommand(actionSlot)
    local button, bar = Clockwork.modulo(actionSlot)
    local keyString = ""

    -- actionSlot >= 13 and actionSlot < 25 or     -- Secondary page
    local shapeIndex = GetShapeshiftForm()
    if actionSlot < 13 or (Clockwork.player.class.classFilename == "DRUID" and shapeIndex == 3) then -- Stance 3 (Voyage)
        keyString = "ACTIONBUTTON" .. button
    elseif actionSlot >= 25 and actionSlot < 37 then
        keyString = "MULTIACTIONBAR" .. "3" .. "BUTTON" .. button
    elseif actionSlot >= 37 and actionSlot < 49 then
        keyString = "MULTIACTIONBAR" .. "4" .. "BUTTON" .. button
    elseif actionSlot >= 49 and actionSlot < 61 then
        keyString = "MULTIACTIONBAR" .. "2" .. "BUTTON" .. button
    elseif actionSlot >= 61 and actionSlot < 73 then
        keyString = "MULTIACTIONBAR" .. "1" .. "BUTTON" .. button
    elseif actionSlot >= 73 and actionSlot < 85 and Clockwork.player.class.classFilename == "DRUID" and shapeIndex == 2 then   -- Stance 2 (Félin)
        keyString = "ACTIONBUTTON" .. button
    elseif actionSlot >= 97 and actionSlot < 109 and Clockwork.player.class.classFilename == "DRUID" and shapeIndex == 1 then  -- Stance 1 (Ours)
        keyString = "ACTIONBUTTON" .. button
    elseif actionSlot >= 109 and actionSlot < 121 and Clockwork.player.class.classFilename == "DRUID" and shapeIndex == 4 then -- Stance 4 (Sélénien)
        keyString = "ACTIONBUTTON" .. button
    elseif actionSlot >= 145 and actionSlot < 157 then
        keyString = "MULTIACTIONBAR" .. "5" .. "BUTTON" .. button
    elseif actionSlot >= 157 and actionSlot < 169 then
        keyString = "MULTIACTIONBAR" .. "6" .. "BUTTON" .. button
    elseif actionSlot >= 169 and actionSlot < 181 then
        keyString = "MULTIACTIONBAR" .. "7" .. "BUTTON" .. button
    else
        return nil, "Action slot not found."
    end

    return keyString
end

---@return {key:string, spellId:number, slot:number, shift:boolean, alt:boolean, ctrl:boolean}[]
function Clockwork:updateCommandBindingMap()
    self.commandBindingMap = self:getCommandBindingMap()
    return self.commandBindingMap;
end

--- Raccourcis, barres ou forme changés : la table des raccourcis est reconstruite.
function Clockwork:updateBindings()
    self:updateCommandBindingMap()
end
