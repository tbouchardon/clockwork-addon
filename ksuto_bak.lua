local UPDATE_INTERVAL = 0.25

local function sout(text)

	DEFAULT_CHAT_FRAME:AddMessage(text)
end

local function setBlackTexture(someFrame) 

	--someFrame:SetTexture(nil)
	local texBlack = someFrame:CreateTexture("black", "HIGH")
	texBlack:SetAllPoints()
	texBlack:SetTexture(0, 0, 0, 1)

end

local function setGreenTexture(someFrame) 

	local texBlack = someFrame:CreateTexture("green", "HIGH")
	texBlack:SetAllPoints()
	texBlack:SetTexture(0, 1, 0, 1)

end

local function setWhiteTexture(someFrame) 

	--someFrame:SetTexture(nil)
	local texBlack = someFrame:CreateTexture("white", "HIGH")
	texBlack:SetAllPoints()
	texBlack:SetTexture(1, 1, 1, 1)

end	

-- init Frame

local frame = CreateFrame("FRAME", "ksuto_MainFrame", UIParent)
ksuto_MainFrame:SetPoint("CENTER",0,0)
ksuto_MainFrame:SetWidth(16)
ksuto_MainFrame:SetHeight(16)
ksuto_MainFrame:SetFrameStrata("MEDIUM");
setGreenTexture(ksuto_MainFrame)

frame:SetScript("OnUpdate", onUpdate)

local blackBackground1 = CreateFrame("FRAME", "ksuto_blackBackground1", frame)
blackBackground1:SetPoint("CENTER",0,0)
blackBackground1:SetWidth(16)
blackBackground1:SetHeight(8)
blackBackground1:SetFrameStrata("MEDIUM");
setBlackTexture(blackBackground1)

local blackBackground2 = CreateFrame("FRAME", "ksuto_Background2", frame)
blackBackground2:SetPoint("CENTER",0,0)
blackBackground2:SetWidth(8)
blackBackground2:SetHeight(16)	
blackBackground2:SetFrameStrata("MEDIUM");
setBlackTexture(blackBackground2)

local blackBackground3 = CreateFrame("FRAME", "ksuto_Background3", frame)
blackBackground3:SetPoint("CENTER",0,0)
blackBackground3:SetWidth(14)
blackBackground3:SetHeight(14)	
blackBackground3:SetFrameStrata("MEDIUM");
setBlackTexture(blackBackground3)

local function createDot(name, xPos, yPos) 

	local dotFrame = CreateFrame("FRAME", "ksuto_"..name, frame)
	dotFrame:SetPoint("TOPLEFT",xPos,yPos)
	dotFrame:SetWidth(1)
	dotFrame:SetHeight(1)	
	dotFrame:SetFrameStrata("HIGH");
	
	dotFrame.texture = dotFrame:CreateTexture("HIGH")
	dotFrame.texture:SetAllPoints()
	dotFrame.texture:SetTexture(0, 0, 0, 1)
	
	return dotFrame
end

local key1 = createDot("ksuto_key1", 2, -2)
local key2 = createDot("ksuto_key2", 3, -2)
local key3 = createDot("ksuto_key3", 4, -2)
local key4 = createDot("ksuto_key4", 5, -2)
local key5 = createDot("ksuto_key5", 6, -2)
local key6 = createDot("ksuto_key6", 7, -2)
local key7 = createDot("ksuto_key7", 8, -2)
local key8 = createDot("ksuto_key8", 9, -2)
local key9 = createDot("ksuto_key9", 10, -2)
local key0 = createDot("ksuto_key0", 11, -2)
local keyPar = createDot("ksuto_keyPar", 12, -2)
local keyEq = createDot("ksuto_keyEq", 13, -2)

local keyQ = createDot("ksuto_keyQ", 2, -3)
local keyD = createDot("ksuto_keyD", 3, -3)
local keyG = createDot("ksuto_keyG", 5, -3)
local keyH = createDot("ksuto_keyH", 6, -3)
local keyT = createDot("ksuto_keyT", 7, -3)

