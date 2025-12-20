#ifndef _GAME_MAIN_GAME_ASM_
#define _GAME_MAIN_GAME_ASM_

FUNCTION _Game_SendMyCursorToEnemy, 0

    LOAD_SP R6

    // if (isKeyJustPressed(SDL_SCANCODE_RETURN))
    Input_IsKeyJustPressed globalvar_keystate_offset_return
    LWI R7, _Game_SendMyCursorToEnemy_check_cursor_counter
    JEZ R7, R0

    // outgoing_packet.type = PACKET_SHOOT_REQUEST;
    LWI R0, NET_BASE_ADDR
    LWI R1, NET_SEND_PACKET
    ADD R0, R0, R1
    LWI R1, PACKET_SHOOT_REQUEST
    SWD R0, R1

    // outgoing_packet.data[0] = my_cursor_x;
    INC R0, R0
    LWI R1, RAM_BASE_ADDR
    LWI R2, globalvar_my_cursor_x
    ADD R1, R1, R2
    LWD R1, R1
    SWD R0, R1

    // outgoing_packet.data[1] = my_cursor_y;
    INC R0, R0
    LWI R1, RAM_BASE_ADDR
    LWI R2, globalvar_my_cursor_y
    ADD R1, R1, R2
    LWD R1, R1
    SWD R0, R1

    // if (server_mode)
    LWI R0, RAM_BASE_ADDR
    LWI R1, globalvar_server_mode
    ADD R0, R0, R1
    LWD R0, R0
    
    LWI R7, _Game_SendMyCursorToEnemy_start_wait
    JEZ R7, R0

    // ServerShoot();
    //Game_ServerShoot

_Game_SendMyCursorToEnemy_start_wait:
    // StartWaitRemote();
    Game_StartWaitRemote

    // SendPacket();
    NET_SendPacket
    
    JMP _Game_SendMyCursorToEnemy_return

_Game_SendMyCursorToEnemy_check_cursor_counter:
    // else if (!cursor_send_counter)
    LWI R0, RAM_BASE_ADDR
    LWI R1, globalvar_cursor_send_counter
    ADD R0, R0, R1
    LWD R0, R0
    
    LWI R7, _Game_SendMyCursorToEnemy_return
    JNZ R7, R0

    // outgoing_packet.type = PACKET_CURSOR_POS;
    LWI R0, NET_BASE_ADDR
    LWI R1, NET_SEND_PACKET
    ADD R0, R0, R1
    LWI R1, PACKET_CURSOR_POS
    SWD R0, R1

    // outgoing_packet.data[0] = my_cursor_x;
    INC R0, R0
    LWI R1, RAM_BASE_ADDR
    LWI R2, globalvar_my_cursor_x
    ADD R1, R1, R2
    LWD R1, R1
    SWD R0, R1

    // outgoing_packet.data[1] = my_cursor_y;
    INC R0, R0
    LWI R1, RAM_BASE_ADDR
    LWI R2, globalvar_my_cursor_y
    ADD R1, R1, R2
    LWD R1, R1
    SWD R0, R1

    // SendPacket();
    NET_SendPacket

_Game_SendMyCursorToEnemy_return:
ENDFUNCTION

#macro Game_SendMyCursorToEnemy
    PUSH_PREV_SP
    CALL _Game_SendMyCursorToEnemy
#endmacro






































FUNCTION _Game_HandleMyTurnInput, 0

    Game_HandleCursorMovement
    Game_SendMyCursorToEnemy

ENDFUNCTION

#macro Game_HandleMyTurnInput
    PUSH_PREV_SP
    CALL _Game_HandleMyTurnInput
#endmacro







FUNCTION _Game_Server_HandleShootRequest, 3

    #define _Game_Server_HandleShootRequest_localvar_cell 3  // 2 words: state, ship_index
    #define _Game_Server_HandleShootRequest_localvar_ship_ptr 5

ENDFUNCTION

#macro Game_Server_HandleShootRequest
    PUSH_PREV_SP
    CALL _Game_Server_HandleShootRequest
#endmacro











FUNCTION _ProcessReceivedCell, 0



ENDFUNCTION







#macro ProcessReceivedCell placement_state, state, s, x, y
    PUSH_PREV_SP

    PUSH y
    PUSH x
    PUSH s
    PUSH state
    PUSH placement_state

    CALL _ProcessReceivedCell
#endmacro


