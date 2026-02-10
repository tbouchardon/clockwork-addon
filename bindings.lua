--
-- Created by IntelliJ IDEA.
-- User: Kseniya
-- Date: 30/04/2017
-- Time: 21:43
-- To change this template use File | Settings | File Templates.
--

function Clockwork:setAllBindings()

    --    local key = "ALT-CTRL-SHIFT-Y"
    --    local action = "TEST_BINDING"

    --    SetBinding("ALT-SHIFT-1", "CLOCKWORK_PRIORITY_CAST_1")
    --    SetBinding("ALT-SHIFT-2", "CLOCKWORK_PRIORITY_CAST_2")
    --    SetBinding("ALT-SHIFT-3", "CLOCKWORK_PRIORITY_CAST_3")
    --    SetBinding("ALT-SHIFT-4", "CLOCKWORK_PRIORITY_CAST_4")
    --    SetBinding("ALT-SHIFT-5", "CLOCKWORK_PRIORITY_CAST_5")
    --    SetBinding("ALT-SHIFT-6", "CLOCKWORK_PRIORITY_CAST_6")
    --    SetBinding("ALT-SHIFT-7", "CLOCKWORK_PRIORITY_CAST_7")
    --    SetBinding("ALT-SHIFT-8", "CLOCKWORK_PRIORITY_CAST_8")
    --    SetBinding("ALT-SHIFT-9", "CLOCKWORK_PRIORITY_CAST_9")
    --    SetBinding("ALT-SHIFT-0", "CLOCKWORK_PRIORITY_CAST_10")
    --    SetBinding("ALT-SHIFT-)", "CLOCKWORK_PRIORITY_CAST_11")
    --    SetBinding("ALT-SHIFT-=", "CLOCKWORK_PRIORITY_CAST_12")
    --    SetBinding("ALT-CTRL-1", "CLOCKWORK_PRIORITY_CAST_13")
    --    SetBinding("ALT-CTRL-2", "CLOCKWORK_PRIORITY_CAST_14")
    --    SetBinding("ALT-CTRL-3", "CLOCKWORK_PRIORITY_CAST_15")
    --    SetBinding("ALT-CTRL-4", "CLOCKWORK_PRIORITY_CAST_16")
    --    SetBinding("ALT-CTRL-5", "CLOCKWORK_PRIORITY_CAST_17")
    --    SetBinding("ALT-CTRL-6", "CLOCKWORK_PRIORITY_CAST_18")
    --
    --    SetBinding("ALT-CTRL-7", "CLOCKWORK_PRIORITY_OOC_CAST_1")
    --    SetBinding("ALT-CTRL-8", "CLOCKWORK_PRIORITY_OOC_CAST_2")
    --    SetBinding("ALT-CTRL-9", "CLOCKWORK_PRIORITY_OOC_CAST_3")
    --    SetBinding("ALT-CTRL-0", "CLOCKWORK_PRIORITY_OOC_CAST_4")
    --    SetBinding("ALT-CTRL-)", "CLOCKWORK_PRIORITY_OOC_CAST_5")
    --    SetBinding("ALT-CTRL-=", "CLOCKWORK_PRIORITY_OOC_CAST_6")

    local keys = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T"}

    for i = 1, 20 do
        SetBinding("ALT-SHIFT-" .. keys[i], "CLOCKWORK_TARGET_RAID_" .. i)
        SetBinding("ALT-CTRL-" .. keys[i], "CLOCKWORK_TARGET_RAID_" .. (i + 20))
    end
end

function Clockwork.printAllBindings()

    for index = 1, GetNumBindings() do
        local command, key1, key2 = GetBinding(index);
        Clockwork.log.notice("GetBindingAction : command = " .. command .. ", key = " .. key1)
    end
end

-- local ok = SetBindingClick("Y", "ButtonTest");
-- Clockwork.log.debug(tostring(ok))