local keyMaj = createDot("ksuto_keyMaj", 2, -4)
local keyCtrl = createDot("ksuto_keyCtrl", 3, -4)
local keyAlt = createDot("ksuto_keyAlt", 4, -4)

local coord_lati_Xx_xx_0 = createDot("ksuto_coord_lati_Xx_xx_0", 2, -5)
local coord_lati_Xx_xx_1 = createDot("ksuto_coord_lati_Xx_xx_1", 3, -5)
local coord_lati_Xx_xx_2 = createDot("ksuto_coord_lati_Xx_xx_2", 4, -5)
local coord_lati_Xx_xx_3 = createDot("ksuto_coord_lati_Xx_xx_3", 5, -5)
local coord_lati_Xx_xx_4 = createDot("ksuto_coord_lati_Xx_xx_4", 6, -5)
local coord_lati_Xx_xx_5 = createDot("ksuto_coord_lati_XX_xx_5", 7, -5)
local coord_lati_Xx_xx_6 = createDot("ksuto_coord_lati_xX_xx_6", 8, -5)
local coord_lati_Xx_xx_7 = createDot("ksuto_coord_lati_XX_xx_7", 9, -5)
local coord_lati_Xx_xx_8 = createDot("ksuto_coord_lati_XX_xx_8", 10, -5)
local coord_lati_Xx_xx_9 = createDot("ksuto_coord_lati_xX_xx_9", 11, -5)

local coord_lati_xX_xx_0 = createDot("ksuto_coord_lati_xX_xx_0", 2, -6)
local coord_lati_xX_xx_1 = createDot("ksuto_coord_lati_xX_xx_1", 3, -6)
local coord_lati_xX_xx_2 = createDot("ksuto_coord_lati_xX_xx_2", 4, -6)
local coord_lati_xX_xx_3 = createDot("ksuto_coord_lati_xX_xx_3", 5, -6)
local coord_lati_xX_xx_4 = createDot("ksuto_coord_lati_xX_xx_4", 6, -6)
local coord_lati_xX_xx_5 = createDot("ksuto_coord_lati_xX_xx_5", 7, -6)
local coord_lati_xX_xx_6 = createDot("ksuto_coord_lati_xX_xx_6", 8, -6)
local coord_lati_xX_xx_7 = createDot("ksuto_coord_lati_xX_xx_7", 9, -6)
local coord_lati_xX_xx_8 = createDot("ksuto_coord_lati_xX_xx_8", 10, -6)
local coord_lati_xX_xx_9 = createDot("ksuto_coord_lati_xX_xx_9", 11, -6)

local coord_lati_xx_Xx_0 = createDot("ksuto_coord_lati_xx_Xx_0", 2, -7)
local coord_lati_xx_Xx_1 = createDot("ksuto_coord_lati_xx_xx_1", 3, -7)
local coord_lati_xx_Xx_2 = createDot("ksuto_coord_lati_xx_xx_2", 4, -7)
local coord_lati_xx_Xx_3 = createDot("ksuto_coord_lati_xx_xx_3", 5, -7)
local coord_lati_xx_Xx_4 = createDot("ksuto_coord_lati_xx_xx_4", 6, -7)
local coord_lati_xx_Xx_5 = createDot("ksuto_coord_lati_xX_xx_5", 7, -7)
local coord_lati_xx_Xx_6 = createDot("ksuto_coord_lati_xX_xx_6", 8, -7)
local coord_lati_xx_Xx_7 = createDot("ksuto_coord_lati_xX_xx_7", 9, -7)
local coord_lati_xx_Xx_8 = createDot("ksuto_coord_lati_xX_xx_8", 10, -7)
local coord_lati_xx_Xx_9 = createDot("ksuto_coord_lati_xX_xx_9", 11, -7)

