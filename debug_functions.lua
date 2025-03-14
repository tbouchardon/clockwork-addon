function Clockwork.listAllSpells()
    -- Clockwork.log.debug("function Clockwork.listAllSpells(")

    Clockwork.log.info("Clockwork.listAllSpells()")

    local index = 1;

    while true do
        local name, subName = C_SpellBook.GetSpellBookItemName(index, Enum.SpellBookSpellBank.Player);
        -- /dump C_SpellBook.GetSpellBookItemInfo(6, Enum.SpellBookSpellBank.Player)
        local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(index, Enum.SpellBookSpellBank.Player)

        if not name then
            do
                break
            end
        end
        if not Clockwork.emptyOrNil(spellBookItemInfo.skillLineIndex) and spellBookItemInfo.skillLineIndex < 6 then
            if spellBookItemInfo.itemType == Enum.SpellBookItemType.Spell or spellBookItemInfo.itemType == Enum.SpellBookItemType.FutureSpell then
                Clockwork.log.info("Spell " .. spellBookItemInfo.skillLineIndex .. "-" .. index ..
                    " : {id:" .. tostring(spellBookItemInfo.spellID) .. "," ..
                    " name:\"" .. name .. "\"},");
            end
        end
        index = index + 1;
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

            Clockwork.log.info(message);
        end
    end
end

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
