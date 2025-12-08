#ifndef _VIDEO_CHOOSEMODE_ASM_
#define _VIDEO_CHOOSEMODE_ASM_


_Video_ChooseMode_ChooseMode_str:
    .string "CHOOSE DEVICE MODE"
_Video_ChooseMode_SeaBattle_str:
    .string "SEA BATTLE"
_Video_ChooseMode_client_str:
    .string " client"
_Video_ChooseMode_server_str:
    .string " server"
_Video_ChooseMode_CLIENT_str:
    .string ">CLIENT"
_Video_ChooseMode_SERVER_str:
    .string ">SERVER"

_Video_ChooseMode_Press_UP_DOWN_to_change_str:
    .string "Press UP/DOWN to change"
_Video_ChooseMode_Press_ENTER_to_confirm_str:
    .string "Press ENTER to confirm"

FUNCTION _Video_ChooseMode, 0

    
    LWI R0, _Video_ChooseMode_SeaBattle_str
    LWI R1, 3  // y
    LWI R2, 2  // fg
    LWI R3, 14 // bg

    Video_PrintCentered R0, R1, R2, R3

    LWI R0, _Video_ChooseMode_ChooseMode_str
    LWI R1, 5 // y
    LWI R2, 2 // fg
    LWI R3, 0 // bg

    Video_PrintCentered R0, R1, R2, R3

    LWI R0, _Video_ChooseMode_Press_UP_DOWN_to_change_str
    LWI R1, 27 //  y
    LWI R2, 14 // fg
    LWI R3,  0 // bg

    Video_PrintCentered R0, R1, R2, R3

    LWI R0, _Video_ChooseMode_Press_ENTER_to_confirm_str
    LWI R1, 28 //  y
    LWI R2, 14 // fg
    LWI R3,  0 // bg

    Video_PrintCentered R0, R1, R2, R3

    LOAD_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR

    LWI R7, _Video_ChooseMode_client_mode
    JEZ R7, R0

    LWI R0, _Video_ChooseMode_client_str
    LWI R1, 13 //  y // WIDTH / 2 - 2
    LWI R2,  2 // fg
    LWI R3,  0 // bg

    Video_PrintCentered R0, R1, R2, R3

    LWI R0, _Video_ChooseMode_SERVER_str
    LWI R1, 17 //  y // WIDTH / 2 + 2
    LWI R2,  0 // fg
    LWI R3,  2 // bg

    Video_PrintCentered R0, R1, R2, R3

    RETURN

_Video_ChooseMode_client_mode:

    LWI R0, _Video_ChooseMode_CLIENT_str
    LWI R1, 13 //  y // WIDTH / 2 - 2
    LWI R2,  0 // fg
    LWI R3,  2 // bg

    Video_PrintCentered R0, R1, R2, R3

    LWI R0, _Video_ChooseMode_server_str
    LWI R1, 17 //  y // WIDTH / 2 + 2
    LWI R2,  2 // fg
    LWI R3,  0 // bg

    Video_PrintCentered R0, R1, R2, R3

ENDFUNCTION

#macro Video_ChooseMode
    PUSH_PREV_SP
    CALL _Video_ChooseMode
#endmacro

#endif