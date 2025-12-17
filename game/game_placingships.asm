#ifndef _GAME_PLACINGSHIPS_
#define _GAME_PLACINGSHIPS_














FUNCTION _Game_PrevShipSize, 3

    #define _Game_PrevShipSize_localvar_index            3
    #define _Game_PrevShipSize_localvar_placed_ships_ptr 4
    #define _Game_PrevShipSize_localvar_i                5

    #define _Game_PrevShipSize_localarg_ship_state_ptr      6
    #define _Game_PrevShipSize_localarg_placement_state_ptr 7

    LOAD_SP R6

    // index
    LOAD_OFFSET_IMM_REG R0, _Game_PrevShipSize_localarg_ship_state_ptr, R6
    LWI R7, cur_ship_state_t_ship_size_index_offset
    ADD R0, R0, R7
    LWD R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_PrevShipSize_localvar_index, R6

    // *places_ships
    LOAD_OFFSET_IMM_REG R0, _Game_PrevShipSize_localarg_placement_state_ptr, R6
    LWI R7, placement_state_t_placed_ships_offset
    ADD R0, R0, R7
    STORE_OFFSET_IMM_REG R0, _Game_PrevShipSize_localvar_placed_ships_ptr, R6

    LWI R0, 1
    STORE_OFFSET_IMM_REG R0, _Game_PrevShipSize_localvar_i, R6
_Game_PrevShipSize_loop:

    LOAD_OFFSET_IMM_REG R0, _Game_PrevShipSize_localvar_i, R6 // R0 - i

    LWI R7, _Game_PrevShipSize_send_error
    LWI R1, MAX_SHIPS_SIZE // R1 - MAX_SHIPS_SIZE

    JPG R7, R0, R1 // i > MAX_SHIPS_SIZE ? jmp _Game_PrevShipSize_send_error 

    LOAD_OFFSET_IMM_REG R3, _Game_PrevShipSize_localvar_index, R6
    SUB R3, R3, R0 // R3 - prev_index

    LWI R7, _Game_PrevShipSize_fix_prev_index
    JLZ R7, R3
    JMP _Game_PrevShipSize_check_count

_Game_PrevShipSize_fix_prev_index:
    ADD R3, R3, R1
_Game_PrevShipSize_check_count:

    // R0 - i
    // R1 - MAX_SHIPS_SIZE
    // R2 - 
    // R3 - prev_index
    // R4 - 
    // R5 - 
    // R6 - SP
    // R7 -

    LOAD_OFFSET_IMM_REG R2, _Game_PrevShipSize_localvar_placed_ships_ptr, R6

    ADD R2, R2, R3
    LWD R2, R2

    // R2 - placed_ships[prev_index]

    LWI R4, globalvar_SHIP_SIZES_AND_COUNT
    LWI R5, 2
    MUL R5, R3, R5
    ADD R4, R4, R5

    LWI R5, ship_placement_t_count_offset
    ADD R4, R4, R5

    LWD R4, R4 // SHIP_SIZES_AND_COUNT[prev_index].count

    LWI R7, _Game_PrevShipSize_return
    
    JPL R7, R2, R4 // placed_ships[prev_index] < SHIP_SIZES_AND_COUNT[prev_index].count

    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_PrevShipSize_localvar_i, R6
    JMP _Game_PrevShipSize_loop

_Game_PrevShipSize_send_error:


   
_Game_PrevShipSize_return:
    LOAD_OFFSET_IMM_REG R0, _Game_PrevShipSize_localarg_ship_state_ptr, R6 // *ship_state
    LWI R7, cur_ship_state_t_ship_size_index_offset 
    ADD R0, R0, R7 // &ship_state->ship_size_index
    SWD R0, R3
    // ship_state->ship_size_index = prev_index

ENDFUNCTION

#macro Game_PrevShipSize ship_state_ptr, placement_state_ptr
    PUSH_PREV_SP

    PUSH placement_state_ptr
    PUSH ship_state_ptr

    CALL _Game_PrevShipSize
