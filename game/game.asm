#ifndef _GAME_ASM_
#define _GAME_ASM_


#include "../sys/sys.asm"
#include "../globalvars/globalvars.asm"
#include "../video/video.asm"
#include "../keyboard/keyboard.asm"
#include "../net/net.asm"





















FUNCTION _Game_UpdateWaitRemote, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_wait_remote, RAM_BASE_ADDR
    LWI R7, _Game_UpdateWaitRemote_return
    JEZ R7, R0

    LOAD_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR
    LWI R7, _Game_UpdateWaitRemote_return
    JNZ R7, R0

    LOAD_OFFSET_IMM_IMM R0, globalvar_remote_waiting_attemps, RAM_BASE_ADDR
    LWI R7, _Game_UpdateWaitRemote_remote_waiting_send_packet
    JNZ R7, R0

    LWI R0, PACKET_REMOTE_ERROR
    STORE_OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    NET_SendPacket
    LWI R0, STATE_ERROR
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR 

    LWI R0, 0xffff
    RETURN

_Game_UpdateWaitRemote_remote_waiting_send_packet:

    LOAD_OFFSET_IMM_IMM R0, globalvar_remote_waiting_attemps, RAM_BASE_ADDR
    DEC R0, R0
    SWD R7, R0

    LWI R0, 100
    STORE_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR
    NET_SendPacket    

_Game_UpdateWaitRemote_return:
    LWI R0, 0x0000
ENDFUNCTION

#macro Game_UpdateWaitRemote
    PUSH_PREV_SP
    CALL _Game_UpdateWaitRemote
#endmacro 





















FUNCTION _Game_HandleCursorMovement, 0

    Input_IsKeyJustPressed globalvar_keystate_offset_up

    LWI R5, _Game_HandleCursorMovement_pressed_down
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_y, RAM_BASE_ADDR

    JEZ R5, R1
    DEC R1, R1
    
    SWD R7, R1

_Game_HandleCursorMovement_pressed_down:

    Input_IsKeyJustPressed globalvar_keystate_offset_down

    LWI R5, _Game_HandleCursorMovement_pressed_left
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_y, RAM_BASE_ADDR
    LWI R2, 9 // FIELD_SIZE - 1
    JEQ R5, R1, R2
    INC R1, R1
    SWD R7, R1

_Game_HandleCursorMovement_pressed_left:

    Input_IsKeyJustPressed globalvar_keystate_offset_left

    LWI R5, _Game_HandleCursorMovement_pressed_right
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_x, RAM_BASE_ADDR

    JEZ R5, R1
    DEC R1, R1
    
    SWD R7, R1

_Game_HandleCursorMovement_pressed_right:

    Input_IsKeyJustPressed globalvar_keystate_offset_right

    LWI R5, _Game_HandleCursorMovement_return
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_x, RAM_BASE_ADDR
    LWI R2, 9 // FIELD_SIZE - 1
    JEQ R5, R1, R2
    INC R1, R1
    SWD R7, R1

_Game_HandleCursorMovement_return:
ENDFUNCTION

#macro Game_HandleCursorMovement
    PUSH_PREV_SP
    CALL _Game_HandleCursorMovement
#endmacro





















FUNCTION _Game_StartWaitRemote, 0

    LWI R0, 0xffff
    STORE_OFFSET_IMM_IMM R0, globalvar_wait_remote, RAM_BASE_ADDR

    LWI R0, 5
    STORE_OFFSET_IMM_IMM R0, globalvar_remote_waiting_attemps, RAM_BASE_ADDR

    LWI R0, 100
    STORE_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR

    

ENDFUNCTION

#macro Game_StartWaitRemote
    PUSH_PREV_SP
    CALL _Game_StartWaitRemote
#endmacro























FUNCTION _Game_EndWaitRemote, 0

    LWI R0, 0
    STORE_OFFSET_IMM_IMM R0, globalvar_wait_remote, RAM_BASE_ADDR

    LWI R0, 0
    STORE_OFFSET_IMM_IMM R0, globalvar_remote_waiting_attemps, RAM_BASE_ADDR

    LWI R0, 0
    STORE_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR

ENDFUNCTION

#macro Game_EndWaitRemote
    PUSH_PREV_SP
    CALL _Game_EndWaitRemote
#endmacro

#include "game_choosemode.asm"
#include "game_wait_for_connection.asm"
#include "game_update_counters.asm"
#include "game_placingships.asm"





















#macro Game_Init

    LWI R0, 0xffff
    STORE_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR

    LWI R0, STATE_PLACING_SHIPS //STATE_CHOOSE_MODE
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
    JMP _Game_Tick_return

_Game_Tick_wait_for_connection:
    LWI R7, _Game_Tick_placing_ships
    LWI R6, STATE_WAIT_FOR_CONNECTION
    JNQ R7, R0, R6
    Game_WaitForConnection
    JMP _Game_Tick_return

_Game_Tick_placing_ships:
    LWI R7, _Game_Tick_return
    LWI R6, STATE_PLACING_SHIPS
    JNQ R7, R0, R6
    Game_PlacingShips
    JMP _Game_Tick_return



_Game_Tick_return:
    Video_Present
ENDFUNCTION

#macro Game_Tick

    PUSH_PREV_SP
    CALL _Game_Tick

#endmacro 

#endif