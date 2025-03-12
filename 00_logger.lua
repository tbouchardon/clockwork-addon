function clockWork.getLogLevel()


    if (clockWork.LOG_LEVEL == 'EMERGENCY') then return 1 end -- Emergency is unusable (Unfixable)
    if (clockWork.LOG_LEVEL == 'ALERT') then return 2 end     -- Alert is unsecure
    if (clockWork.LOG_LEVEL == 'CRITICAL') then return 3 end  -- Critical is stateful
    if (clockWork.LOG_LEVEL == 'ERROR') then return 4 end     -- Error is unstable
    if (clockWork.LOG_LEVEL == 'WARNING') then return 5 end   -- Warning is undesired
    if (clockWork.LOG_LEVEL == 'NOTICE') then return 6 end    -- Notice is relevant
    if (clockWork.LOG_LEVEL == 'INFO') then return 7 end      -- Informational is statistical
    if (clockWork.LOG_LEVEL == 'DEBUG') then return 8 end     -- Debug is development
    return 5
end

clockWork.log = {}

function clockWork.log.notice(text)

    DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: " .. tostring(text))
end

function clockWork.log.emergency(text)
    if clockWork.getLogLevel() >= 1 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: \124cFFff0000EMERGENCY:\124r " ..
            tostring(text))
    end
end

function clockWork.log.alert(text)
    if clockWork.getLogLevel() >= 2 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: \124cFFff0000ALERT:\124r     " ..
            tostring(text))
    end
end

function clockWork.log.critical(text)
    if clockWork.getLogLevel() >= 3 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: \124cFFff0000CRITICAL:\124r  " ..
            tostring(text))
    end
end

function clockWork.log.error(text)
    if clockWork.getLogLevel() >= 4 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: \124cFFff0000ERROR:\124r     " ..
            tostring(text))
    end
end

function clockWork.log.warning(text)
    if clockWork.getLogLevel() >= 5 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: \124cFFff9933WARNING:\124r   " ..
            tostring(text))
    end
end

function clockWork.log.notice(text)
    if clockWork.getLogLevel() >= 6 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: \124cFF000000NOTICE:\124r    " ..
            tostring(text))
    end
end

function clockWork.log.info(text)
    if clockWork.getLogLevel() >= 7 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: \124cFF696969INFO:\124r      " ..
            tostring(text))
    end
end

function clockWork.log.debug(text)
    if clockWork.getLogLevel() >= 8 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockWork\124r: \124cFF696969DEBUG:\124r     " ..
            tostring(text))
    end
end
