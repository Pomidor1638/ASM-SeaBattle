
#ifndef _GAME_UPDATE_COUNTERS_ASM_
#define _GAME_UPDATE_COUNTERS_ASM_

FUNCTION _Game_UpdateDeltaTime, 0
    LWI R7, TIMER_BASE_ADDR
    LWD R1, R7

    LOAD_OFFSET_IMM_IMM R2, globalvar_last_time_ptr, RAM_BASE_ADDR

    SUB R0, R1, R2

    LWI R7, _Game_UpdateDeltaTime_return
    JEZ R7, R0

    STORE_OFFSET_IMM_IMM R1, globalvar_last_time_ptr, RAM_BASE_ADDR

_Game_UpdateDeltaTime_return:
ENDFUNCTION

#macro Game_UpdateDeltaTime
    PUSH_PREV_SP
    CALL _Game_UpdateDeltaTime
#endmacro 

FUNCTION _Game_UpdateCounters, 0

    Game_UpdateDeltaTime

    LWI R7, _Game_UpdateCounters_return
    JEZ R7, R0

// bg_blink_counter
    LOAD_OFFSET_IMM_IMM R0, globalvar_bg_blink_counter, RAM_BASE_ADDR
    LWI R7, _Game_UpdateCounters_warning_counter
    JEZ R7, R0
    DEC R0, R0
    STORE_OFFSET_IMM_IMM R0, globalvar_bg_blink_counter, RAM_BASE_ADDR

// warning_counter
_Game_UpdateCounters_warning_counter:
    LOAD_OFFSET_IMM_IMM R0, globalvar_warning_counter, RAM_BASE_ADDR
    LWI R7, _Game_UpdateCounters_cursor_blink_counter
    JEZ R7, R0
    DEC R0, R0
    STORE_OFFSET_IMM_IMM R0, globalvar_warning_counter, RAM_BASE_ADDR

_Game_UpdateCounters_cursor_blink_counter:

    LOAD_OFFSET_IMM_IMM R0, globalvar_cursor_blink_counter, RAM_BASE_ADDR
    LWI R7, _Game_UpdateCounters_cursor_blink_counter_else
    JEZ R7, R0
    DEC R0, R0
    STORE_OFFSET_IMM_IMM R0, globalvar_cursor_blink_counter, RAM_BASE_ADDR

    JMP _Game_UpdateCounters_remote_waiting_counter

_Game_UpdateCounters_cursor_blink_counter_else:
    LWI R0, 5
    STORE_OFFSET_IMM_IMM R0, globalvar_cursor_blink_counter, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R0, globalvar_cursor_visible, RAM_BASE_ADDR
    NOT R0, R0
    STORE_OFFSET_IMM_IMM R0, globalvar_cursor_visible, RAM_BASE_ADDR

_Game_UpdateCounters_remote_waiting_counter:
    LOAD_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR
    LWI R7, _Game_UpdateCounters_dot_counter
    JEZ R7, R0
    DEC R0, R0
    STORE_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR

_Game_UpdateCounters_dot_counter:

    LOAD_OFFSET_IMM_IMM R0, globalvar_dot_counter, RAM_BASE_ADDR
    LWI R7, _Game_UpdateCounters_dot_counter_else
    JEZ R7, R0
    DEC R0, R0
    STORE_OFFSET_IMM_IMM R0, globalvar_dot_counter, RAM_BASE_ADDR

    JMP _Game_UpdateCounters_return

_Game_UpdateCounters_dot_counter_else:

    LWI R0, 16
    STORE_OFFSET_IMM_IMM R0, globalvar_dot_counter, RAM_BASE_ADDR

    LOAD_OFFSET_IMM_IMM  R0, globalvar_dots_count , RAM_BASE_ADDR

    LWI R1, 6 // do not change
    LWI R7, _Game_UpdateCounters_dots_count_reset

    JEQ R7, R0, R1

    INC R0, R0
    INC R0, R0

    JMP _Game_UpdateCounters_dots_count_store

_Game_UpdateCounters_dots_count_reset:
    LWI R0, 0
_Game_UpdateCounters_dots_count_store:
    STORE_OFFSET_IMM_IMM R0, globalvar_dots_count, RAM_BASE_ADDR
    JMP _Game_UpdateCounters_return

_Game_UpdateCounters_return:
ENDFUNCTION

#macro Game_UpdateCounters
    PUSH_PREV_SP
    CALL _Game_UpdateCounters
#endmacro

#endif