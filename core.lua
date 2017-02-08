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

ksuto.blackBackground1 = CreateFrame("FRAME", "ksuto_ksuto.blackBackground1", ksuto.frame)
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

ksuto.blackBackground3 = CreateFrame("FRAME", "ksuto_Background3", ksuto.frame)
ksuto.blackBackground3:SetPoint("CENTER", 0, 0)
ksuto.blackBackground3:SetWidth(14)
ksuto.blackBackground3:SetHeight(14)
ksuto.blackBackground3:SetFrameStrata("MEDIUM");
ksuto.blackBackground3.texture = ksuto.blackBackground3:CreateTexture("MEDIUM")
ksuto.blackBackground3.texture:SetAllPoints()
ksuto.blackBackground3.texture:SetTexture(0, 0, 0, 1)

ksuto.onOff = CreateFrame("FRAME", "ksuto_onOff", ksuto.frame)
ksuto.onOff:SetPoint("CENTER", 0, 0)
ksuto.onOff:SetWidth(16)
ksuto.onOff:SetHeight(16)
ksuto.onOff:SetFrameStrata("DIALOG")
ksuto.onOff.texture = ksuto.onOff:CreateTexture("DIALOG")
ksuto.onOff.texture:SetAllPoints()
ksuto.onOff.texture:SetTexture(0, 1, 0, 1)

ksuto.toggle = ksuto.createDot("ksuto_toggle", 2, -13)
ksuto.targetNearestEnemy = ksuto.createDot("ksuto_targetNearestEnemy", 3, -13)
ksuto.addWaypoint = ksuto.createDot("ksuto_addWaypoint", 4, -13)
ksuto.clearWaypoints = ksuto.createDot("ksuto_clearWaypoints", 5, -13)
ksuto.drive = ksuto.createDot("ksuto_drive", 6, -13)
ksuto.driveLoop = ksuto.createDot("ksuto_driveLoop", 7, -13)
ksuto.debug = ksuto.createDot("ksuto_debug", 13, -13)
if ksuto.DEBUG_MOD then ksuto.debug.texture:SetTexture(1, 0, 0, 1) end