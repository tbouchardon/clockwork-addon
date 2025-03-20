---@alias Clockwork table
Clockwork = {}
---@alias ClockworkEnum table
Clockwork.Enum = {}
---@type GameTooltip
ClockworkTooltip = ClockworkTooltip
---@type {key:string, spellId:number, slot:number, shift:boolean, alt:boolean, ctrl:boolean}[]
Clockwork.commandsBindings = nil
---@alias SpellIdToSlot table<number, {name:string, slot:number}>
Clockwork.spellIdToSlot = {}

---@alias LogLevel "EMERGENCY"|"ALERT"|"CRITICAL"|"ERROR"|"WARNING"|"NOTICE"|"INFO"|"DEBUG"
---@type LogLevel
Clockwork.LOG_LEVEL = 'INFO'
--Clockwork.LOG_LEVEL = 'DEBUG'

---@alias StanceEnum {NONE:0, BEAR:1, CAT:2, TRAVEL:3, MOONKIN:4}
Clockwork.Enum.Stance = {
    NONE = 0,
    BEAR = 1,
    CAT = 2,
    TRAVEL = 3,
    MOONKIN = 4
}