FUNCTION _Game_Client_HandleShootRequest, 0


    // ship_t* s = NULL;
    LWI R2, 0x0000

    // incomming_packet.data[0];
    OFFSET_IMM_IMM R3, NET_RECV_PACKET, NET_BASE_ADDR
    INC R3, R3

    // cellstate_t state = incomming_packet.data[0];
    LWD R1, R3

    // enemy_cursor_x = incomming_packet.data[1];
    INC R3, R3 
    LWD R4, R3
    STORE_OFFSET_IMM_IMM R4, globalvar_enemy_cursor_x, RAM_BASE_ADDR

    // enemy_cursor_y = incomming_packet.data[2];
    INC R3, R3 
    LWD R4, R3
    STORE_OFFSET_IMM_IMM R4, globalvar_enemy_cursor_y, RAM_BASE_ADDR

    // if (state == CELL_SUNK)
    LWI R7, _Game_Client_HandleShootRequest_process_cell
    LWI R6, CELL_SUNK
    JNQ R7, R1, R6

    // s = enemy_placement_state.ships;
    LOAD_OFFSET_IMM_IMM R2, globalvar_enemy_placement_state, RAM_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R2, R2, placement_state_t_ships_offset

    // s->x = incomming_packet.data[3];
    OFFSET_STRUCT_REG_IMM R5, R2, ship_t_x_offset
    INC R3, R3
    LWD R4, R3
    SWD R5, R4

    // s->y = incomming_packet.data[4];
    OFFSET_STRUCT_REG_IMM R5, R2, ship_t_y_offset
    INC R3, R3
    LWD R4, R3
    SWD R5, R4

    // s->size = incomming_packet.data[5];
    OFFSET_STRUCT_REG_IMM R5, R2, ship_t_size_offset
    INC R3, R3
    LWD R4, R3
    SWD R5, R4
    
    // s->horizontal = incomming_packet.data[6];
    OFFSET_STRUCT_REG_IMM R5, R2, ship_t_horizontal_offset
    INC R3, R3
    LWD R4, R3
    SWD R5, R4

_Game_Client_HandleShootRequest_process_cell:

    OFFSET_IMM_IMM R0, globalvar_my_placement_state, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R3, globalvar_enemy_cursor_x, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R4, globalvar_enemy_cursor_y, RAM_BASE_ADDR

    ProcessReceivedCell R0, R1, R2, R3, R4

    LWI R0, PACKET_SHOOT_RESPONSE

    STORE_OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR


    NET_SendPacket
    Game_EndWaitRemote

ENDFUNCTION

#macro Game_Client_HandleShootRequest
    PUSH_PREV_SP
    CALL _Game_Client_HandleShootRequest
#endmacro











FUNCTION _Game_HandleShootRequest, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR
    LWI R7, _Game_HandleShootRequest_not_server
    JEZ R7, R0

    Game_Server_HandleShootRequest

    JMP _Game_HandleShootRequest_return

_Game_HandleShootRequest_not_server:

    Game_Client_HandleShootRequest

_Game_HandleShootRequest_return:
ENDFUNCTION

#macro Game_HandleShootRequest
    PUSH_PREV_SP
    CALL _Game_HandleShootRequest
#endmacro

























FUNCTION _Game_HandleRemoteInput, 0

    LOAD_SP R6

_Game_HandleRemoteInput_check_loop:
    // while (Check_Packet())
    NET_CheckPacket
    LWI R7, _Game_HandleRemoteInput_return
    JEZ R7, R0

    // Pop_Packet();
    NET_PopPacket

    // R0 = &incoming_packet
    LWI R0, NET_BASE_ADDR
    LWI R1, NET_RECV_PACKET
    ADD R0, R0, R1
    
    // R1 = incoming_packet.type
    LWD R1, R0

    // switch (incomming_packet.type)
    // case PACKET_CURSOR_POS:
    LWI R7, _Game_HandleRemoteInput_check_shoot_request
    LWI R2, PACKET_CURSOR_POS
    JNQ R7, R1, R2

    // enemy_cursor_x = incomming_packet.data[0];
    INC R0, R0  // &incoming_packet.data[0]
    LWD R1, R0
    LWI R2, RAM_BASE_ADDR
    LWI R3, globalvar_enemy_cursor_x
    ADD R2, R2, R3
    SWD R2, R1

    // enemy_cursor_y = incomming_packet.data[1];
    INC R0, R0
    LWD R1, R0
    LWI R2, RAM_BASE_ADDR
    LWI R3, globalvar_enemy_cursor_y
    ADD R2, R2, R3
    SWD R2, R1

    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_shoot_request:
    // case PACKET_SHOOT_REQUEST:
    LWI R7, _Game_HandleRemoteInput_check_shoot_response
    LWI R2, PACKET_SHOOT_REQUEST
    JNQ R7, R1, R2

    // HandleShootRequest();
    Game_HandleShootRequest
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_shoot_response:
    // case PACKET_SHOOT_RESPONSE:
    LWI R7, _Game_HandleRemoteInput_check_turn_request
    LWI R2, PACKET_SHOOT_RESPONSE
    JNQ R7, R1, R2

    // HandleShootResponse();
    // Game_HandleShootResponse
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_turn_request:
    // case PACKET_TURN_SWITCH_REQUEST:
    LWI R7, _Game_HandleRemoteInput_check_turn_response
    LWI R2, PACKET_TURN_SWITCH_REQUEST
    JNQ R7, R1, R2

    // HandleTurnRequest();
    // Game_HandleTurnRequest
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_turn_response:
    // case PACKET_TURN_SWITCH_RESPONSE:
    LWI R7, _Game_HandleRemoteInput_check_end_game_request
    LWI R2, PACKET_TURN_SWITCH_RESPONSE
    JNQ R7, R1, R2

    // HandleTurnResponse();
    // Game_HandleTurnResponse
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_end_game_request:
    // case PACKET_END_GAME_REQUEST:
    LWI R7, _Game_HandleRemoteInput_check_end_game_response
    LWI R2, PACKET_END_GAME_REQUEST
    JNQ R7, R1, R2

    // HandleEndGameRequest();
    // Game_HandleEndGameRequest
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_end_game_response:
    // case PACKET_END_GAME_RESPONSE:
    LWI R7, _Game_HandleRemoteInput_default
    LWI R2, PACKET_END_GAME_RESPONSE
    JNQ R7, R1, R2

    // HandleEndGameResponse();
    // Game_HandleEndGameResponse
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_default:
    // default: break;
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_return:
ENDFUNCTION

