--
-- Created by IntelliJ IDEA.
-- User: Kseniya
-- Date: 30/04/2017
-- Time: 21:43
-- To change this template use File | Settings | File Templates.
--

local button = CreateFrame("Button", "ButtonTest", UIParent)
button:RegisterForClicks("AnyUp", "AnyDown")
button:SetScript("OnClick", function(self, button, down)
    ksuto.print("testtttt")
end)

local ok = SetBindingClick("ALT-CTRL-J", "ButtonTest");

ksuto.print(tostring(ok))

