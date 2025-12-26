#ifndef _GAME_ERROR_ASM_
#define _GAME_ERROR_ASM_

_Game_Error_str1:
    .string "UNEXCEPTED ERROR"

_Game_Error_str2:
    .string "CPU IS HALTED"

FUNCTION _Game_Error, 0

    LWI R0, 1
    Video_Clear R0

    LWI R0, _Game_Error_str1
    LWI R1, 14
    LWI R2, 0
    LWI R3, 1
    Video_PrintCentered R0, R1, R2, R3
    
    LWI R0, _Game_Error_str2
    LWI R1, 16
    LWI R2, 0
    LWI R3, 1
    Video_PrintCentered R0, R1, R2, R3

    Video_Present

    HLT

ENDFUNCTION

#macro Game_Error
    PUSH_PREV_SP
    CALL _Game_Error
#endmacro

#endif