#ifndef _GAME_CHOOSE_MODE_ASM_
#define _GAME_CHOOSE_MODE_ASM_


FUNCTION _Game_ChooseMode, 0

    LWI R0, 0
    Video_Clear R0 

_Game_ChooseMode_flush_net:
    NET_CheckPacket
    LWI R7, _Game_ChooseMode_flushed
    JEZ R7, R0

    NET_PopPacket
    JMP _Game_ChooseMode_flush_net

_Game_ChooseMode_flushed:

// if (Input_IsKeyJustPressed(globalvar_keystate_offset_up)) server_mode = 0x1
// if (Input_IsKeyJustPressed(globalvar_keystate_offset_down)) server_mode = 0x0
// if (Input_IsKeyJustPressed(globalvar_keystate_offset_return)) game_state = STATE_WAIT_FOR_CONNECTION

    Input_IsKeyJustPressed globalvar_keystate_offset_up
    LWI R7, _Game_ChooseMode_check_down_pressed
    JEZ R7, R0
    LWI R0,  0
    STORE_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR

    JMP _Game_ChooseMode_check_down_pressed

_Game_ChooseMode_check_down_pressed:

    Input_IsKeyJustPressed globalvar_keystate_offset_down
    LWI R7, _Game_ChooseMode_check_enter_pressed
    JEZ R7, R0
    LWI R0,  1
    STORE_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR

    JMP _Game_ChooseMode_check_enter_pressed

_Game_ChooseMode_check_enter_pressed:

    Input_IsKeyJustPressed globalvar_keystate_offset_return
    LWI R7, _Game_ChooseMode_draw
    JEZ R7, R0
    LWI R0,  STATE_WAIT_FOR_CONNECTION
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR
    JMP _Game_ChooseMode_draw

_Game_ChooseMode_draw:
    Video_ChooseMode
    Video_Present
_Game_ChooseMode_return:
ENDFUNCTION

#macro Game_ChooseMode
    PUSH_PREV_SP
    CALL _Game_ChooseMode
#endmacro

#endif 