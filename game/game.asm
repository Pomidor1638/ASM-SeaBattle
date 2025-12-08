#ifndef _GAME_ASM_
#define _GAME_ASM_


#include "../sys/sys.asm"
#include "../globalvars/globalvars.asm"
#include "../video/video.asm"
#include "../keyboard/keyboard.asm"
#include "../net/net.asm"

FUNCTION _UpdateWaitRemote, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_wait_remote, RAM_BASE_ADDR
    LWI R7, _UpdateWaitRemote_return
    JEZ R7, R0

    LOAD_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR
    LWI R7, _UpdateWaitRemote_return
    JNZ R7, R0

_UpdateWaitRemote_remote_waiting_attemps_else:

    

_UpdateWaitRemote_return:
ENDFUNCTION

#macro UpdateWaitRemote
    PUSH_PREV_SP
    CALL _UpdateWaitRemote
#endmacro 

FUNCTION _HandleCursorMovement, 0

    Input_IsKeyJustPressed globalvar_keystate_offset_up

    LWI R5, _HandleCursorMovement_pressed_down
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_y, RAM_BASE_ADDR

    JEZ R5, R1
    DEC R1, R1
    
    SWD R7, R1

_HandleCursorMovement_pressed_down:

    Input_IsKeyJustPressed globalvar_keystate_offset_down

    LWI R5, _HandleCursorMovement_pressed_left
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_y, RAM_BASE_ADDR
    LWI R2, 9 // HEIGHT - 1
    JEQ R5, R1, R2
    INC R1, R1
    SWD R7, R1

_HandleCursorMovement_pressed_left:

    Input_IsKeyJustPressed globalvar_keystate_offset_left

    LWI R5, _HandleCursorMovement_pressed_right
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_x, RAM_BASE_ADDR

    JEZ R5, R1
    DEC R1, R1
    
    SWD R7, R1

_HandleCursorMovement_pressed_right:

    Input_IsKeyJustPressed globalvar_keystate_offset_right

    LWI R5, _HandleCursorMovement_pressed_r
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_x, RAM_BASE_ADDR
    LWI R2, 9 // HEIGHT - 1
    JEQ R5, R1, R2
    INC R1, R1
    SWD R7, R1

_HandleCursorMovement_pressed_r:

    Input_IsKeyJustPressed globalvar_keystate_offset_r

    LWI R5, _HandleCursorMovement_return
    JEZ R5, R0

    LWI R7, RAM_BASE_ADDR
    LWI R6, globalvar_ship_placement_state
    ADD R6, R6, R7
    LWI R7, cur_ship_state_t_horizontal_offset
    ADD R6, R6, R7

    LWD R1, R6
    NOT R1, R1
    SWD R6, R1

_HandleCursorMovement_return:
ENDFUNCTION

#macro HandleCursorMovement
    PUSH_PREV_SP 
    CALL _HandleCursorMovement
#endmacro

#include "game_choosemode.asm"
#include "game_wait_for_connection.asm"
#include "game_update_counters.asm"
#include "game_placingships.asm"

#macro Game_Init

    LWI R0, 0
    STORE_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR

    LWI R0, STATE_PLACING_SHIPS
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state , RAM_BASE_ADDR

#endmacro

FUNCTION _Game_Tick, 0

    Game_UpdateCounters
    Input_Update_Keyboard_states
    
    LOAD_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR

    LWI R7, _Game_Tick_wait_for_connection
    LWI R6, STATE_CHOOSE_MODE
    JNQ R7, R0, R6
    Game_ChooseMode
    RETURN

_Game_Tick_wait_for_connection:
    LWI R7, _Game_Tick_placing_ships
    LWI R6, STATE_WAIT_FOR_CONNECTION
    JNQ R7, R0, R6
    Game_WaitForConnection
    RETURN

_Game_Tick_placing_ships:
    LWI R7, _Game_Tick_return
    LWI R6, STATE_PLACING_SHIPS
    JNQ R7, R0, R6
    Game_PlacingShips
    RETURN



_Game_Tick_return:
ENDFUNCTION

#macro Game_Tick

    PUSH_PREV_SP
    CALL _Game_Tick

#endmacro 

#endif