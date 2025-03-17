---@alias SHIFT 927620
Clockwork.SHIFT = 927620
---@alias CTRL 519254
Clockwork.CTRL = 519254
---@alias ALT 919836
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

---@param params {actionParameters:{key:string, shift:boolean, alt:boolean, ctrl:boolean},priority:number, duration:number|nil}
---@param keyModificator SHIFT|ALT|CTRL|nil
---@return nil
function Clockwork:hitKeyWithModifier(params, keyModificator)
    --Clockwork.log.debug("function Clockwork.shouldHitKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot) .. ", " .. tostring(modificator))

    Clockwork.log.debug("Hit \"" .. tostring(params.actionParameters.key) .. "\" with mod " .. tostring(keyModificator))

    -- Mode octal
    -- CTRL  = 1
    -- ALT   = 2
    -- SHIFT = 4

    local sum = 0 +
        Clockwork.ternary(keyModificator == Clockwork.CTRL, 1, 0) +
        Clockwork.ternary(keyModificator == Clockwork.ALT, 2, 0) +
        Clockwork.ternary(keyModificator == Clockwork.SHIFT, 4, 0)


    local duration = Clockwork.ternary(params.duration == nil, 0, params.duration)

    Clockwork.keys[params.actionParameters.key].texture:SetColorTexture(sum / 255, params.priority / 255, duration / 30, 1)
end

---Function to find the shortcut key for a specific action slot and parse modifiers.
---@param actionSlot number
---@return {key:string, shift:boolean, alt:boolean, ctrl:boolean}|nil, string|nil
function Clockwork.getActionSlotBinding(actionSlot)
    if not actionSlot or type(actionSlot) ~= "number" then
        return nil, "Invalid action slot."
    end

    local internalSlot = actionSlot - 1;

    if internalSlot < 0 or internalSlot >= 120 then
        return nil, "Action slot out of range."
    end

    local binding = GetBindingKey("ACTIONBUTTON" .. actionSlot);

    if not binding or binding == "" then
        return nil, "No shortcut assigned to this slot."
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

    return {
        key = key,
        shift = shift ~= nil,
        alt = alt ~= nil,
        ctrl = ctrl ~= nil,
    };
end

---@return {key:string, spellId:number, slot:number, shift:boolean, alt:boolean, ctrl:boolean}[]
function Clockwork:createAllActionSlotBindings()
    local bindings = {};

    for i = 1, 120 do
        local binding, errorMessage = self.getActionSlotBinding(i);
        Clockwork.log.info("Action slot " .. i .. " binding: " .. tostring(binding))
        local actionType, id, subType = GetActionInfo(i)

        if binding then
            bindings[i] = {
                key = binding.key,
                shift = binding.shift,
                alt = binding.alt,
                ctrl = binding.ctrl,
                spellId = id,
                slot = i
            };
        else
            -- If you want to store slots with no bindings, you may want to insert a nil or an object with nil values
            --table.insert(bindings, nil);
            bindings[i] = { key = nil, spellId = nil, shift = false, alt = false, ctrl = false };
        end
    end

    self.actionSlotBindings = bindings
    return bindings;
end

---@return nil
function Clockwork:createSpellIdToSlotLookup()
    if not self.actionSlotBindings then
        self:createAllActionSlotBindings()
    end

    for i, binding in ipairs(self.actionSlotBindings) do
        if binding.spellId then
            self.spellIdToSlot[binding.spellId] = i
        end
    end
end

---@param spellId number
---@return {key:string, spellId:number, slot:number, shift:boolean, alt:boolean, ctrl:boolean}|nil
function Clockwork:getBindingForSpellId(spellId)
    if next(self.spellIdToSlot) == nil then
        self:createSpellIdToSlotLookup()
    end

    local slotNumber = self.spellIdToSlot[spellId]

    if slotNumber then
        return self.actionSlotBindings[slotNumber]
    else
        return nil
    end
end

---@param key string
---@param shift boolean
---@param alt boolean
---@param ctrl boolean
---@return number|nil, string|nil
function Clockwork:findActionSlotByKeyAndModifiers(key, shift, alt, ctrl)
    if (Clockwork.actionSlotBindings == nil) then
        self:createAllActionSlotBindings()
    end

    if not self.actionSlotBindings then
        return nil, "Could not retrieve bindings.";
    end

    for slotNumber, binding in pairs(self.actionSlotBindings) do
        if binding then
            if binding.key == key and binding.shift == shift and binding.alt == alt and binding.ctrl == ctrl then
                return slotNumber; -- Found the slot!
            end
        end
    end

    return nil, "No matching slot found."; -- No matching slot
end
