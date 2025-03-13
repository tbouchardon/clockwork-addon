function Clockwork.getLogLevel()


    if (Clockwork.LOG_LEVEL == 'EMERGENCY') then return 1 end -- Emergency is unusable (Unfixable)
    if (Clockwork.LOG_LEVEL == 'ALERT') then return 2 end     -- Alert is unsecure
    if (Clockwork.LOG_LEVEL == 'CRITICAL') then return 3 end  -- Critical is stateful
    if (Clockwork.LOG_LEVEL == 'ERROR') then return 4 end     -- Error is unstable
    if (Clockwork.LOG_LEVEL == 'WARNING') then return 5 end   -- Warning is undesired
    if (Clockwork.LOG_LEVEL == 'NOTICE') then return 6 end    -- Notice is relevant
    if (Clockwork.LOG_LEVEL == 'INFO') then return 7 end      -- Informational is statistical
    if (Clockwork.LOG_LEVEL == 'DEBUG') then return 8 end     -- Debug is development
    return 5
end

Clockwork.log = {}

function Clockwork.log.text(text)

    DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: " .. tostring(text))
end

function Clockwork.log.emergency(text)
    if Clockwork.getLogLevel() >= 1 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff0000EMERGENCY:\124r " ..
            tostring(text))
    end
end

function Clockwork.log.alert(text)
    if Clockwork.getLogLevel() >= 2 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff0000ALERT:\124r     " ..
            tostring(text))
    end
end

function Clockwork.log.critical(text)
    if Clockwork.getLogLevel() >= 3 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff0000CRITICAL:\124r  " ..
            tostring(text))
    end
end

function Clockwork.log.error(text)
    if Clockwork.getLogLevel() >= 4 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff0000ERROR:\124r     " ..
            tostring(text))
    end
end

function Clockwork.log.warning(text)
    if Clockwork.getLogLevel() >= 5 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff9933WARNING:\124r   " ..
            tostring(text))
    end
end

function Clockwork.log.notice(text)
    if Clockwork.getLogLevel() >= 6 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFF000000NOTICE:\124r    " ..
            tostring(text))
    end
end

function Clockwork.log.info(text)
    if Clockwork.getLogLevel() >= 7 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFF696969INFO:\124r      " ..
            tostring(text))
    end
end

function Clockwork.log.debug(text)
    if Clockwork.getLogLevel() >= 8 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFF696969DEBUG:\124r     " ..
            tostring(text))
    end
end
