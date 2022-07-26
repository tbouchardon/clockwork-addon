function clockWork.printDebug(text)

    -- clockWork.printDebug("function clockWork.printDebug(" .. tostring(text))

    if clockWork.DEBUG_MOD then

        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r \124cFF8eacbb(Debug)\124r: " .. tostring(text))
    end
end

function clockWork.listAllSpells()

    -- clockWork.printDebug("function clockWork.listAllSpells(")

    clockWork.printDebug("clockWork.listAllSpells()")

    if clockWork.DEBUG_MOD then

        local index = 1;

        while true do
            local spellName, spellSubName, spellID = GetSpellBookItemName(index, BOOKTYPE_SPELL);

            if not spellName then
                do
                    break
                end
            end

            if (spellSubName and string.find(spellSubName, "Rank")) then
                local rank = strsub(spellSubName, 6, strlen(spellSubName));
                clockWork.printDebug("Spell : id=" .. tostring(spellID) .. ", name=" .. spellName .. ", rank=" .. rank);
            else
                clockWork.printDebug("Spell : id=" .. tostring(spellID) .. ", name=" .. spellName);
            end

            index = index + 1;
        end
    end
end

function clockWork.reportActionButtons()

    -- clockWork.printDebug("function clockWork.reportActionButtons(")

    for actionSlot = 1, 120 do

        local actionText = GetActionText(actionSlot);
        local actionTexture = GetActionTexture(actionSlot);

        if actionTexture then

            local message = "Slot " .. actionSlot .. " : [" .. actionTexture .. "]";

            if actionText then

                message = message .. " \"" .. actionText .. "\"";
            end

            clockWork.printDebug(message);
        end
    end
end

function getCoord()

    -- clockWork.printDebug("function getCoord(")

    local map = C_Map.GetBestMapForUnit("player")
    clockWork.print("Map : " .. tostring(map))
    if map == nil then
        clockWork.print("Not outdoor")
    end
    local position = C_Map.GetPlayerMapPosition(map, "player");

    local posX = tostring(position["x"])
    local posY = tostring(position["y"])

    local posXString = tostring(posX)
    local posYString = tostring(posY)

    clockWork.print("x = " .. posXString)
    clockWork.print("y = " .. posYString)
end