#endmacro



















FUNCTION _Game_NextShipSize, 3

    #define _Game_NextShipSize_localvar_index            3
    #define _Game_NextShipSize_localvar_placed_ships_ptr 4
    #define _Game_NextShipSize_localvar_i                5

    #define _Game_NextShipSize_localarg_ship_state_ptr      6
    #define _Game_NextShipSize_localarg_placement_state_ptr 7

    LOAD_SP R6

    // index
    LOAD_OFFSET_IMM_REG R0, _Game_NextShipSize_localarg_ship_state_ptr, R6
    LWI R7, cur_ship_state_t_ship_size_index_offset
    ADD R0, R0, R7
    LWD R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_NextShipSize_localvar_index, R6

    // *places_ships
    LOAD_OFFSET_IMM_REG R0, _Game_NextShipSize_localarg_placement_state_ptr, R6
    LWI R7, placement_state_t_placed_ships_offset
    ADD R0, R0, R7
    STORE_OFFSET_IMM_REG R0, _Game_NextShipSize_localvar_placed_ships_ptr, R6

    LWI R0, 1
    STORE_OFFSET_IMM_REG R0, _Game_NextShipSize_localvar_i, R6

_Game_NextShipSize_loop:

    LOAD_OFFSET_IMM_REG R0, _Game_NextShipSize_localvar_i, R6 // R0 - i

    LWI R7, _Game_NextShipSize_send_error
    LWI R1, MAX_SHIPS_SIZE // R1 - MAX_SHIPS_SIZE

    JPG R7, R0, R1 // i > MAX_SHIPS_SIZE ? jmp _Game_NextShipSize_send_error 

    LOAD_OFFSET_IMM_REG R3, _Game_NextShipSize_localvar_index, R6
    ADD R3, R3, R0 // R3 - next_index

    LWI R7, _Game_NextShipSize_check_count
    LWI R5, MAX_SHIPS_SIZE
    JPL R7, R3, R5
    SUB R3, R3, R1

_Game_NextShipSize_check_count:

    // R0 - i
    // R1 - MAX_SHIPS_SIZE
    // R2 - 
    // R3 - next_index
    // R4 - 
    // R5 - 
    // R6 - SP
    // R7 -

    LOAD_OFFSET_IMM_REG R2, _Game_NextShipSize_localvar_placed_ships_ptr, R6

    ADD R2, R2, R3
    LWD R2, R2

    // R2 - placed_ships[next_index]

    LWI R4, globalvar_SHIP_SIZES_AND_COUNT
    LWI R5, 2
    MUL R5, R3, R5
    ADD R4, R4, R5

    LWI R5, ship_placement_t_count_offset
    ADD R4, R4, R5

    LWD R4, R4 // SHIP_SIZES_AND_COUNT[next_index].count

    LWI R7, _Game_NextShipSize_return
    
    JPL R7, R2, R4 // placed_ships[next_index] < SHIP_SIZES_AND_COUNT[prev_index].count

    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_NextShipSize_localvar_i, R6
    JMP _Game_NextShipSize_loop

_Game_NextShipSize_send_error:

    // ???

_Game_NextShipSize_return:
    LOAD_OFFSET_IMM_REG R0, _Game_NextShipSize_localarg_ship_state_ptr, R6 // *ship_state
    LWI R7, cur_ship_state_t_ship_size_index_offset 
    ADD R0, R0, R7 // &ship_state->ship_size_index
    SWD R0, R3

    // ship_state->ship_size_index = next_index
ENDFUNCTION

#macro Game_NetxShipSize ship_state_ptr, placement_state_ptr
    PUSH_PREV_SP

    PUSH placement_state_ptr
    PUSH ship_state_ptr

    CALL _Game_NextShipSize
#endmacro