local coord_lati_xx_xX_0 = createDot("ksuto_coord_lati_xx_xX_0", 2, -8)
local coord_lati_xx_xX_1 = createDot("ksuto_coord_lati_xx_xx_1", 3, -8)
local coord_lati_xx_xX_2 = createDot("ksuto_coord_lati_xx_xx_2", 4, -8)
local coord_lati_xx_xX_3 = createDot("ksuto_coord_lati_xx_xx_3", 5, -8)
local coord_lati_xx_xX_4 = createDot("ksuto_coord_lati_xx_xx_4", 6, -8)
local coord_lati_xx_xX_5 = createDot("ksuto_coord_lati_xX_xx_5", 7, -8)
local coord_lati_xx_xX_6 = createDot("ksuto_coord_lati_xX_xx_6", 8, -8)
local coord_lati_xx_xX_7 = createDot("ksuto_coord_lati_xX_xx_7", 9, -8)
local coord_lati_xx_xX_8 = createDot("ksuto_coord_lati_xX_xx_8", 10, -8)
local coord_lati_xx_xX_9 = createDot("ksuto_coord_lati_xX_xx_9", 11, -8)

local coord_long_Xx_xx_0 = createDot("ksuto_coord_long_Xx_xx_0", 2, -9)
local coord_long_Xx_xx_1 = createDot("ksuto_coord_long_Xx_xx_1", 3, -9)
local coord_long_Xx_xx_2 = createDot("ksuto_coord_long_Xx_xx_2", 4, -9)
local coord_long_Xx_xx_3 = createDot("ksuto_coord_long_Xx_xx_3", 5, -9)
local coord_long_Xx_xx_4 = createDot("ksuto_coord_long_Xx_xx_4", 6, -9)
local coord_long_Xx_xx_5 = createDot("ksuto_coord_long_XX_xx_5", 7, -9)
local coord_long_Xx_xx_6 = createDot("ksuto_coord_long_xX_xx_6", 8, -9)
local coord_long_Xx_xx_7 = createDot("ksuto_coord_long_XX_xx_7", 9, -9)
local coord_long_Xx_xx_8 = createDot("ksuto_coord_long_XX_xx_8", 10, -9)
local coord_long_Xx_xx_9 = createDot("ksuto_coord_long_xX_xx_9", 11, -9)

local coord_long_xX_xx_0 = createDot("ksuto_coord_long_xX_xx_0", 2, -10)
local coord_long_xX_xx_1 = createDot("ksuto_coord_long_xX_xx_1", 3, -10)
local coord_long_xX_xx_2 = createDot("ksuto_coord_long_xX_xx_2", 4, -10)
local coord_long_xX_xx_3 = createDot("ksuto_coord_long_xX_xx_3", 5, -10)
local coord_long_xX_xx_4 = createDot("ksuto_coord_long_xX_xx_4", 6, -10)
local coord_long_xX_xx_5 = createDot("ksuto_coord_long_xX_xx_5", 7, -10)
local coord_long_xX_xx_6 = createDot("ksuto_coord_long_xX_xx_6", 8, -10)
local coord_long_xX_xx_7 = createDot("ksuto_coord_long_xX_xx_7", 9, -10)
local coord_long_xX_xx_8 = createDot("ksuto_coord_long_xX_xx_8", 10, -10)
local coord_long_xX_xx_9 = createDot("ksuto_coord_long_xX_xx_9", 11, -10)

local coord_long_xx_Xx_0 = createDot("ksuto_coord_long_xx_Xx_0", 2, -11)
local coord_long_xx_Xx_1 = createDot("ksuto_coord_long_xx_xx_1", 3, -11)
local coord_long_xx_Xx_2 = createDot("ksuto_coord_long_xx_xx_2", 4, -11)
local coord_long_xx_Xx_3 = createDot("ksuto_coord_long_xx_xx_3", 5, -11)
local coord_long_xx_Xx_4 = createDot("ksuto_coord_long_xx_xx_4", 6, -11)
local coord_long_xx_Xx_5 = createDot("ksuto_coord_long_xX_xx_5", 7, -11)
local coord_long_xx_Xx_6 = createDot("ksuto_coord_long_xX_xx_6", 8, -11)
local coord_long_xx_Xx_7 = createDot("ksuto_coord_long_xX_xx_7", 9, -11)
local coord_long_xx_Xx_8 = createDot("ksuto_coord_long_xX_xx_8", 10, -11)
local coord_long_xx_Xx_9 = createDot("ksuto_coord_long_xX_xx_9", 11, -11)

