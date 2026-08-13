#ifndef _VIDEO_GAME_END_ASM_
#define _VIDEO_GAME_END_ASM_

_Video_GameEnd_victory:
    .string "VICTORY"
_Video_GameEnd_defeat:
    .string "DEFEAT"
_Video_GameEnd_press_return:
    .string "Press ENTER to continue"

FUNCTION _Video_GameEnd, 1

    #define _Video_GameEnd_localvar_c 3

    LOAD_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR
    LWI R7, _Video_GameEnd_not_my_turn
    JEZ R7, R0

    LWI R0, 2

    JMP _Video_GameEnd_clear

_Video_GameEnd_not_my_turn:

    LWI R0, 1

_Video_GameEnd_clear:

    LOAD_SP R6
    STORE_OFFSET_IMM_REG R0, _Video_GameEnd_localvar_c, R6

    LOAD_OFFSET_IMM_IMM R1, globalvar_end_game_blink, RAM_BASE_ADDR
    LWI R7, _Video_GameEnd_black
    JEZ R7, R1

    Video_Clear R0

    JMP _Video_GameEnd_draw_vic_def

_Video_GameEnd_black:

    LWI R1, 0
    Video_Clear R1


_Video_GameEnd_draw_vic_def:


    LOAD_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR
    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R2, _Video_GameEnd_localvar_c, R6

    LWI R7, _Video_GameEnd_end_draw_defeat
    JEZ R7, R0

    LWI R0, _Video_GameEnd_victory
    LWI R1, 15
    LWI R3, 0

    Video_PrintCentered R0, R1, R2, R3

    JMP _Video_GameEnd_end_game_counter

_Video_GameEnd_end_draw_defeat:

    LWI R0, _Video_GameEnd_defeat
    LWI R1, 15
    LWI R3, 0

    Video_PrintCentered R0, R1, R2, R3

_Video_GameEnd_end_game_counter:

    LOAD_OFFSET_IMM_IMM R0, globalvar_end_game_counter, RAM_BASE_ADDR
    LWI R7, _Video_GameEnd_return
    JNZ R7, R0

    LWI R0, _Video_GameEnd_press_return
    LWI R1, 28
    LWI R2, 14
    LWI R3, 0
    
    Video_PrintCentered R0, R1, R2, R3

_Video_GameEnd_return:
ENDFUNCTION


#macro Video_GameEnd
    PUSH_PREV_SP
    CALL _Video_GameEnd
#endmacro


#endif