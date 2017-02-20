function ksuto.printDebug(text)

    -- ksuto.printDebug("function ksuto.printDebug(" .. tostring(text))

    if ksuto.DEBUG_MOD then

        DEFAULT_CHAT_FRAME:AddMessage("Ksuto (Debug) -> " .. text)
    end
end

function ksuto.listAllSpells()

    -- ksuto.printDebug("function ksuto.listAllSpells(")

    ksuto.printDebug("ksuto.listAllSpells()")

    if ksuto.DEBUG_MOD then

        local spellID = 1;

        while true do
            local spellName, subSpellName = GetSpellName(spellID, BOOKTYPE_SPELL);

            if not spellName then
                do break end
            end

            if (string.find(subSpellName, "Rank")) then
                local rank = strsub(subSpellName, 6, strlen(subSpellName));
                ksuto.printDebug("Spell : id=" .. tostring(spellID) .. ", name=" .. spellName .. ", rank=" .. rank);
            else
                ksuto.printDebug("Spell : id=" .. tostring(spellID) .. ", name=" .. spellName);
            end

            spellID = spellID + 1;
        end
    end
end

function ksuto.reportActionButtons()

    -- ksuto.printDebug("function ksuto.reportActionButtons(")

    for actionSlot = 1, 120 do

        local actionText = GetActionText(actionSlot);
        local actionTexture = GetActionTexture(actionSlot);

        if actionTexture then

            local message = "Slot " .. actionSlot .. " : [" .. actionTexture .. "]";

            if actionText then

                message = message .. " \"" .. actionText .. "\"";
            end

            ksuto.printDebug(message);
        end
    end
end

function getCoord()

    -- ksuto.printDebug("function getCoord(")

    local posX, posY = GetPlayerMapPosition("player");

    local posXString = tostring(posX)
    local posYString = tostring(posY)

    ksuto.print("x = " .. posXString)
    ksuto.print("y = " .. posYString)
end