local coord_long_xx_xX_0 = createDot("ksuto_coord_long_xx_xX_0", 2, -12)
local coord_long_xx_xX_1 = createDot("ksuto_coord_long_xx_xx_1", 3, -12)
local coord_long_xx_xX_2 = createDot("ksuto_coord_long_xx_xx_2", 4, -12)
local coord_long_xx_xX_3 = createDot("ksuto_coord_long_xx_xx_3", 5, -12)
local coord_long_xx_xX_4 = createDot("ksuto_coord_long_xx_xx_4", 6, -12)
local coord_long_xx_xX_5 = createDot("ksuto_coord_long_xX_xx_5", 7, -12)
local coord_long_xx_xX_6 = createDot("ksuto_coord_long_xX_xx_6", 8, -12)
local coord_long_xx_xX_7 = createDot("ksuto_coord_long_xX_xx_7", 9, -12)
local coord_long_xx_xX_8 = createDot("ksuto_coord_long_xX_xx_8", 10, -12)
local coord_long_xx_xX_9 = createDot("ksuto_coord_long_xX_xx_9", 11, -12)

function warlockRotation()

	updatePositionCoordinates() 	

	-- sout("warlockRotation()")
	
	if 	UnitExists("target") and
		not UnitIsDeadOrGhost("target")  then
	
	--and	UnitIsEnemy("target", "player")
	
		AttackTarget()
		
		local immolate;
		local corruption;
		local agony;
			
		for i=1,40 do 


			if 	name then 
			

				--DEFAULT_CHAT_FRAME:AddMessage(texture)
				--DEFAULT_CHAT_FRAME:AddMessage(count)
				--DEFAULT_CHAT_FRAME:AddMessage(debuffType)
				--DEFAULT_CHAT_FRAME:AddMessage(duration)
				--DEFAULT_CHAT_FRAME:AddMessage(timeLeft)
							
				if not immolate then immolate = string.find(name, "Immolation") end
				if not corruption then corruption = string.find(name, "Abomination") end
				if not agony then agony = string.find(name, "CurseOfSargeras") end
				
			end 
		end
		
		
		if not immolate then key5.texture:SetTexture(1, 1, 1, 1) else key5.texture:SetTexture(0, 0, 0, 1) end
		if not corruption then key4.texture:SetTexture(1, 1, 1, 1) else key4.texture:SetTexture(0, 0, 0, 1) end
		if not agony then key3.texture:SetTexture(1, 1, 1, 1) else key3.texture:SetTexture(0, 0, 0, 1) end
		
		if not	immolate then 
			CastSpellByName("Immolate")
		elseif not corruption then 
			CastSpellByName("Corruption")
		elseif not agony then 
			CastSpellByName("Curse of Agony")
		else 
			CastSpellByName("Shadow Bolt") 
		end
	else
		--TargetNearestEnemy()
	end
end

function ksuto_smartCast() 

	warlockRotation()
end

function print(text)

	DEFAULT_CHAT_FRAME:AddMessage(text)
end

local total = 0
local lastUpdate = 0
local function onUpdate(self,elapsed)

	local now = GetTime()

	if (lastUpdate < now) then
	
		-- sout(lastUpdate)
		warlockRotation()
		lastUpdate = now + UPDATE_INTERVAL;
	end
end

--ksuto_MainFrame:SetMovable(true)
--ksuto_MainFrame:EnableMouse(1)