FUNCTION _Game_HandleShipMovement, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_my_cursor_x, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_y, RAM_BASE_ADDR

    LWI R7, globalvar_ship_placement_state
    LWI R6, RAM_BASE_ADDR
    ADD R7, R6, R7

    LWI R6, cur_ship_state_t_x_offset
    ADD R6, R7, R6

    SWD R6, R0

    LWI R6, cur_ship_state_t_y_offset
    ADD R6, R7, R6

    SWD R6, R1
    

    Input_IsKeyJustPressed globalvar_keystate_offset_r

    LWI R5, _Game_HandleShipMovement_q_pressed
    JEZ R5, R0

    LWI R7, RAM_BASE_ADDR
    LWI R6, globalvar_ship_placement_state
    ADD R6, R6, R7
    LWI R7, cur_ship_state_t_horizontal_offset
    ADD R6, R6, R7

    LWD R1, R6
    NOT R1, R1
    SWD R6, R1


_Game_HandleShipMovement_q_pressed:

Input_IsKeyJustPressed globalvar_keystate_offset_q

    LWI R5, _Game_HandleShipMovement_e_pressed
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_ship_placement_state, RAM_BASE_ADDR
    MOV R1, R7
    LOAD_OFFSET_IMM_IMM R2, globalvar_my_placement_state  , RAM_BASE_ADDR
    MOV R2, R7
    Game_PrevShipSize R1, R2


_Game_HandleShipMovement_e_pressed:

Input_IsKeyJustPressed globalvar_keystate_offset_e

    LWI R5, _Game_HandleShipMovement_return
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R1, globalvar_ship_placement_state, RAM_BASE_ADDR
    MOV R1, R7
    LOAD_OFFSET_IMM_IMM R2, globalvar_my_placement_state  , RAM_BASE_ADDR
    MOV R2, R7
    Game_NetxShipSize R1, R2



_Game_HandleShipMovement_return:
ENDFUNCTION

#macro Game_HandleShipMovement
    PUSH_PREV_SP
    CALL _Game_HandleShipMovement
#endmacro






FUNCTION _Game_CanPlaceShip, 8

    #define _Game_CanPlaceShip_localvar_size             3
    #define _Game_CanPlaceShip_localvar_ship_x           4
    #define _Game_CanPlaceShip_localvar_ship_y           5
    #define _Game_CanPlaceShip_localvar_horizontal       6
    #define _Game_CanPlaceShip_localvar_check_x          7
    #define _Game_CanPlaceShip_localvar_check_y          8
    #define _Game_CanPlaceShip_localvar_i                9
    #define _Game_CanPlaceShip_localvar_j               10

    #define _Game_CanPlaceShip_localarg_ship_state      11
    #define _Game_CanPlaceShip_localarg_placement_state 12

    LOAD_SP R6

    // R0 - ship_state

    LOAD_OFFSET_IMM_REG R0, _Game_CanPlaceShip_localarg_ship_state, R6
    
    OFFSET_STRUCT_REG_IMM R1, R0, cur_ship_state_t_ship_size_index_offset
    LWD R1, R1
    ARRAY_INDEX_IMM_REG R1, globalvar_SHIP_SIZES_AND_COUNT, R1, 2, R5
    OFFSET_STRUCT_REG_IMM R1, R1, ship_placement_t_size_offset
    LWD R1, R1

    STORE_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_size, R6
    
    



_Game_CanPlaceShip_return_true:
    LWI R0, 0xFFFF
    RETURN
_Game_CanPlaceShip_return_false:
    LWI R0, 0x0000
ENDFUNCTION


#macro Game_CanPlaceShip ship_state, placement_state

    PUSH_PREV_SP

    PUSH placement_state
    PUSH ship_state

    CALL _Game_CanPlaceShip

#endmacro










