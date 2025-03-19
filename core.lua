Clockwork = {}
Clockwork.Enum = {}
---@type GameTooltip
ClockworkTooltip = ClockworkTooltip
---@type {key:string, spellId:number, slot:number, shift:boolean, alt:boolean, ctrl:boolean}[]
Clockwork.commandsBindings = nil
Clockwork.spellIdToSlot = {}

Clockwork.LOG_LEVEL = 'INFO'
--Clockwork.LOG_LEVEL = 'DEBUG'

Clockwork.Enum.Stance = {
    NONE = 0,
    BEAR = 1,
    CAT = 2,
    TRAVEL = 3,
    MOONKIN = 4
}
