--
-- Created by IntelliJ IDEA.
-- User: Kseniya
-- Date: 30/04/2017
-- Time: 21:43
-- To change this template use File | Settings | File Templates.
--

function ksuto.setAllBindings()

    --    local key = "ALT-CTRL-SHIFT-Y"
    --    local action = "TEST_BINDING"
    --    ksuto.print("SetBinding(key, action) ? " .. SetBinding(key, action))

    SetBinding("ALT-SHIFT-1", "CLOCKWORK_PRIORITY_CAST_1")
    SetBinding("ALT-SHIFT-2", "CLOCKWORK_PRIORITY_CAST_2")
    SetBinding("ALT-SHIFT-3", "CLOCKWORK_PRIORITY_CAST_3")
    SetBinding("ALT-SHIFT-4", "CLOCKWORK_PRIORITY_CAST_4")
    SetBinding("ALT-SHIFT-5", "CLOCKWORK_PRIORITY_CAST_5")
    SetBinding("ALT-SHIFT-6", "CLOCKWORK_PRIORITY_CAST_6")
    SetBinding("ALT-SHIFT-7", "CLOCKWORK_PRIORITY_CAST_7")
    SetBinding("ALT-SHIFT-8", "CLOCKWORK_PRIORITY_CAST_8")
    SetBinding("ALT-SHIFT-9", "CLOCKWORK_PRIORITY_CAST_9")
    SetBinding("ALT-SHIFT-0", "CLOCKWORK_PRIORITY_CAST_10")
    SetBinding("ALT-SHIFT-)", "CLOCKWORK_PRIORITY_CAST_11")
    SetBinding("ALT-SHIFT-=", "CLOCKWORK_PRIORITY_CAST_12")
    SetBinding("ALT-CTRL-1", "CLOCKWORK_PRIORITY_CAST_13")
    SetBinding("ALT-CTRL-2", "CLOCKWORK_PRIORITY_CAST_14")
    SetBinding("ALT-CTRL-3", "CLOCKWORK_PRIORITY_CAST_15")
    SetBinding("ALT-CTRL-4", "CLOCKWORK_PRIORITY_CAST_16")
    SetBinding("ALT-CTRL-5", "CLOCKWORK_PRIORITY_CAST_17")
    SetBinding("ALT-CTRL-6", "CLOCKWORK_PRIORITY_CAST_18")

    SetBinding("ALT-CTRL-7", "CLOCKWORK_PRIORITY_OOC_CAST_1")
    SetBinding("ALT-CTRL-8", "CLOCKWORK_PRIORITY_OOC_CAST_2")
    SetBinding("ALT-CTRL-9", "CLOCKWORK_PRIORITY_OOC_CAST_3")
    SetBinding("ALT-CTRL-0", "CLOCKWORK_PRIORITY_OOC_CAST_4")
    SetBinding("ALT-CTRL-)", "CLOCKWORK_PRIORITY_OOC_CAST_5")
    SetBinding("ALT-CTRL-=", "CLOCKWORK_PRIORITY_OOC_CAST_6")

    SetBinding("ALT-SHIFT-A", "CLOCKWORK_TARGET_RAID_1")
    SetBinding("ALT-SHIFT-B", "CLOCKWORK_TARGET_RAID_2")
    SetBinding("ALT-SHIFT-C", "CLOCKWORK_TARGET_RAID_3")
    SetBinding("ALT-SHIFT-D", "CLOCKWORK_TARGET_RAID_4")
    SetBinding("ALT-SHIFT-E", "CLOCKWORK_TARGET_RAID_5")
    SetBinding("ALT-SHIFT-F", "CLOCKWORK_TARGET_RAID_6")
    SetBinding("ALT-SHIFT-G", "CLOCKWORK_TARGET_RAID_7")
    SetBinding("ALT-SHIFT-H", "CLOCKWORK_TARGET_RAID_8")
    SetBinding("ALT-SHIFT-I", "CLOCKWORK_TARGET_RAID_9")
    SetBinding("ALT-SHIFT-J", "CLOCKWORK_TARGET_RAID_10")
    SetBinding("ALT-SHIFT-K", "CLOCKWORK_TARGET_RAID_11")
    SetBinding("ALT-SHIFT-L", "CLOCKWORK_TARGET_RAID_12")
    SetBinding("ALT-SHIFT-M", "CLOCKWORK_TARGET_RAID_13")
    SetBinding("ALT-SHIFT-N", "CLOCKWORK_TARGET_RAID_14")
    SetBinding("ALT-SHIFT-O", "CLOCKWORK_TARGET_RAID_15")
    SetBinding("ALT-SHIFT-P", "CLOCKWORK_TARGET_RAID_16")
    SetBinding("ALT-SHIFT-Q", "CLOCKWORK_TARGET_RAID_17")
    SetBinding("ALT-SHIFT-R", "CLOCKWORK_TARGET_RAID_18")
    SetBinding("ALT-SHIFT-S", "CLOCKWORK_TARGET_RAID_19")
    SetBinding("ALT-SHIFT-T", "CLOCKWORK_TARGET_RAID_20")
    SetBinding("ALT-CTRL-A", "CLOCKWORK_TARGET_RAID_21")
    SetBinding("ALT-CTRL-B", "CLOCKWORK_TARGET_RAID_22")
    SetBinding("ALT-CTRL-C", "CLOCKWORK_TARGET_RAID_23")
    SetBinding("ALT-CTRL-D", "CLOCKWORK_TARGET_RAID_24")
    SetBinding("ALT-CTRL-E", "CLOCKWORK_TARGET_RAID_25")
    SetBinding("ALT-CTRL-F", "CLOCKWORK_TARGET_RAID_26")
    SetBinding("ALT-CTRL-G", "CLOCKWORK_TARGET_RAID_27")
    SetBinding("ALT-CTRL-H", "CLOCKWORK_TARGET_RAID_28")
    SetBinding("ALT-CTRL-I", "CLOCKWORK_TARGET_RAID_29")
    SetBinding("ALT-CTRL-J", "CLOCKWORK_TARGET_RAID_30")
    SetBinding("ALT-CTRL-K", "CLOCKWORK_TARGET_RAID_31")
    SetBinding("ALT-CTRL-L", "CLOCKWORK_TARGET_RAID_32")
    SetBinding("ALT-CTRL-M", "CLOCKWORK_TARGET_RAID_33")
    SetBinding("ALT-CTRL-N", "CLOCKWORK_TARGET_RAID_34")
    SetBinding("ALT-CTRL-O", "CLOCKWORK_TARGET_RAID_35")
    SetBinding("ALT-CTRL-P", "CLOCKWORK_TARGET_RAID_36")
    SetBinding("ALT-CTRL-Q", "CLOCKWORK_TARGET_RAID_37")
    SetBinding("ALT-CTRL-R", "CLOCKWORK_TARGET_RAID_38")
    SetBinding("ALT-CTRL-S", "CLOCKWORK_TARGET_RAID_39")
    SetBinding("ALT-CTRL-T", "CLOCKWORK_TARGET_RAID_40")
end

function ksuto.printAllBindings()

    for index = 1, GetNumBindings() do
        local command, key1, key2 = GetBinding(index);
        ksuto.print("GetBindingAction : command = " .. command .. ", key = " .. key1)
    end
end

-- local ok = SetBindingClick("Y", "ButtonTest");

-- ksuto.print(tostring(ok))