FUNCTION _Game_PutShipToField, 0

   

    #define _Game_PutShipToField_localarg_ship_state      3
    #define _Game_PutShipToField_localarg_placement_state 4

    LOAD_SP R6

    // R0 - i
    LOAD_OFFSET_IMM_REG R5, _Game_PutShipToField_localarg_ship_state, R6
    OFFSET_STRUCT_REG_IMM R0, R5, cur_ship_state_t_ship_size_index_offset
    LWD R0, R0
    ARRAY_INDEX_IMM_REG R0, globalvar_SHIP_SIZES_AND_COUNT, R0, 2, R4
    OFFSET_STRUCT_REG_IMM R0, R0, ship_placement_t_size_offset
    LWD R0, R0
    

    // R1 - field_ptr
    OFFSET_STRUCT_REG_IMM R1, R5, cur_ship_state_t_x_offset
    LWD R1, R1
    OFFSET_STRUCT_REG_IMM R2, R5, cur_ship_state_t_y_offset
    LWD R2, R2

    LWI R7, FIELD_SIZE

    MUL R2, R2, R7
    ADD R1, R1, R2
    LWI R7, 1
    SLL R1, R1, R7

    
    LOAD_OFFSET_IMM_REG R3, _Game_PutShipToField_localarg_placement_state, R6
    OFFSET_STRUCT_REG_IMM R2, R3, placement_state_t_field_offset
    ADD R1, R1, R2
    
    // R3 - ships_count

    OFFSET_STRUCT_REG_IMM R3, R3, placement_state_t_ships_count_offset
    LWD R3, R3

    // R2 - inc
    OFFSET_STRUCT_REG_IMM R2, R5, cur_ship_state_t_horizontal_offset
    LWD R2, R2

    LWI R6, _Game_PutShipToField_return

    LWI R7, _Game_PutShipToField_horizontal_inc
    JNZ R7, R2

    LWI R2, 20 // sizeof(fieldcell) * FIELD_SIZE


    JMP _Game_PutShipToField_loop

_Game_PutShipToField_horizontal_inc:

    LWI R2, 2 // sizeof(fieldcell)

_Game_PutShipToField_loop:

    // R0 - i
    // R1 - field_ptr 
    // R2 - inc
    // R3 - placement_state->ships_count
    // R4 - field_state
    // R5 - field_ship_index
    // R6 - _Game_PutShipToField_return
    // R7 - 

    JEZ R6, R0

    OFFSET_STRUCT_REG_IMM R4, R1, fieldcell_t_state_offset
    OFFSET_STRUCT_REG_IMM R5, R1, fieldcell_t_ship_index_offset
    LWI R7, CELL_SHIP
    SWD R4, R7
    SWD R5, R3

    ADD R1, R1, R2
    DEC R0, R0
    JMP _Game_PutShipToField_loop

_Game_PutShipToField_return:
ENDFUNCTION








#macro Game_PutShipToField ship_state, placement_state
    PUSH_PREV_SP

    PUSH placement_state
    PUSH ship_state

    CALL _Game_PutShipToField
#endmacro






