local function checkLong_Xx_xx(posXString_Xx_xx) 

	if posXString_Xx_xx == "0" then coord_long_Xx_xx_0.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_0.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "1" then coord_long_Xx_xx_1.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_1.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "2" then coord_long_Xx_xx_2.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_2.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "3" then coord_long_Xx_xx_3.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_3.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "4" then coord_long_Xx_xx_4.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_4.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "5" then coord_long_Xx_xx_5.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_5.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "6" then coord_long_Xx_xx_6.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_6.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "7" then coord_long_Xx_xx_7.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_7.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "8" then coord_long_Xx_xx_8.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_8.texture:SetTexture(0, 0, 0, 1) end
	if posXString_Xx_xx == "9" then coord_long_Xx_xx_9.texture:SetTexture(1, 1, 1, 1) else coord_long_Xx_xx_9.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "0" then coord_long_xx_xX_0.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_0.texture:SetTexture(0, 0, 0, 1) end
end

local function checkLong_xX_xx(posXString_xX_xx) 

	if posXString_xX_xx == "0" then coord_long_xX_xx_0.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_0.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "1" then coord_long_xX_xx_1.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_1.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "2" then coord_long_xX_xx_2.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_2.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "3" then coord_long_xX_xx_3.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_3.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "4" then coord_long_xX_xx_4.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_4.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "5" then coord_long_xX_xx_5.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_5.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "6" then coord_long_xX_xx_6.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_6.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "7" then coord_long_xX_xx_7.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_7.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "8" then coord_long_xX_xx_8.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_8.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xX_xx == "9" then coord_long_xX_xx_9.texture:SetTexture(1, 1, 1, 1) else coord_long_xX_xx_9.texture:SetTexture(0, 0, 0, 1) end
end

local function checkLong_xx_Xx(posXString_xx_Xx) 

	if posXString_xx_Xx == "0" then coord_long_xx_Xx_0.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_0.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "1" then coord_long_xx_Xx_1.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_1.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "2" then coord_long_xx_Xx_2.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_2.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "3" then coord_long_xx_Xx_3.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_3.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "4" then coord_long_xx_Xx_4.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_4.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "5" then coord_long_xx_Xx_5.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_5.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "6" then coord_long_xx_Xx_6.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_6.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "7" then coord_long_xx_Xx_7.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_7.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "8" then coord_long_xx_Xx_8.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_8.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_Xx == "9" then coord_long_xx_Xx_9.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_Xx_9.texture:SetTexture(0, 0, 0, 1) end
end

local function checkLong_xx_xX(posXString_xx_xX) 

	if posXString_xx_xX == "1" then coord_long_xx_xX_1.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_1.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "2" then coord_long_xx_xX_2.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_2.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "3" then coord_long_xx_xX_3.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_3.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "4" then coord_long_xx_xX_4.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_4.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "5" then coord_long_xx_xX_5.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_5.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "6" then coord_long_xx_xX_6.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_6.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "7" then coord_long_xx_xX_7.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_7.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "8" then coord_long_xx_xX_8.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_8.texture:SetTexture(0, 0, 0, 1) end
	if posXString_xx_xX == "9" then coord_long_xx_xX_9.texture:SetTexture(1, 1, 1, 1) else coord_long_xx_xX_9.texture:SetTexture(0, 0, 0, 1) end
end

local function checkLati_Xx_xx(posYString_Xx_xx) 

	if posYString_Xx_xx == "0" then coord_lati_Xx_xx_0.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_0.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "1" then coord_lati_Xx_xx_1.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_1.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "2" then coord_lati_Xx_xx_2.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_2.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "3" then coord_lati_Xx_xx_3.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_3.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "4" then coord_lati_Xx_xx_4.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_4.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "5" then coord_lati_Xx_xx_5.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_5.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "6" then coord_lati_Xx_xx_6.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_6.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "7" then coord_lati_Xx_xx_7.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_7.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "8" then coord_lati_Xx_xx_8.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_8.texture:SetTexture(0, 0, 0, 1) end
	if posYString_Xx_xx == "9" then coord_lati_Xx_xx_9.texture:SetTexture(1, 1, 1, 1) else coord_lati_Xx_xx_9.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "0" then coord_lati_xx_xX_0.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_0.texture:SetTexture(0, 0, 0, 1) end
