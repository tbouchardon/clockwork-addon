function Clockwork.printDebug(text)

    -- Clockwork.printDebug("function Clockwork.printDebug(" .. tostring(text))

    if Clockwork.DEBUG_MOD then

        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r \124cFF8eacbb(Debug)\124r: " .. tostring(text))
    end
end

function Clockwork.listAllSpells()

    -- Clockwork.printDebug("function Clockwork.listAllSpells(")

    Clockwork.printDebug("Clockwork.listAllSpells()")

    if Clockwork.DEBUG_MOD then

        local index = 1;

        while true do
            local spellName, spellSubName, spellID = C_SpellBook.GetSpellBookItemName(index, Enum.SpellBookSpellBank.Player);

            if not spellName then
                do
                    break
                end
            end

            if (spellSubName and string.find(spellSubName, "Rank")) then
                local rank = strsub(spellSubName, 6, strlen(spellSubName));
                Clockwork.printDebug("Spell : id=" .. tostring(spellID) .. ", name=" .. spellName .. ", rank=" .. rank);
            else
                Clockwork.printDebug("Spell : id=" .. tostring(spellID) .. ", name=" .. spellName);
            end

            index = index + 1;
        end
    end
end

function Clockwork.reportActionButtons()

    -- Clockwork.printDebug("function Clockwork.reportActionButtons(")

    for actionSlot = 1, 120 do

        local actionText = GetActionText(actionSlot);
        local actionTexture = GetActionTexture(actionSlot);

        if actionTexture then

            local message = "Slot " .. actionSlot .. " : [" .. actionTexture .. "]";

            if actionText then

                message = message .. " \"" .. actionText .. "\"";
            end

            Clockwork.printDebug(message);
        end
    end
end

function Clockwork.getCoord()

    -- Clockwork.printDebug("function getCoord(")

    local map = C_Map.GetBestMapForUnit("player")
    Clockwork.log.notice("Map : " .. tostring(map))
    if map == nil then
        Clockwork.log.notice("Not outdoor")
        return
    end
    local position = C_Map.GetPlayerMapPosition(map, "player");

    if position == nil then
        Clockwork.log.notice("No position")
        return
    end

    local posX = tostring(position["x"])
    local posY = tostring(position["y"])

    local posXString = tostring(posX)
    local posYString = tostring(posY)

    Clockwork.log.notice("x = " .. posXString)
    Clockwork.log.notice("y = " .. posYString)
end