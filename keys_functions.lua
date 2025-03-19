---@alias SHIFT 927620
---@type SHIFT
Clockwork.SHIFT = 927620
---@alias CTRL 519254
---@type CTRL
Clockwork.CTRL = 519254
---@alias ALT 919836
---@type ALT
Clockwork.ALT = 919836

function Clockwork:initKeys()
    self.keys = {}
    -- Clockwork.log.debug("function Clockwork.initKeys(")

    --Clockwork.keys["Maj"] = self:createDot("Clockwork.keys["Maj","] 2, -2)
    --Clockwork.keys["Ctrl"] = self:createDot("Clockwork.keys["Ctrl","] 3, -2)
    --Clockwork.keys["Alt"] = self:createDot("Clockwork.keys["Alt","] 4, -2)

    self.keys["Q"] = self:createDot("Q", 2, -4)
    self.keys["D"] = self:createDot("D", 3, -4)
    self.keys["R"] = self:createDot("R", 4, -4)
    self.keys["T"] = self:createDot("T", 5, -4)
    self.keys["F"] = self:createDot("F", 6, -4)
    self.keys["G"] = self:createDot("G", 7, -4)
    self.keys["1"] = self:createDot("1", 2, -5)
    self.keys["2"] = self:createDot("2", 3, -5)
    self.keys["3"] = self:createDot("3", 4, -5)
    self.keys["4"] = self:createDot("4", 5, -5)
    self.keys["5"] = self:createDot("5", 6, -5)
    self.keys["6"] = self:createDot("6", 7, -5)
    self.keys["7"] = self:createDot("7", 8, -5)
    self.keys["8"] = self:createDot("8", 9, -5)
    self.keys["9"] = self:createDot("9", 10, -5)
    self.keys["0"] = self:createDot("0", 11, -5)
    self.keys[")"] = self:createDot(")", 12, -5)
    self.keys["="] = self:createDot("=", 13, -5)
end