#macro Game_HandleRemoteInput
    PUSH_PREV_SP
    CALL _Game_HandleRemoteInput
#endmacro



























FUNCTION _Game_MainGame, 0

    LOAD_SP R6

    // if (UpdateWaitRemote()) return;
    Game_UpdateWaitRemote
    LWI R7, _Game_MainGame_return
    JNZ R7, R0          // if UpdateWaitRemote returns non-zero, return

    // if (bg_blink_counter) { Video_Clear(1); } else { Video_Clear(0); }
    LOAD_OFFSET_IMM_IMM R0, globalvar_bg_blink_counter, RAM_BASE_ADDR
    LWI R7, _Game_MainGame_clear_bg_zero
    JEZ R7, R0
    
    // bg_blink_counter != 0
    LWI R0, 1
    Video_Clear R0
    JMP _Game_MainGame_draw_turn

_Game_MainGame_clear_bg_zero:
    LWI R0, 0
    Video_Clear R0

_Game_MainGame_draw_turn:
    // if (my_turn) { Video_DrawMyTurn(); } else { Video_DrawEnemyTurn(); }
    LOAD_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR
    LWI R7, _Game_MainGame_draw_enemy_turn
    JEZ R7, R0
    Video_DrawMyTurn
    JMP _Game_MainGame_check_wait_remote

_Game_MainGame_draw_enemy_turn:
    Video_DrawEnemyTurn

_Game_MainGame_check_wait_remote:
    // if (wait_remote)
    LOAD_OFFSET_IMM_IMM R0, globalvar_wait_remote, RAM_BASE_ADDR
    LWI R7, _Game_MainGame_handle_local_input
    JEZ R7, R0
    
    // Video_DrawWaitRemote();
    Video_DrawWaitRemote
    JMP _Game_MainGame_handle_remote_input

_Game_MainGame_handle_local_input:
    // else
    // if (all_ships_destroyed)
    LOAD_OFFSET_IMM_IMM R0, globalvar_all_ships_destroyed, RAM_BASE_ADDR
    LWI R7, _Game_MainGame_check_need_switch
    JEZ R7, R0
    
    // outgoing_packet.type = PACKET_END_GAME_REQUEST;
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_END_GAME_REQUEST
    SWD R0, R1
    
    // SendPacket();
    NET_SendPacket
    
    // StartWaitRemote();
    Game_StartWaitRemote
    JMP _Game_MainGame_handle_remote_input

_Game_MainGame_check_need_switch:
    // else if (need_switch)
    LOAD_OFFSET_IMM_IMM R0, globalvar_need_switch, RAM_BASE_ADDR
    LWI R7, _Game_MainGame_check_my_turn
    JEZ R7, R0
    
    // need_switch = false;
    LWI R0, 0
    STORE_OFFSET_IMM_IMM R0, globalvar_need_switch, RAM_BASE_ADDR
    
    // outgoing_packet.type = PACKET_TURN_SWITCH_REQUEST;
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_TURN_SWITCH_REQUEST
    SWD R0, R1
    
    // SendPacket();
    NET_SendPacket
    
    // StartWaitRemote();
    Game_StartWaitRemote
    JMP _Game_MainGame_handle_remote_input

_Game_MainGame_check_my_turn:
    // else { if (my_turn) { HandleMyTurnInput(); } }
    LOAD_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR
    LWI R7, _Game_MainGame_handle_remote_input
    JEZ R7, R0
    
    // HandleMyTurnInput();
    Game_HandleMyTurnInput

_Game_MainGame_handle_remote_input:
    // HandleRemoteInput();
    Game_HandleRemoteInput

_Game_MainGame_return:
ENDFUNCTION

#macro Game_MainGame
    PUSH_PREV_SP
    CALL _Game_MainGame
#endmacro

#endif