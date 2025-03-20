--- Gets the current log level as a numerical value.
--- @return number
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

--- Logs a plain text message.
--- @param text string
--- @return nil
function Clockwork.log.text(text)
    DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: " .. tostring(text))
end

--- Logs an emergency level message.
--- @param text string
--- @return nil
function Clockwork.log.emergency(text)
    if Clockwork.getLogLevel() >= 1 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff0000EMERGENCY:\124r " ..
            tostring(text))
    end
end

--- Logs an alert level message.
--- @param text string
--- @return nil
function Clockwork.log.alert(text)
    if Clockwork.getLogLevel() >= 2 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff0000ALERT:\124r     " ..
            tostring(text))
    end
end

--- Logs a critical level message.
--- @param text string
--- @return nil
function Clockwork.log.critical(text)
    if Clockwork.getLogLevel() >= 3 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff0000CRITICAL:\124r  " ..
            tostring(text))
    end
end

--- Logs an error level message.
--- @param text string
--- @return nil
function Clockwork.log.error(text)
    if Clockwork.getLogLevel() >= 4 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff0000ERROR:\124r     " ..
            tostring(text))
    end
end

--- Logs a warning level message.
--- @param text string
--- @return nil
function Clockwork.log.warning(text)
    if Clockwork.getLogLevel() >= 5 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFFff9933WARNING:\124r   " ..
            tostring(text))
    end
end

--- Logs a notice level message.
--- @param text string
--- @return nil
function Clockwork.log.notice(text)
    if Clockwork.getLogLevel() >= 6 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFF000000NOTICE:\124r    " ..
            tostring(text))
    end
end

--- Logs an info level message.
--- @param text string
--- @return nil
function Clockwork.log.info(text)
    if Clockwork.getLogLevel() >= 7 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFF696969INFO:\124r      " ..
            tostring(text))
    end
end

--- Logs a debug level message.
--- @param text string
--- @return nil
function Clockwork.log.debug(text)
    if Clockwork.getLogLevel() >= 8 then
        DEFAULT_CHAT_FRAME:AddMessage("\124cFF607d8bClockwork\124r: \124cFF696969DEBUG:\124r     " ..
            tostring(text))
    end
end

--- Dumps the value to the log, with indentation for tables.
--- @param value any
--- @param indent string?
--- @param depth number?
--- @return nil
function Clockwork.log.dump(value, indent, depth)
    indent = indent or ""
    depth = depth or 0

    if depth > 5 then -- Limit recursion depth
        print(indent .. "...")
        return
    end

    if type(value) == "table" then
        print(indent .. "{")
        for k, v in pairs(value) do
            if type(k) == "number" then
                print(indent .. "  [" .. k .. "] = " .. tostring(v))
            else
                print(indent .. "  " .. k .. " = " .. tostring(v))
            end
            if type(v) == "table" then
                Clockwork.log.dump(v, indent .. "  ", depth + 1)
            end
        end
        print(indent .. "}")
    elseif type(value) == "string" then
        print(indent .. "\"" .. value .. "\"")
    else
        print(indent .. tostring(value))
    end
end