function Clockwork:resetKeys()
    -- Clockwork.log.debug("function Clockwork.resetKeys(")

    self.keys["Q"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["D"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["R"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["T"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["F"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["G"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["="].texture:SetColorTexture(0, 0, 0, 1)
    self.keys[")"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["0"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["9"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["8"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["7"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["6"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["5"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["4"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["3"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["2"].texture:SetColorTexture(0, 0, 0, 1)
    self.keys["1"].texture:SetColorTexture(0, 0, 0, 1)
end

---@param params {key:string,priority:number, duration:number|nil}
---@param keyModificator SHIFT|ALT|CTRL|nil
---@return nil
function Clockwork:hitKeyWithModifier(params, keyModificator)
    --Clockwork.log.debug("function Clockwork.shouldHitKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot) .. ", " .. tostring(modificator))

    Clockwork.log.debug("Hit \"" .. tostring(params.key) .. "\" with mod " .. tostring(keyModificator))

    -- Mode octal
    -- CTRL  = 1
    -- ALT   = 2
    -- SHIFT = 4

    local sum = 0 +
        Clockwork.ternary(keyModificator == Clockwork.CTRL, 1, 0) +
        Clockwork.ternary(keyModificator == Clockwork.ALT, 2, 0) +
        Clockwork.ternary(keyModificator == Clockwork.SHIFT, 4, 0)


    local duration = Clockwork.ternary(params.duration == nil, 0, params.duration)

    Clockwork.keys[params.key].texture:SetColorTexture(sum / 255, params.priority / 255, duration / 30, 1)
end

-- | Binding |       Spell        | Action                 | Slot | Shape       |
-- | :-----: | :----------------: | ---------------------- | ---- | ----------- |
-- |    1    |      Balayage      | ACTIONBUTTON1          | 1    | Voyage(3)   |
-- |    1    |                    | ACTIONBUTTON1          | 13   | Second Page |
-- |    Y    |      Sarments      | MULTIACTIONBAR3BUTTON1 | 25   |             |
-- |    W    |     Mutilation     | MULTIACTIONBAR4BUTTON1 | 37   |             |
-- |    T    |       Colère       | MULTIACTIONBAR2BUTTON1 | 49   |             |
-- |    Q    |      Célérité      | MULTIACTIONBAR1BUTTON1 | 61   |             |
-- |    1    |      Lambeau       | ACTIONBUTTON1          | 73   | Félin(2)    |
-- |         |   Rétablissement   |                        | 85   |             |
-- |    1    |     Grondement     | ACTIONBUTTON1          | 97   | Ours(1)     |
-- |    1    |  Marque du fauve   | ACTIONBUTTON1          | 109  | Sélénien(4) |
-- |         |                    |                        | 121  |             |
-- |         |                    |                        | 133  |             |
-- |    G    |   Feu stellaire    | MULTIACTIONBAR5BUTTON1 | 145  |             |
-- |    F    | Eruption stellaire | MULTIACTIONBAR6BUTTON1 | 157  |             |
-- |    D    |   Eclat lunaire    | MULTIACTIONBAR7BUTTON1 | 169  |             |

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

    local shift = binding:match("^SHIFT%-")
    if shift then
        binding = binding:sub(7) -- Remove "SHIFT-" from the binding
    end

    local alt = binding:match("^ALT%-")
    if alt then
        binding = binding:sub(5) -- Remove "ALT-" from the binding
    end

    local ctrl = binding:match("^CTRL%-")
    if ctrl then
        binding = binding:sub(6) -- Remove "CTRL-" from the binding
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

---@return {name:string, slot:number}[]
function Clockwork.getSpellIdActionSlotMap()
    local spells = {}

    for actionSlot = 1, 180 do
        local actionType, id, subType = GetActionInfo(actionSlot);

        if id then
            local spellInfo = C_Spell.GetSpellInfo(id)

            if spellInfo then
                spells[spellInfo.spellID] = { name = spellInfo.name, slot = actionSlot }
            end
        end
    end
    return spells
end

---@return {slot:number, key:string, shift:string, alt:string, ctrl:string}|nil, nil|string
function Clockwork:getActionSlotAndBindingForSpell(spellID)
    local spell = self.spellIdactionSlotMap[spellID]
    if spell.slot == nil then return nil, "Spell not found" end
    local command = Clockwork.getActionSlotCommand(spell.slot)
    if command == nil then return nil, "No command found." end
    local binding = self.commandBindingMap[command]
    if binding == nil then return nil, "No Binding found." end
    return { slot = spell.slot, key = binding.key, shift = binding.shift, alt = binding.alt, ctrl = binding.ctrl }
end

function Clockwork.getActionSlotCommand(actionSlot)
    local button, bar = Clockwork.modulo(actionSlot)
    local keyString = ""

    -- actionSlot >= 13 and actionSlot < 25 or     -- Secondary page
    local shapeIndex = GetShapeshiftForm()
    if actionSlot < 13 and (shapeIndex == 0 or (Clockwork.player.class.classFilename == "DRUID" and shapeIndex == 3)) then -- Stance 3 (Voyage)
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

---@return {name:string, slot:number}[]
function Clockwork:updateActionSlotSpells()
    self.spellIdactionSlotMap = self:getSpellIdActionSlotMap()
    return self.spellIdactionSlotMap;
end

function Clockwork:updateBindings()
    self:updateCommandBindingMap()
    self:updateActionSlotSpells()
end

---@param key string
---@param shift boolean
---@param alt boolean
---@param ctrl boolean
---@return number|nil, string|nil
function Clockwork:findActionSlotByKeyAndModifiers(key, shift, alt, ctrl)
    if (Clockwork.commandsBindings == nil) then
        self:updateCommandBindingMap()
    end

    if not self.commandsBindings then
        return nil, "Could not retrieve bindings.";
    end

    for slotNumber, binding in pairs(self.commandsBindings) do
        if binding then
            if binding.key == key and binding.shift == shift and binding.alt == alt and binding.ctrl == ctrl then
                return slotNumber; -- Found the slot!
            end
        end
    end

    return nil, "No matching slot found."; -- No matching slot
end
