function Clockwork.listAllSpells()

    -- Clockwork.log.debug("function Clockwork.listAllSpells(")

    Clockwork.log.debug("Clockwork.listAllSpells()")

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
                Clockwork.log.debug("Spell : id=" .. tostring(spellID) .. ", name=" .. spellName .. ", rank=" .. rank);
            else
                Clockwork.log.debug("Spell : id=" .. tostring(spellID) .. ", name=" .. spellName);
            end

            index = index + 1;
        end
    end
end

function Clockwork.reportActionButtons()

    -- Clockwork.log.debug("function Clockwork.reportActionButtons(")

    for actionSlot = 1, 120 do

        local actionText = GetActionText(actionSlot);
        local actionTexture = GetActionTexture(actionSlot);

        if actionTexture then

            local message = "Slot " .. actionSlot .. " : [" .. actionTexture .. "]";

            if actionText then

                message = message .. " \"" .. actionText .. "\"";
            end

            Clockwork.log.debug(message);
        end
    end
end

function Clockwork.getCoord()

    -- Clockwork.log.debug("function getCoord(")

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