FUNCTION _Game_PlaceShip, 6

    #define _Game_PlaceShip_localvar_size_index       3
    #define _Game_PlaceShip_localvar_ship_size        4
    #define _Game_PlaceShip_localvar_ships_count      5
    #define _Game_PlaceShip_localvar_placed_ships     6
    #define _Game_PlaceShip_localvar_ships            7
    #define _Game_PlaceShip_localvar_s                8
     
    #define _Game_PlaceShip_localarg_ship_state       9
    #define _Game_PlaceShip_localarg_placement_state 10

    
    LOAD_SP R6

    // int16_t size_index = ship_state->ship_size_index;
    LOAD_OFFSET_IMM_REG R0, _Game_PlaceShip_localarg_ship_state, R6
    OFFSET_STRUCT_REG_IMM R0, R0, cur_ship_state_t_ship_size_index_offset
    LWD R1, R0
    STORE_OFFSET_IMM_REG R1, _Game_PlaceShip_localvar_size_index, R6


    // int16_t ship_size = SHIP_SIZES_AND_COUNT[size_index].size;

    OFFSET_STRUCT_IMM_IMM R0, globalvar_SHIP_SIZES_AND_COUNT, ship_placement_t_size_offset, 0, R5
    ARRAY_INDEX_REG_REG R0, R0, R1, 2
    LWD R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_PlaceShip_localvar_ship_size, R6

    // int16_t* ships_count = &placement_state->ships_count;

    LOAD_OFFSET_IMM_REG R0, _Game_PlaceShip_localarg_placement_state, R6
    OFFSET_STRUCT_REG_IMM R1, R0, placement_state_t_ships_count_offset
    STORE_OFFSET_IMM_REG R1, _Game_PlaceShip_localvar_ships_count, R6

    // int16_t* placed_ships = placement_state->placed_ships;

    OFFSET_STRUCT_REG_IMM R1, R0, placement_state_t_placed_ships_offset
    STORE_OFFSET_IMM_REG R1, _Game_PlaceShip_localvar_placed_ships, R6

    // ship_t*  ships = placement_state->ships;

    OFFSET_STRUCT_REG_IMM R1, R0, placement_state_t_ships_offset
    STORE_OFFSET_IMM_REG R1, _Game_PlaceShip_localvar_ships, R6


    LOAD_OFFSET_IMM_REG R0, _Game_PlaceShip_localarg_ship_state     , R6
    LOAD_OFFSET_IMM_REG R1, _Game_PlaceShip_localarg_placement_state, R6
    Game_CanPlaceShip R0, R1 // need to finish
    
    // if (!CanPlaceShip(ship_state, placement_state))
    LWI R7, _Game_PlaceShip_return_false
    JEZ R7, R0

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Game_PlaceShip_localvar_ships_count, R6
    LWD R0, R0
    
    // if (*ships_count >= MAX_SHIPS)
    LWI R7, _Game_PlaceShip_return_false
    LWI R1,  MAX_SHIPS
    JGQ R7, R0, R1
    
    //
    // R0 - s
    // R1 - ship_state
    // 
    

    LOAD_OFFSET_IMM_REG R1,  _Game_PlaceShip_localvar_ships, R6
    ADD R0, R0, R1
    
    LOAD_OFFSET_IMM_REG R1,  _Game_PlaceShip_localarg_ship_state, R6
    
    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_x_offset
    OFFSET_STRUCT_REG_IMM R3, R1, ship_t_x_offset
    LWD R3, R3
    SWD R2, R3

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_y_offset
    OFFSET_STRUCT_REG_IMM R3, R1, ship_t_y_offset
    LWD R3, R3
    SWD R2, R3

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_horizontal_offset
    OFFSET_STRUCT_REG_IMM R3, R1, ship_t_horizontal_offset
    LWD R3, R3
    SWD R2, R3

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_size_offset
    LOAD_OFFSET_IMM_REG R3, _Game_PlaceShip_localvar_size_index, R6
    SWD R2, R3

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_hits_offset
    LWI R3, 0
    SWD R2, R3

    LOAD_OFFSET_IMM_REG R2, _Game_PlaceShip_localarg_placement_state, R6

    Game_PutShipToField R1, R2 // need to finish

    // (*ships_count)++;

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Game_PlaceShip_localvar_ships_count, R6
    LWD R1, R0
    INC R1, R1
    SWD R0, R1

    // R0 -  size_index
    // R1 - *ships_count
    // R2 - &placed_ships[size_index]
    // R3 -  placed_ships[size_index]
    // R4 -
    // R5 -
    // R6 - SP
    // R7 -

    // placed_ships[size_index]++;

    LOAD_OFFSET_IMM_REG R2, _Game_PlaceShip_localvar_placed_ships, R6
    LOAD_OFFSET_IMM_REG R0, _Game_PlaceShip_localvar_size_index, R6

    ARRAY_INDEX_REG_REG R2, R2, R0, 1

    LWD R3, R2
    INC R3, R3
    SWD R2, R3

    LWI R5, MAX_SHIPS
    LWI R7, _Game_PlaceShip_check_ships_count_by_index
    JPL R7, R1, R5

    LWI R0, -1
    LOAD_OFFSET_IMM_REG R1, _Game_PlaceShip_localarg_ship_state, R6
    OFFSET_STRUCT_REG_IMM R1, R1, cur_ship_state_t_ship_size_index_offset
    SWD R1, R0
    JMP _Game_PlaceShip_return_true



