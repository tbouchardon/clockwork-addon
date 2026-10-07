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
        -- DialogBoxFrame a déjà son bouton OK, qui ferme la fenêtre
    end

    f.editBox:SetText(text)
    f.editBox:HighlightText()
    f:Show()
end