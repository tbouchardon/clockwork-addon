

function ksuto.listAllSpells()

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