_Game_PlaceShip_check_ships_count_by_index:

    LWI R1, globalvar_SHIP_SIZES_AND_COUNT
    ARRAY_INDEX_REG_REG R1, R1, R0, 2
    OFFSET_STRUCT_REG_IMM R1, R1, ship_placement_t_count_offset
    LWD R1, R1

    LWI R7, _Game_PlaceShip_return_true
    JPL R7, R3, R1

    LOAD_OFFSET_IMM_REG R0, _Game_PlaceShip_localarg_ship_state, R6
    LOAD_OFFSET_IMM_REG R1, _Game_PlaceShip_localarg_placement_state, R6

    Game_NetxShipSize R0, R1

_Game_PlaceShip_return_true:
    LWI R0, 0xFFFF
    RETURN
_Game_PlaceShip_return_false:
    LWI R0, 0x0000

ENDFUNCTION


#macro Game_PlaceShip ship_state, placement_state

    PUSH_PREV_SP

    PUSH placement_state
    PUSH ship_state

    CALL _Game_PlaceShip

#endmacro























FUNCTION _Game_RemoveShip, 8

ENDFUNCTION



#macro Game_RemoveShip ship_state, placement_state, link_cursor
    PUSH_PREV_SP 

    PUSH link_cursor
    PUSH placement_state
    PUSH ship_state

    CALL _Game_RemoveShip
#endmacro






















FUNCTION _Game_ServerHandlePlacement, 0

    LOAD_SP R6
    LOAD_OFFSET_STRUCT_IMM_IMM R0,    globalvar_my_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR
    LWI R7, _Game_ServerHandlePlacement_pressed_escape
    JEZ R7, R0

    LWI R5, _Game_ServerHandlePlacement_return
    LOAD_OFFSET_STRUCT_IMM_IMM R0, globalvar_enemy_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR
    JEZ R5, R0

    LOAD_OFFSET_IMM_IMM R0, globalvar_wait_remote, RAM_BASE_ADDR
    JNZ R5, R0

    LWI R0, PACKET_START_GAME_REQUEST
    STORE_OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    NET_SendPacket
    Game_StartWaitRemote
    JMP _Game_ServerHandlePlacement_return


_Game_ServerHandlePlacement_pressed_escape:

    Input_IsKeyJustPressed globalvar_keystate_offset_escape

    LWI R7, _Game_ServerHandlePlacement_pressed_return
    JEZ R7, R0

    OFFSET_IMM_IMM R0, globalvar_ship_placement_state, RAM_BASE_ADDR
    OFFSET_IMM_IMM R1, globalvar_my_placement_state, RAM_BASE_ADDR
    LWI R2, 0xffff
    Game_RemoveShip R0, R1, R2 // need to finish

_Game_ServerHandlePlacement_pressed_return:

    Input_IsKeyJustPressed globalvar_keystate_offset_return


    LWI R7, _Game_ServerHandlePlacement_return
    JEZ R7, R0

    LOAD_OFFSET_STRUCT_IMM_IMM R0, globalvar_my_placement_state, placement_state_t_ships_count_offset, RAM_BASE_ADDR
    LWI R1, MAX_SHIPS
    LWI R7, _Game_ServerHandlePlacement_place_ship
    JNQ R7, R0, R1


    LWI R0, 0xffff // true
    STORE_OFFSET_STRUCT_IMM_IMM R0, globalvar_my_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR
    
    LWI R0, PACKET_READY_REQUEST
    STORE_OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR

    NET_SendPacket
    Game_StartWaitRemote

    JMP _Game_ServerHandlePlacement_return
    
