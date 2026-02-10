--- Reports all spells in the player's spellbook.
--- Generates Lua code for the player's spellbook and displays it.
--- @return nil
function Clockwork.reportAllSpells()
    -- Helper for Lua generation
    local function removeAccents(str)
        local accents = {
            ["à"] = "a", ["â"] = "a", ["ä"] = "a", ["é"] = "e", ["è"] = "e", ["ê"] = "e", ["ë"] = "e",
            ["î"] = "i", ["ï"] = "i", ["ô"] = "o", ["ö"] = "o", ["ù"] = "u", ["û"] = "u", ["ü"] = "u",
            ["ç"] = "c", ["À"] = "A", ["Â"] = "A", ["Ä"] = "A", ["É"] = "E", ["È"] = "E", ["Ê"] = "E",
            ["Ë"] = "E", ["Î"] = "I", ["Ï"] = "I", ["Ô"] = "O", ["Ö"] = "O", ["Ù"] = "U", ["Û"] = "U", ["Ü"] = "U", ["Ç"] = "C"
        }
        for k, v in pairs(accents) do
            str = string.gsub(str, k, v)
        end
        return str
    end

    local output = ""
    local _, classFilename = UnitClass("player")
    output = output .. "    " .. classFilename .. " = {\n"

    local index = 1
    local seenIds = {}

    while true do
        -- /dump C_SpellBook.GetSpellBookItemInfo(6, Enum.SpellBookSpellBank.Player)
        local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(index, Enum.SpellBookSpellBank.Player)

        if not spellBookItemInfo then break end

        local spellID = spellBookItemInfo.spellID
        local spellName = spellBookItemInfo.name

        if spellName and spellID and not seenIds[spellID] then
            if not Clockwork.emptyOrNil(spellBookItemInfo.skillLineIndex) and spellBookItemInfo.skillLineIndex < 6 then
                if spellBookItemInfo.itemType == Enum.SpellBookItemType.Spell or spellBookItemInfo.itemType == Enum.SpellBookItemType.FutureSpell then
                    local keyName = removeAccents(spellName)
                    keyName = string.upper(keyName)
                    keyName = string.gsub(keyName, "[^A-Z0-9]", "_")
                    keyName = string.gsub(keyName, "_+", "_")
                    keyName = string.gsub(keyName, "^_", "")
                    keyName = string.gsub(keyName, "_$", "")

                    local key = keyName .. "_" .. spellID

                    output = output .. "        " .. key .. " = {\n"
                    output = output .. "            name = \"" .. spellName .. "\",\n"
                    output = output .. "            id = " .. spellID .. ",\n"
                    output = output .. "        },\n"

                    seenIds[spellID] = true
                end
            end
        end
        index = index + 1
    end

    output = output .. "    },"
    Clockwork.showTextWindow(output)
end

--- Reports information about all action buttons.
--- @return nil
function Clockwork.reportActionButtons()
    local output = ""

    for actionSlot = 1, 180 do
        local actionType, id, subType = GetActionInfo(actionSlot);

        if id then
            local spellInfo = C_Spell.GetSpellInfo(id)
            local message = "Slot:" .. actionSlot .. ", id:" .. id;

            if spellInfo then
                message = message .. ", Spell ID:" .. spellInfo.spellID .. ", name:\"" .. spellInfo.name .. "\"";
            end

            output = output .. message .. "\n"
        end
    end
    Clockwork.showTextWindow(output)
end

--- Reports all key bindings.
--- @return nil
function Clockwork.reportBindings()
    Clockwork.log.info("function Clockwork.reportBindings()")

    for command, binding in pairs(Clockwork.getCommandBindingMap()) do
        Clockwork.log.info("Command: " .. command .. " Key:" .. tostring(binding.toString))
    end
end

--- Reports the current binding configuration.
--- @return nil
function Clockwork.reportCurrentBindingConfig()

    local sortedSpellIdactionSlotMap = {}
    for key, value in pairs(Clockwork.spellIdactionSlotMap) do
      table.insert(sortedSpellIdactionSlotMap, { spellId = key, action = value })
    end
    
    table.sort(sortedSpellIdactionSlotMap, function(a, b)
      return a.action.slot < b.action.slot -- Sort by slot
    end)

    for _, item in pairs(sortedSpellIdactionSlotMap) do
        local command = Clockwork.getActionSlotCommand(item.action.slot)
        if command then
            local binding = Clockwork.commandBindingMap[command]
            if binding then
                Clockwork.log.info(
                 "Command: " .. command ..
                    " Binding:" .. binding.toString ..
                    " Spell:" .. item.action.name .. " (" .. item.spellId .. ")" ..
                    " Slot:" .. item.action.slot)
            end
        end
    end
end

--- Reports bindings associated with specific keys.
--- @return nil
function Clockwork.reportBindingsByKeys()
    Clockwork.log.info("Q")
    Clockwork.log.dump(GetBindingByKey("Q"))
    Clockwork.log.info("T")
    Clockwork.log.dump(GetBindingByKey("T"))
    Clockwork.log.info("D")
    Clockwork.log.dump(GetBindingByKey("D"))
    Clockwork.log.info("F")
    Clockwork.log.dump(GetBindingByKey("F"))
    Clockwork.log.info("G")
    Clockwork.log.dump(GetBindingByKey("G"))
    Clockwork.log.info("R")
    Clockwork.log.dump(GetBindingByKey("R"))
    Clockwork.log.info("W")
    Clockwork.log.dump(GetBindingByKey("W"))
    Clockwork.log.info("Y")
    Clockwork.log.dump(GetBindingByKey("Y"))
end

--- Reports the player's current coordinates.
--- @return nil
function Clockwork.getCoord()
    -- Clockwork.log.debug("function getCoord(")

    local map = C_Map.GetBestMapForUnit("player")
    Clockwork.log.info("Map : " .. tostring(map))
    if map == nil then
        Clockwork.log.info("Not outdoor")
        return
    end
    local position = C_Map.GetPlayerMapPosition(map, "player");

    if position == nil then
        Clockwork.log.info("No position")
        return
    end

    local posX = tostring(position["x"])
    local posY = tostring(position["y"])

    local posXString = tostring(posX)
    local posYString = tostring(posY)

    Clockwork.log.info("x = " .. posXString)
    Clockwork.log.info("y = " .. posYString)
end

function Clockwork.showTextWindow(text)
    local f = Clockwork_ExportFrame or CreateFrame("Frame", "Clockwork_ExportFrame", UIParent, "DialogBoxFrame")
    f:SetSize(700, 500)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")

    if not f.scrollArea then
        f.scrollArea = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        f.scrollArea:SetPoint("TOPLEFT", 20, -30)
        f.scrollArea:SetPoint("BOTTOMRIGHT", -30, 40)

        f.editBox = CreateFrame("EditBox", nil, f.scrollArea)
        f.editBox:SetMultiLine(true)
        f.editBox:SetFontObject(ChatFontNormal)
        f.editBox:SetWidth(650)
        f.scrollArea:SetScrollChild(f.editBox)

        f.close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.close:SetPoint("BOTTOM", 0, 10)
        f.close:SetSize(100, 25)
        f.close:SetText("Close")
        f.close:SetScript("OnClick", function() f:Hide() end)
    end

    f.editBox:SetText(text)
    f.editBox:HighlightText()
    f:Show()
end