end

local function checkLati_xX_xx(posYString_xX_xx) 

	if posYString_xX_xx == "0" then coord_lati_xX_xx_0.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_0.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "1" then coord_lati_xX_xx_1.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_1.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "2" then coord_lati_xX_xx_2.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_2.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "3" then coord_lati_xX_xx_3.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_3.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "4" then coord_lati_xX_xx_4.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_4.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "5" then coord_lati_xX_xx_5.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_5.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "6" then coord_lati_xX_xx_6.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_6.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "7" then coord_lati_xX_xx_7.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_7.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "8" then coord_lati_xX_xx_8.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_8.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xX_xx == "9" then coord_lati_xX_xx_9.texture:SetTexture(1, 1, 1, 1) else coord_lati_xX_xx_9.texture:SetTexture(0, 0, 0, 1) end
end

local function checkLati_xx_Xx(posYString_xx_Xx) 

	if posYString_xx_Xx == "0" then coord_lati_xx_Xx_0.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_0.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "1" then coord_lati_xx_Xx_1.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_1.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "2" then coord_lati_xx_Xx_2.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_2.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "3" then coord_lati_xx_Xx_3.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_3.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "4" then coord_lati_xx_Xx_4.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_4.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "5" then coord_lati_xx_Xx_5.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_5.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "6" then coord_lati_xx_Xx_6.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_6.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "7" then coord_lati_xx_Xx_7.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_7.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "8" then coord_lati_xx_Xx_8.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_8.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_Xx == "9" then coord_lati_xx_Xx_9.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_Xx_9.texture:SetTexture(0, 0, 0, 1) end
end

local function checkLati_xx_xX(posYString_xx_xX) 

	if posYString_xx_xX == "1" then coord_lati_xx_xX_1.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_1.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "2" then coord_lati_xx_xX_2.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_2.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "3" then coord_lati_xx_xX_3.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_3.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "4" then coord_lati_xx_xX_4.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_4.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "5" then coord_lati_xx_xX_5.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_5.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "6" then coord_lati_xx_xX_6.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_6.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "7" then coord_lati_xx_xX_7.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_7.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "8" then coord_lati_xx_xX_8.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_8.texture:SetTexture(0, 0, 0, 1) end
	if posYString_xx_xX == "9" then coord_lati_xx_xX_9.texture:SetTexture(1, 1, 1, 1) else coord_lati_xx_xX_9.texture:SetTexture(0, 0, 0, 1) end
end

function updatePositionCoordinates() 

	local posX, posY = GetPlayerMapPosition("player");
	
	local posXString = tostring(posX)
	local posYString = tostring(posY)
	
	local posXString_Xx_xx = string.sub(posXString, 3,3)
	local posXString_xX_xx = string.sub(posXString, 4,4)
	local posXString_xx_Xx = string.sub(posXString, 5,5)
	local posXString_xx_xX = string.sub(posXString, 6,6)
	
	local posYString_Xx_xx = string.sub(posYString, 3,3)
	local posYString_xX_xx = string.sub(posYString, 4,4)
	local posYString_xx_Xx = string.sub(posYString, 5,5)
	local posYString_xx_xX = string.sub(posYString, 6,6)
	
	--print(posXString_xx_xX)

	checkLong_Xx_xx(posXString_Xx_xx)
	checkLong_xX_xx(posXString_xX_xx)
	checkLong_xx_Xx(posXString_xx_Xx)
	checkLong_xx_xX(posXString_xx_xX)

	checkLati_Xx_xx(posYString_Xx_xx)
	checkLati_xX_xx(posYString_xX_xx)
	checkLati_xx_Xx(posYString_xx_Xx)
	checkLati_xx_xX(posYString_xx_xX)
	
end