_Game_ServerHandlePlacement_place_ship:

    OFFSET_IMM_IMM R0, globalvar_ship_placement_state, RAM_BASE_ADDR
    OFFSET_IMM_IMM R1, globalvar_my_placement_state, RAM_BASE_ADDR

    Game_PlaceShip R0, R1 // need to finish

    LWI R7, _Game_ServerHandlePlacement_return
    JNZ R7, R0

    LWI R0, 5
    STORE_OFFSET_IMM_IMM R0, globalvar_bg_blink_counter, RAM_BASE_ADDR
    LWI R0, 100
    STORE_OFFSET_IMM_IMM R0, globalvar_warning_counter, RAM_BASE_ADDR
 
_Game_ServerHandlePlacement_return:
ENDFUNCTION


#macro Game_ServerHandlePlacement

    PUSH_PREV_SP
    CALL _Game_ServerHandlePlacement

#endmacro















FUNCTION _Game_ServerHandleClientPlacement, 0



ENDFUNCTION




#macro Game_ServerHandleClientPlacement
    PUSH_PREV_SP
    CALL _Game_ServerHandleClientPlacement
#endmacro 



















FUNCTION _Game_ClientHandleServerResponse, 0

    

ENDFUNCTION




#macro Game_ClientHandleServerResponse
    PUSH_PREV_SP
    CALL _Game_ClientHandleServerResponse
#endmacro 






















FUNCTION _Game_ClientHandlePlacement, 0

    

ENDFUNCTION




#macro Game_ClientHandlePlacement
    PUSH_PREV_SP
    CALL _Game_ClientHandlePlacement
#endmacro 




















FUNCTION _Game_HandleShipPlacement, 0

    LOAD_SP R6

    LOAD_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR
    LWI R7, _Game_HandleShipPlacement_client
    JEZ R7, R0

    Game_ServerHandlePlacement       // need to finish

    Game_ServerHandleClientPlacement // need to finish

    JMP _Game_HandleShipPlacement_return

_Game_HandleShipPlacement_client:
    
    Game_ClientHandleServerResponse // need to finish
    Game_ClientHandlePlacement      // need to finish

_Game_HandleShipPlacement_return:

ENDFUNCTION

#macro Game_HandleShipPlacement
    PUSH_PREV_SP
    CALL _Game_HandleShipPlacement
#endmacro

























FUNCTION _Game_PlacingShips, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_bg_blink_counter, RAM_BASE_ADDR
    LWI R7, _Game_PlacingShips_zero_bg_blink_counter
    JEZ R7, R0
    LWI R0, 1
    JMP _Game_PlacingShips_video_clear


_Game_PlacingShips_zero_bg_blink_counter:
    LWI R0, 0

_Game_PlacingShips_video_clear:
    Video_Clear R0
    Video_PlacingShips

    Game_UpdateWaitRemote // need to check

    LWI R7, _Game_PlacingShips_wait_remote
    JEZ R7, R0
    RETURN

_Game_PlacingShips_wait_remote:

    LOAD_OFFSET_IMM_IMM R0, globalvar_wait_remote, RAM_BASE_ADDR
    LWI R7, _Game_PlacingShips_wait_remote_else
    JEZ R7, R0

    Video_DrawWaitRemote
    
    JMP _Game_PlacingShips_wait_handle_ship_placement

_Game_PlacingShips_wait_remote_else:

    Game_HandleShipMovement
    Game_HandleCursorMovement

_Game_PlacingShips_wait_handle_ship_placement:

    Game_HandleShipPlacement // need to finish


_Game_PlacingShips_return:
ENDFUNCTION

#macro Game_PlacingShips
    PUSH_PREV_SP
    CALL _Game_PlacingShips
#endmacro

#endif