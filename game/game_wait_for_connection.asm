#ifndef _GAME_WAIT_FOR_CONNECTION_ 
#define _GAME_WAIT_FOR_CONNECTION_

FUNCTION _Game_WaitForConnection, 0
    
    Input_IsKeyJustPressed globalvar_keystate_offset_escape

    LWI R7, _Game_WaitForConnection_check_loop
    JEZ R7, R0

    LWI R0, STATE_CHOOSE_MODE
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR
    RETURN

_Game_WaitForConnection_check_loop:

    NET_CheckPacket
    LWI R7, _Game_WaitForConnection_send_connection_request
    JEZ R7, R0

    NET_PopPacket

    // if (server_mode)
    LOAD_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR
    LWI R7, _Game_WaitForConnection_client_mode
    JEZ R7, R0

    // if (incomming_packet.type == PACKET_CONNECTION_REQUEST)
    LOAD_OFFSET_IMM_IMM R0, NET_RECV_PACKET, NET_BASE_ADDR
    LWI R6, PACKET_CONNECTION_REQUEST
    LWI R7, _Game_WaitForConnection_check_loop

    JNQ R7, R0, R6

    LWI R0, PACKET_CONNECTION_ACCEPTED
    STORE_OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    NET_SendPacket
    LWI R0, STATE_PLACING_SHIPS
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR

    JMP _Game_WaitForConnection_check_loop

    // else
_Game_WaitForConnection_client_mode:

// if (incomming_packet.type == PACKET_CONNECTION_ACCEPTED)
    LOAD_OFFSET_IMM_IMM R0, NET_RECV_PACKET, NET_BASE_ADDR
    LWI R6, PACKET_CONNECTION_ACCEPTED
    LWI R7, _Game_WaitForConnection_check_loop

    JNQ R7, R0, R6

    LWI R0, STATE_PLACING_SHIPS
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR

    JMP _Game_WaitForConnection_check_loop

_Game_WaitForConnection_send_connection_request:

    LOAD_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR

    LWI R2, _Game_WaitForConnection_draw
    JNZ R2, R0

    LOAD_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR

    JNZ R2, R0

    LWI R0, 32
    STORE_OFFSET_IMM_IMM R0, globalvar_remote_waiting_counter, RAM_BASE_ADDR
    
    LWI R0, PACKET_CONNECTION_REQUEST
    STORE_OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    NET_SendPacket

_Game_WaitForConnection_draw:
    Video_WaitForConnection
    Video_Present
ENDFUNCTION

#macro Game_WaitForConnection

    PUSH_PREV_SP
    CALL _Game_WaitForConnection

#endmacro

#endif