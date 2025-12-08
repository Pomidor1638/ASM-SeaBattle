#ifndef _VIDEO_WAIT_FOR_REMOTE_ASM_
#define _VIDEO_WAIT_FOR_REMOTE_ASM_

_Video_WaitForConnection_progress_str:
    .string "..." // 0
    .string "*.." // 2
    .string ".*." // 4
    .string "..*" // 6

_Video_WaitForConnection_WAITING_FOR_CONNECTION_str:
    .string "WAITING FOR CONNECTION"

_Video_WaitForConnection_Waiting_for_client_str:
    .string "Waiting for client"

_Video_WaitForConnection_Waiting_for_server_str:
    .string "Waiting for server"

_Video_WaitForConnection_Press_ESC_to_cancel_str:
    .string "Press ESC to cancel"

FUNCTION _Video_WaitForConnection, 0

    LWI R0, 0

    Video_Clear R0

    //Video_PrintCentered reg_str, reg_y, reg_fg_color, reg_bg_color

    LWI R0, _Video_WaitForConnection_WAITING_FOR_CONNECTION_str
    LWI R1, 10 // reg_y
    LWI R2, 7  // reg_fg_color
    LWI R3, 0  // reg_bg_color

    Video_PrintCentered R0, R1, R2, R3
    
    LWI R0, _Video_WaitForConnection_Press_ESC_to_cancel_str
    LWI R1, 27 // reg_y
    LWI R2, 8  // reg_fg_color
    LWI R3, 0  // reg_bg_color

    Video_PrintCentered R0, R1, R2, R3

    LOAD_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR

    LWI R7, _Video_WaitForConnection_print_client
    JEZ R7, R0

    LWI R0, _Video_WaitForConnection_Waiting_for_client_str
    LWI R1, 12 // reg_y
    LWI R2, 7  // reg_fg_color
    LWI R3, 0  // reg_bg_color

    Video_PrintCentered R0, R1, R2, R3

    JMP _Video_WaitForConnection_print_progress

_Video_WaitForConnection_print_client:

    LWI R0, _Video_WaitForConnection_Waiting_for_server_str
    LWI R1, 12 // reg_y
    LWI R2, 7  // reg_fg_color
    LWI R3, 0  // reg_bg_color

    Video_PrintCentered R0, R1, R2, R3

_Video_WaitForConnection_print_progress:

    LWI R0, _Video_WaitForConnection_progress_str
    LOAD_OFFSET_IMM_IMM R1, globalvar_dots_count, RAM_BASE_ADDR

    ADD R0, R0, R1
    
    LWI R1, 14 // reg_y
    LWI R2, 7  // reg_fg_color
    LWI R3, 0  // reg_bg_color

    Video_PrintCentered R0, R1, R2, R3

ENDFUNCTION

#macro Video_WaitForConnection
    PUSH_PREV_SP
    CALL _Video_WaitForConnection
#endmacro

#endif
