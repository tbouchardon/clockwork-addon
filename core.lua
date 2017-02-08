-- init Frame

ksuto.frame = CreateFrame("FRAME", "ksuto_MainFrame", UIParent)
ksuto.frame:SetPoint("TOP", 0, -100)
ksuto.frame:SetWidth(16)
ksuto.frame:SetHeight(16)
ksuto.frame:SetFrameStrata("MEDIUM")
ksuto.frame.texture = ksuto.frame:CreateTexture("MEDIUM")
ksuto.frame.texture:SetAllPoints()
ksuto.frame.texture:SetTexture(0, 1, 0, 1)

ksuto.lastUpdate = 0
function ksuto.frame:onUpdate(elapsed)

    local now = GetTime()

    if (ksuto.lastUpdate < now) then

        --ksuto.printDebug(ksuto.lastUpdate)

        ksuto.mana = UnitMana("player");

        if (ksuto.TOGGLE_ON_OFF) then

            ksuto.updatePositionCoordinates()
            ksuto.rotation()
        end

        ksuto.lastUpdate = now + ksuto.UPDATE_INTERVAL;
    end
end

ksuto.frame:SetScript("OnUpdate", ksuto.frame.onUpdate)

ksuto.blackBackground1 = CreateFrame("FRAME", "ksuto_Background1", ksuto.frame)
ksuto.blackBackground1:SetPoint("CENTER", 0, 0)
ksuto.blackBackground1:SetWidth(16)
ksuto.blackBackground1:SetHeight(8)
ksuto.blackBackground1:SetFrameStrata("MEDIUM");
ksuto.blackBackground1.texture = ksuto.blackBackground1:CreateTexture("MEDIUM")
ksuto.blackBackground1.texture:SetAllPoints()
ksuto.blackBackground1.texture:SetTexture(0, 0, 0, 1)

ksuto.blackBackground2 = CreateFrame("FRAME", "ksuto_Background2", ksuto.frame)
ksuto.blackBackground2:SetPoint("CENTER", 0, 0)
ksuto.blackBackground2:SetWidth(8)
ksuto.blackBackground2:SetHeight(16)
ksuto.blackBackground2:SetFrameStrata("MEDIUM");
ksuto.blackBackground2.texture = ksuto.blackBackground2:CreateTexture("MEDIUM")
ksuto.blackBackground2.texture:SetAllPoints()
ksuto.blackBackground2.texture:SetTexture(0, 0, 0, 1)

ksuto.blackBackground3 = CreateFrame("FRAME", "ksuto_Background2", ksuto.frame)
ksuto.blackBackground3:SetPoint("CENTER", 0, 0)
ksuto.blackBackground3:SetWidth(15)
ksuto.blackBackground3:SetHeight(15)
ksuto.blackBackground3:SetFrameStrata("MEDIUM");
ksuto.blackBackground3.texture = ksuto.blackBackground3:CreateTexture("MEDIUM")
ksuto.blackBackground3.texture:SetAllPoints()
ksuto.blackBackground3.texture:SetTexture(0, 0, 0, 1)