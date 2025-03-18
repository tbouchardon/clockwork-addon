function Clockwork.reportAllSpells()
    -- Clockwork.log.debug("function Clockwork.listAllSpells(")

    Clockwork.log.info("Clockwork.listAllSpells()")

    local index = 1;

    while true do
        -- /dump C_SpellBook.GetSpellBookItemInfo(6, Enum.SpellBookSpellBank.Player)
        local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(index, Enum.SpellBookSpellBank.Player)

        if not spellBookItemInfo.name then
            do
                break
            end
        end
        if not Clockwork.emptyOrNil(spellBookItemInfo.skillLineIndex) and spellBookItemInfo.skillLineIndex < 6 then
            if spellBookItemInfo.itemType == Enum.SpellBookItemType.Spell or spellBookItemInfo.itemType == Enum.SpellBookItemType.FutureSpell then
                Clockwork.log.info(
                    spellBookItemInfo.skillLineIndex .. "-" .. index ..
                    ", Spell ID:" .. tostring(spellBookItemInfo.spellID) ..
                    ", name:\"" .. spellBookItemInfo.name .. "\""
                );
            end
        end
        index = index + 1;
    end
end

function Clockwork.reportActionButtons()
    Clockwork.log.info("function Clockwork.reportActionButtons()")

    for actionSlot = 1, 120 do
        local actionType, id, subType = GetActionInfo(actionSlot);

        if id then
            local spellInfo = C_Spell.GetSpellInfo(id)
            local message = "Slot:" .. actionSlot .. ", id:" .. id;

            if spellInfo then
                message = message .. ", Spell ID:" .. spellInfo.spellID .. ", name:\"" .. spellInfo.name .. "\"";
            end

            Clockwork.log.info(message);
        end
    end
end

function Clockwork.reportBindings()
    Clockwork.log.info("function Clockwork.reportBindings()")
    local bindings = Clockwork.getAllActionSlotBindings(Clockwork)

    for _, binding in ipairs(bindings) do
        local combinaison = {}
        if binding.shift then
            table.insert(combinaison, "Shift")
        end
        if binding.alt then
            table.insert(combinaison, "Alt")
        end
        if binding.ctrl then
            table.insert(combinaison, "Ctrl")
        end
        table.insert(combinaison, binding.key)

        local modifiersString = table.concat(combinaison, "+")

        Clockwork.log.info("Key:" .. modifiersString .. ", Spell ID:" .. binding.spellId .. ", Slot:" .. binding.slot)
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
