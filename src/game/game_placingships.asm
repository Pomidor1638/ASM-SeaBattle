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
    
    // int size = SHIP_SIZES_AND_COUNT[ship_state->ship_size_index].size;
    OFFSET_STRUCT_REG_IMM R1, R0, cur_ship_state_t_ship_size_index_offset
    LWD R1, R1
    ARRAY_INDEX_IMM_REG R1, globalvar_SHIP_SIZES_AND_COUNT, R1, 2, R5
    OFFSET_STRUCT_REG_IMM R1, R1, ship_placement_t_size_offset
    LWD R1, R1

    STORE_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_size, R6
    
    // int ship_x = ship_state->x;
    OFFSET_STRUCT_REG_IMM R1, R0, cur_ship_state_t_x_offset
    LWD R1, R1
    STORE_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_ship_x, R6

    // int ship_y = ship_state->y;
    OFFSET_STRUCT_REG_IMM R1, R0, cur_ship_state_t_y_offset
    LWD R1, R1
    STORE_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_ship_y, R6

    // bool horizontal = ship_state->horizontal;
    OFFSET_STRUCT_REG_IMM R1, R0, cur_ship_state_t_horizontal_offset
    LWD R1, R1
    STORE_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_horizontal, R6




    LOAD_OFFSET_IMM_REG R2, _Game_CanPlaceShip_localvar_size, R6

// if (horizontal)

    LWI R7, _Game_CanPlaceShip_zero_horizontal
    JEZ R7, R1

    LOAD_OFFSET_IMM_REG R0, _Game_CanPlaceShip_localvar_ship_x, R6

    LWI R7, _Game_CanPlaceShip_return_false
    ADD R0, R0, R2
    LWI R1, FIELD_SIZE
    JPG R7, R0, R1

    JMP _Game_CanPlaceShip_i_loop_init

_Game_CanPlaceShip_zero_horizontal:

    LOAD_OFFSET_IMM_REG R0, _Game_CanPlaceShip_localvar_ship_y, R6

    LWI R7, _Game_CanPlaceShip_return_false
    ADD R0, R0, R2
    LWI R1, FIELD_SIZE
    JPG R7, R0, R1

_Game_CanPlaceShip_i_loop_init:

    LWI R0, -1
    STORE_OFFSET_IMM_REG R0, _Game_CanPlaceShip_localvar_i, R6

_Game_CanPlaceShip_i_loop:
    
    LOAD_OFFSET_IMM_REG R0, _Game_CanPlaceShip_localvar_i   , R6
    LOAD_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_size, R6

    LWI R7, _Game_CanPlaceShip_return_true
    JPG R7, R0, R1

    LWI R1, -1
    STORE_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_j, R6

_Game_CanPlaceShip_j_loop:

    LOAD_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_j, R6
    LWI R2, 1
    LWI R7, _Game_CanPlaceShip_i_loop_end

    JPG R7, R1, R2


    LOAD_OFFSET_IMM_REG R2, _Game_CanPlaceShip_localvar_ship_x    , R6
    LOAD_OFFSET_IMM_REG R3, _Game_CanPlaceShip_localvar_ship_y    , R6
    LOAD_OFFSET_IMM_REG R4, _Game_CanPlaceShip_localvar_horizontal, R6

    LWI R7, _Game_CanPlaceShip_j_loop_zero_horizontal
    JEZ R7, R4

    ADD R2, R2, R0
    ADD R3, R3, R1

    JMP _Game_CanPlaceShip_check_bounds

_Game_CanPlaceShip_j_loop_zero_horizontal:

    ADD R2, R2, R1
    ADD R3, R3, R0


_Game_CanPlaceShip_check_bounds:

    LWI R4, 0
    LWI R5, FIELD_SIZE
    LWI R7, _Game_CanPlaceShip_j_loop_end

    // R2 - check_x
    // R3 - check_y


    JPL R7, R2, R4
    JPL R7, R3, R4
    JGQ R7, R2, R5
    JGQ R7, R3, R5

    LOAD_OFFSET_IMM_REG R4, _Game_CanPlaceShip_localarg_placement_state, R6
    OFFSET_STRUCT_REG_IMM R4, R4, placement_state_t_field_offset
    ARRAY_INDEX_REG_REG R4, R4, R3, 20 // FIELD_SIZE * sizeof(fieldcell_t)
    ARRAY_INDEX_REG_REG R4, R4, R2, 2  // sizeof(fieldcell_t)
    
    OFFSET_STRUCT_REG_IMM R4, R4, fieldcell_t_state_offset
    LWD R4, R4

    LWI R7, _Game_CanPlaceShip_return_false
    LWI R5, CELL_SHIP

    JEQ R7, R4, R5


_Game_CanPlaceShip_j_loop_end:

    LOAD_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_j, R6
    INC R1, R1
    STORE_OFFSET_IMM_REG R1, _Game_CanPlaceShip_localvar_j, R6
    JMP _Game_CanPlaceShip_j_loop

_Game_CanPlaceShip_i_loop_end:
    
    LOAD_OFFSET_IMM_REG R0, _Game_CanPlaceShip_localvar_i   , R6
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_CanPlaceShip_localvar_i, R6
    JMP _Game_CanPlaceShip_i_loop

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
    ARRAY_INDEX_REG_REG R0, R1, R0, 5
    
    LOAD_OFFSET_IMM_REG R1,  _Game_PlaceShip_localarg_ship_state, R6
    
    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_x_offset
    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_x_offset
    LWD R3, R3
    SWD R2, R3

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_y_offset
    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_y_offset
    LWD R3, R3
    SWD R2, R3

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_horizontal_offset
    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_horizontal_offset
    LWD R3, R3
    SWD R2, R3

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_size_offset
    LOAD_OFFSET_IMM_REG R3, _Game_PlaceShip_localvar_ship_size, R6
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
 
    #define _Game_RemoveShip_localvar_ships              3
    #define _Game_RemoveShip_localvar_ships_count        4
    #define _Game_RemoveShip_localvar_placed_ships       5
    #define _Game_RemoveShip_localvar_size_index         6
    #define _Game_RemoveShip_localvar_x                  7
    #define _Game_RemoveShip_localvar_y                  8
    #define _Game_RemoveShip_localvar_i                  9
    #define _Game_RemoveShip_localvar_s                 10

    #define _Game_RemoveShip_localarg_ship_state        11
    #define _Game_RemoveShip_localarg_placement_state   12
    #define _Game_RemoveShip_localarg_link_cursor       13

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Game_RemoveShip_localarg_placement_state, R6 

    OFFSET_STRUCT_REG_IMM R1, R0, placement_state_t_ships_offset
    STORE_OFFSET_IMM_REG R1, _Game_RemoveShip_localvar_ships, R6

    OFFSET_STRUCT_REG_IMM R1, R0, placement_state_t_ships_count_offset
    STORE_OFFSET_IMM_REG R1, _Game_RemoveShip_localvar_ships_count, R6

    OFFSET_STRUCT_REG_IMM R1, R0, placement_state_t_placed_ships_offset
    STORE_OFFSET_IMM_REG R1, _Game_RemoveShip_localvar_placed_ships, R6

    LOAD_OFFSET_IMM_REG R0, _Game_RemoveShip_localvar_ships_count, R6
    LWD R1, R0

    // if (!(*ships_count))
    //     return;
    LWI R7, _Game_RemoveShip_return
    JEZ R7, R1

    // (*ships_count)--;
    DEC R1, R1
    SWD R0, R1

    // s = ships + (*ships_count);
    LOAD_OFFSET_IMM_REG R2, _Game_RemoveShip_localvar_ships, R6
    ARRAY_INDEX_REG_REG R2, R2, R1, 5
    STORE_OFFSET_IMM_REG R2, _Game_RemoveShip_localvar_s, R6

    OFFSET_STRUCT_REG_IMM R1, R2, ship_t_size_offset
    LWD R1, R1

    // size_index = MAX_SHIPS_SIZE - s->size;
    LWI R3, MAX_SHIPS_SIZE
    SUB R1, R3, R1
    STORE_OFFSET_IMM_REG R1, _Game_RemoveShip_localvar_size_index, R6

    // if (size_index < 0 || size_index >= MAX_SHIPS_SIZE)
    LWI R7, _Game_RemoveShip_not_in_bounds
    JLZ R7, R1
    JGQ R7, R1, R3
    JMP _Game_RemoveShip_in_bounds

_Game_RemoveShip_not_in_bounds:

    LOAD_OFFSET_IMM_REG R0, _Game_RemoveShip_localvar_ships_count, R6
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_RemoveShip_localvar_ships_count, R6

    JMP _Game_RemoveShip_return

_Game_RemoveShip_in_bounds:

    LOAD_OFFSET_IMM_REG R2, _Game_RemoveShip_localvar_placed_ships, R6
    ADD R2, R2, R1
    LWD R3, R2

    LWI R7, _Game_RemoveShip_thing_not_greater
    LWI R5, 0
    JLQ R7, R3, R5

    // placed_ships[size_index]--;
    DEC R3, R3
    SWD R2, R3

_Game_RemoveShip_thing_not_greater:

    LOAD_OFFSET_IMM_REG R0, _Game_RemoveShip_localarg_ship_state, R6
    LOAD_OFFSET_IMM_REG R1, _Game_RemoveShip_localvar_s         , R6

    // ship_state->ship_size_index = size_index;
    OFFSET_STRUCT_REG_IMM R2, R0, cur_ship_state_t_ship_size_index_offset
    LOAD_OFFSET_IMM_REG R3, _Game_RemoveShip_localvar_size_index, R6
    SWD R2, R3

    // ship_state->horizontal = s->horizontal;
    OFFSET_STRUCT_REG_IMM R2, R0, cur_ship_state_t_horizontal_offset
    OFFSET_STRUCT_REG_IMM R3, R1, ship_t_horizontal_offset
    LWD R3, R3
    SWD R2, R3

    // ship_state->x = s->x;
    OFFSET_STRUCT_REG_IMM R2, R0, cur_ship_state_t_x_offset
    OFFSET_STRUCT_REG_IMM R3, R1, ship_t_x_offset
    LWD R3, R3
    SWD R2, R3

    // ship_state->y = s->y;
    OFFSET_STRUCT_REG_IMM R2, R0, cur_ship_state_t_y_offset
    OFFSET_STRUCT_REG_IMM R3, R1, ship_t_y_offset
    LWD R3, R3
    SWD R2, R3


    LOAD_OFFSET_IMM_REG R0, _Game_RemoveShip_localarg_link_cursor, R6

    LWI R7, _Game_RemoveShip_not_link_cursor
    JEZ R7, R0

    OFFSET_STRUCT_REG_IMM R3, R1, ship_t_x_offset
    OFFSET_STRUCT_REG_IMM R4, R1, ship_t_y_offset
    LWD R3, R3
    LWD R4, R4

    STORE_OFFSET_IMM_IMM R3, globalvar_my_cursor_x, RAM_BASE_ADDR
    STORE_OFFSET_IMM_IMM R4, globalvar_my_cursor_y, RAM_BASE_ADDR

_Game_RemoveShip_not_link_cursor:
    LOAD_SP R6
    
    OFFSET_STRUCT_REG_IMM R3, R1, ship_t_x_offset
    OFFSET_STRUCT_REG_IMM R4, R1, ship_t_y_offset
    LWD R3, R3
    LWD R4, R4

    STORE_OFFSET_IMM_REG R3, _Game_RemoveShip_localvar_x, R6
    STORE_OFFSET_IMM_REG R4, _Game_RemoveShip_localvar_y, R6


    //
    // R0 - i
    // R1 - inc 
    // R2 - field_state_ptr
    // R3 - field_ship_index_ptr
    // R4 - -1
    // R5 -  CELL_EMPTY
    // R6 - FIELD_SIZE
    // R7 - 
    //

    // R0 - i
    LOAD_OFFSET_IMM_REG R5,  _Game_RemoveShip_localvar_s, R6
    OFFSET_STRUCT_REG_IMM R0, R5, ship_t_size_offset
    LWD R0, R0


    // R1 - inc
    
    OFFSET_STRUCT_REG_IMM R5, R5, ship_t_horizontal_offset
    LWD R5, R5

    LWI R7, _Game_RemoveShip_ship_not_horizontal
    JEZ R7, R5

    LWI R1, 2 // sizeof(fieldcell_t)
    JMP _Game_RemoveShip_loop_init

    
_Game_RemoveShip_ship_not_horizontal:

    LWI R1, 20 // FIELD_SIZE * sizeof(fieldcell_t)



    // R2 - field_state_ptr
_Game_RemoveShip_loop_init:
    LOAD_OFFSET_IMM_REG R5, _Game_RemoveShip_localarg_placement_state, R6
    OFFSET_STRUCT_REG_IMM R5, R5, placement_state_t_field_offset
    
    LOAD_OFFSET_IMM_REG R3, _Game_RemoveShip_localvar_x, R6
    LOAD_OFFSET_IMM_REG R4, _Game_RemoveShip_localvar_y, R6
    ARRAY_INDEX_REG_REG R5, R5, R4, 20
    ARRAY_INDEX_REG_REG R5, R5, R3, 2


    OFFSET_STRUCT_REG_IMM R2, R5, fieldcell_t_state_offset


    // R3 - field_ship_index_ptr
    OFFSET_STRUCT_REG_IMM R3, R5, fieldcell_t_ship_index_offset
    

    // R4 - -1
    LWI R4, -1
    
    // R5 - CELL_EMPTY
    LWI R5, CELL_EMPTY

    // R6 - FIELD_SIZE
    LWI R6, FIELD_SIZE


    // R7 - _Game_RemoveShip_return
    LWI R7, _Game_RemoveShip_return



_Game_RemoveShip_i_loop:

    //
    // R0 - i
    // R1 - inc 
    // R2 - field_state_ptr
    // R3 - field_ship_index_ptr
    // R4 - -1
    // R5 - CELL_EMPTY
    // R6 - FIELD_SIZE
    // R7 - _Game_RemoveShip_return
    //

    JEZ R7, R0


    SWD R2, R5
    SWD R3, R4


    DEC R0, R0
    ADD R2, R2, R1
    ADD R3, R3, R1
    JMP _Game_RemoveShip_i_loop

    
_Game_RemoveShip_return:
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















FUNCTION _Game_ServerHandleClientPlacement, 4

    #define _Game_ServerHandleClientPlacement_localvar_cl_ship_state 3

    LOAD_SP R6

_Game_ServerHandleClientPlacement_check_loop:

    NET_CheckPacket
    LWI R7, _Game_ServerHandleClientPlacement_return
    JEZ R7, R0

    NET_PopPacket

    OFFSET_IMM_IMM R0, NET_RECV_PACKET, NET_BASE_ADDR
    LWD R1, R0

    // R0 - &incomming_packet
    // R1 - incomming_packet.type

// case PACKET_SHIP_PLACE_REQUEST:
    LWI R7, _Game_ServerHandleClientPlacement_check_remove_request
    LWI R6, PACKET_SHIP_PLACE_REQUEST
    JNQ R7, R1, R6

    // Создаем локальную копию состояния корабля
    LOAD_SP R6
    OFFSET_IMM_REG R1, _Game_ServerHandleClientPlacement_localvar_cl_ship_state, R6

    // Копируем данные из пакета в cl_ship_state
    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_x_offset
    LWI R2, 1  
    ADD R2, R0, R2
    LWD R4, R2          // incomming_packet.data[0]
    SWD R3, R4          // cl_ship_state.x = incomming_packet.data[0]

    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_y_offset
    INC R2, R2
    LWD R4, R2          // incomming_packet.data[1]
    SWD R3, R4          // cl_ship_state.y = incomming_packet.data[1]

    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_ship_size_index_offset
    INC R2, R2
    LWD R4, R2          // incomming_packet.data[2]
    SWD R3, R4          // cl_ship_state.ship_size_index = incomming_packet.data[2]

    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_horizontal_offset
    INC R2, R2
    LWD R4, R2          // incomming_packet.data[3]
    SWD R3, R4          // cl_ship_state.horizontal = incomming_packet.data[3]

    // Пытаемся разместить корабль на поле противника
    OFFSET_IMM_IMM R0, globalvar_enemy_placement_state, RAM_BASE_ADDR
    Game_PlaceShip R1, R0  // PlaceShip(&cl_ship_state, &enemy_placement_state)

    // Отправляем ответ
    OFFSET_IMM_IMM R1, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R2, PACKET_SHIP_PLACE_RESPONSE
    SWD R1, R2          // outgoing_packet.type = PACKET_SHIP_PLACE_RESPONSE

    INC R1, R1          // &outgoing_packet.data[0]
    SWD R1, R0          // outgoing_packet.data[0] = результат PlaceShip

    NET_SendPacket
    JMP _Game_ServerHandleClientPlacement_check_loop
// end case

_Game_ServerHandleClientPlacement_check_remove_request:
// case PACKET_SHIP_REMOVE_REQUEST:
    LWI R7, _Game_ServerHandleClientPlacement_check_ready_request
    LWI R6, PACKET_SHIP_REMOVE_REQUEST
    JNQ R7, R1, R6

    LOAD_SP R6
    OFFSET_IMM_REG R1, _Game_ServerHandleClientPlacement_localvar_cl_ship_state, R6

    // Копируем данные из пакета
    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_x_offset
    LWI R2, 1  
    ADD R2, R0, R2
    LWD R4, R2
    SWD R3, R4

    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_y_offset
    INC R2, R2
    LWD R4, R2
    SWD R3, R4

    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_ship_size_index_offset
    INC R2, R2
    LWD R4, R2
    SWD R3, R4

    OFFSET_STRUCT_REG_IMM R3, R1, cur_ship_state_t_horizontal_offset
    INC R2, R2
    LWD R4, R2
    SWD R3, R4


    OFFSET_IMM_IMM R0, globalvar_enemy_placement_state, RAM_BASE_ADDR
    LWI R5, 0x0000
    Game_RemoveShip R1, R0, R5  // RemoveShip(&cl_ship_state, &enemy_placement_state, false)

    OFFSET_IMM_IMM R1, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R2, PACKET_SHIP_REMOVE_RESPONSE
    SWD R1, R2

    NET_SendPacket
    JMP _Game_ServerHandleClientPlacement_check_loop
// end case

_Game_ServerHandleClientPlacement_check_ready_request:
// case PACKET_READY_REQUEST:
    LWI R7, _Game_ServerHandleClientPlacement_check_ready_response
    LWI R6, PACKET_READY_REQUEST
    JNQ R7, R1, R6

    // Устанавливаем флаг готовности противника
    LWI R0, 0xFFFF
    STORE_OFFSET_STRUCT_IMM_IMM R0, globalvar_enemy_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR

    // Отправляем наш статус готовности
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_READY_RESPONSE
    SWD R0, R1

    INC R0, R0  // &outgoing_packet.data[0]
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_my_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR
    SWD R0, R1  // outgoing_packet.data[0] = my_placement_state.ready

    NET_SendPacket
    JMP _Game_ServerHandleClientPlacement_check_loop
// end case

_Game_ServerHandleClientPlacement_check_ready_response:
// case PACKET_READY_RESPONSE:
    LWI R7, _Game_ServerHandleClientPlacement_check_start_game_response
    LWI R6, PACKET_READY_RESPONSE
    JNQ R7, R1, R6

    // Обновляем статус готовности противника из пакета
    INC R0, R0  // Пропускаем type, переходим к data[0]
    LWD R1, R0
    STORE_OFFSET_STRUCT_IMM_IMM R1, globalvar_enemy_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR

    // Завершаем ожидание (если мы ждали ответа)
    Game_EndWaitRemote
    JMP _Game_ServerHandleClientPlacement_check_loop
// end case

_Game_ServerHandleClientPlacement_check_start_game_response:
// case PACKET_START_GAME_RESPONSE:
    LWI R7, _Game_ServerHandleClientPlacement_check_loop
    LWI R6, PACKET_START_GAME_RESPONSE
    JNQ R7, R1, R6

    // Переходим в основную игру
    LWI R0, STATE_MAIN_GAME
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR

    LWI R0, 0xFFFF  // true
    STORE_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR

    // Завершаем ожидание
    Game_EndWaitRemote
    JMP _Game_ServerHandleClientPlacement_check_loop
// end case

_Game_ServerHandleClientPlacement_default:
    // Неизвестный тип пакета, просто продолжаем цикл
    JMP _Game_ServerHandleClientPlacement_check_loop

_Game_ServerHandleClientPlacement_return:
ENDFUNCTION

#macro Game_ServerHandleClientPlacement
    PUSH_PREV_SP
    CALL _Game_ServerHandleClientPlacement
#endmacro



















FUNCTION _Game_ClientHandleServerResponse, 0

    //LOAD_SP R6

_Game_ClientHandleServerResponse_check_loop:

    // while (Check_Packet())
    NET_CheckPacket
    LWI R7, _Game_ClientHandleServerResponse_return
    JEZ R7, R0          // if no packets, return

    // Pop_Packet();
    NET_PopPacket

    // R0 = &incoming_packet
    OFFSET_IMM_IMM R0, NET_RECV_PACKET, NET_BASE_ADDR
    // R1 = incoming_packet.type
    LWD R1, R0

    // switch (incomming_packet.type)
    // case PACKET_SHIP_PLACE_RESPONSE:
    LWI R7, _Game_ClientHandleServerResponse_check_remove_response
    LWI R6, PACKET_SHIP_PLACE_RESPONSE
    JNQ R7, R1, R6

    // if (incomming_packet.data[0])
    INC R0, R0          // &incoming_packet.data[0]
    LWD R1, R0          // R1 = incoming_packet.data[0]

    LWI R7, _Game_ClientHandleServerResponse_place_ship_success
    JNZ R7, R1          // if data[0] != 0, success

    // else { bg_blink_counter = 5; warning_counter = 100; }
    LWI R0, 5
    STORE_OFFSET_IMM_IMM R0, globalvar_bg_blink_counter, RAM_BASE_ADDR
    LWI R0, 100
    STORE_OFFSET_IMM_IMM R0, globalvar_warning_counter, RAM_BASE_ADDR
    
    JMP _Game_ClientHandleServerResponse_end_wait

_Game_ClientHandleServerResponse_place_ship_success:
    // PlaceShip(&ship_placement_state, &my_placement_state);
    OFFSET_IMM_IMM R0, globalvar_ship_placement_state, RAM_BASE_ADDR
    OFFSET_IMM_IMM R1, globalvar_my_placement_state, RAM_BASE_ADDR
    Game_PlaceShip R0, R1

_Game_ClientHandleServerResponse_end_wait:
    // EndWaitRemote();
    Game_EndWaitRemote
    JMP _Game_ClientHandleServerResponse_check_loop
// end case

_Game_ClientHandleServerResponse_check_remove_response:
// case PACKET_SHIP_REMOVE_RESPONSE:
    LWI R7, _Game_ClientHandleServerResponse_check_ready_request
    LWI R6, PACKET_SHIP_REMOVE_RESPONSE
    JNQ R7, R1, R6

    // RemoveShip(&ship_placement_state, &my_placement_state, true);
    OFFSET_IMM_IMM R0, globalvar_ship_placement_state, RAM_BASE_ADDR
    OFFSET_IMM_IMM R1, globalvar_my_placement_state, RAM_BASE_ADDR
    LWI R5, 0xFFFF      // true (link_cursor)
    Game_RemoveShip R0, R1, R5

    // EndWaitRemote();
    Game_EndWaitRemote
    JMP _Game_ClientHandleServerResponse_check_loop
// end case

_Game_ClientHandleServerResponse_check_ready_request:
// case PACKET_READY_REQUEST:
    LWI R7, _Game_ClientHandleServerResponse_check_ready_response
    LWI R6, PACKET_READY_REQUEST
    JNQ R7, R1, R6

    // enemy_placement_state.ready = true;
    LWI R0, 0xFFFF
    STORE_OFFSET_STRUCT_IMM_IMM R0, globalvar_enemy_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR

    // outgoing_packet.type = PACKET_READY_RESPONSE;
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_READY_RESPONSE
    SWD R0, R1

    // outgoing_packet.data[0] = my_placement_state.ready;
    INC R0, R0          // &outgoing_packet.data[0]
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_my_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR
    SWD R0, R1

    // SendPacket();
    NET_SendPacket
    JMP _Game_ClientHandleServerResponse_check_loop
// end case

_Game_ClientHandleServerResponse_check_ready_response:
// case PACKET_READY_RESPONSE:
    LWI R7, _Game_ClientHandleServerResponse_check_start_game_request
    LWI R6, PACKET_READY_RESPONSE
    JNQ R7, R1, R6

    // enemy_placement_state.ready = incomming_packet.data[0];
    INC R0, R0          // &incoming_packet.data[0]
    LWD R1, R0
    STORE_OFFSET_STRUCT_IMM_IMM R1, globalvar_enemy_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR

    // EndWaitRemote();
    Game_EndWaitRemote
    JMP _Game_ClientHandleServerResponse_check_loop
// end case

_Game_ClientHandleServerResponse_check_start_game_request:
// case PACKET_START_GAME_REQUEST:
    LWI R7, _Game_ClientHandleServerResponse_default
    LWI R6, PACKET_START_GAME_REQUEST
    JNQ R7, R1, R6

    // game_state = STATE_MAIN_GAME;
    LWI R0, STATE_MAIN_GAME
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR

    // my_turn = false;
    LWI R0, 0x0000      // false
    STORE_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR

    // outgoing_packet.type = PACKET_START_GAME_RESPONSE;
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_START_GAME_RESPONSE
    SWD R0, R1

    // SendPacket();
    NET_SendPacket
    
    // EndWaitRemote(); (not in C code but should be here)
    Game_EndWaitRemote
    JMP _Game_ClientHandleServerResponse_check_loop
// end case

_Game_ClientHandleServerResponse_default:
    // default: break;
    // Unknown packet type, continue checking
    JMP _Game_ClientHandleServerResponse_check_loop

_Game_ClientHandleServerResponse_return:
ENDFUNCTION

#macro Game_ClientHandleServerResponse
    PUSH_PREV_SP
    CALL _Game_ClientHandleServerResponse
#endmacro






















FUNCTION _Game_ClientHandlePlacement, 0


    OFFSET_IMM_IMM R0, globalvar_my_placement_state, RAM_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R0, R0, placement_state_t_ready_offset
    LWD R0, R0
    
    LWI R7, _Game_ClientHandlePlacement_return
    JNZ R7, R0          // if ready, return

    // if (isKeyJustPressed(SDL_SCANCODE_RETURN))
    Input_IsKeyJustPressed globalvar_keystate_offset_return
    LWI R7, _Game_ClientHandlePlacement_check_escape
    JEZ R7, R0          // if not pressed, check escape    

    // Check if all ships placed and not ready yet
    // if (my_placement_state.ships_count == MAX_SHIPS && !my_placement_state.ready)
    LOAD_OFFSET_STRUCT_IMM_IMM R0, globalvar_my_placement_state, placement_state_t_ships_count_offset, RAM_BASE_ADDR
    LWI R1, MAX_SHIPS
    LWI R7, _Game_ClientHandlePlacement_check_not_all_ships
    JNQ R7, R0, R1      // if ships_count != MAX_SHIPS, go to ship place request
    
    // Here: ships_count == MAX_SHIPS
    LOAD_OFFSET_STRUCT_IMM_IMM R0, globalvar_my_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR
    LWI R7, _Game_ClientHandlePlacement_send_ship_place_request
    JNZ R7, R0          // if ready != 0 (already ready), still send ship place request???

    // my_placement_state.ready = true;
    LWI R0, 0xFFFF
    STORE_OFFSET_STRUCT_IMM_IMM R0, globalvar_my_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR

    // outgoing_packet.type = PACKET_READY_REQUEST;
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_READY_REQUEST
    SWD R0, R1

    JMP _Game_ClientHandlePlacement_send_packet

_Game_ClientHandlePlacement_check_not_all_ships:
    // ships_count != MAX_SHIPS, send ship place request
    JMP _Game_ClientHandlePlacement_send_ship_place_request

_Game_ClientHandlePlacement_send_ship_place_request:
    // else { outgoing_packet.type = PACKET_SHIP_PLACE_REQUEST; ... }
    
    // outgoing_packet.type = PACKET_SHIP_PLACE_REQUEST;
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_SHIP_PLACE_REQUEST
    SWD R0, R1

    // outgoing_packet.data[0] = ship_placement_state.x;
    INC R0, R0          // &outgoing_packet.data[0]
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_ship_placement_state, cur_ship_state_t_x_offset, RAM_BASE_ADDR
    SWD R0, R1

    // outgoing_packet.data[1] = ship_placement_state.y;
    INC R0, R0
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_ship_placement_state, cur_ship_state_t_y_offset, RAM_BASE_ADDR
    SWD R0, R1

    // outgoing_packet.data[2] = ship_placement_state.ship_size_index;
    INC R0, R0
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_ship_placement_state, cur_ship_state_t_ship_size_index_offset, RAM_BASE_ADDR
    SWD R0, R1

    // outgoing_packet.data[3] = ship_placement_state.horizontal;
    INC R0, R0
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_ship_placement_state, cur_ship_state_t_horizontal_offset, RAM_BASE_ADDR
    SWD R0, R1

_Game_ClientHandlePlacement_send_packet:
    // SendPacket();
    NET_SendPacket

    // StartWaitRemote();
    Game_StartWaitRemote
    
    JMP _Game_ClientHandlePlacement_return

_Game_ClientHandlePlacement_check_escape:
    // if (isKeyJustPressed(SDL_SCANCODE_ESCAPE))
    Input_IsKeyJustPressed globalvar_keystate_offset_escape
    LWI R7, _Game_ClientHandlePlacement_return
    JEZ R7, R0

    // outgoing_packet.type = PACKET_SHIP_REMOVE_REQUEST;
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_SHIP_REMOVE_REQUEST
    SWD R0, R1

    // outgoing_packet.data[0] = ship_placement_state.x;
    INC R0, R0          // &outgoing_packet.data[0]
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_ship_placement_state, cur_ship_state_t_x_offset, RAM_BASE_ADDR
    SWD R0, R1

    // outgoing_packet.data[1] = ship_placement_state.y;
    INC R0, R0
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_ship_placement_state, cur_ship_state_t_y_offset, RAM_BASE_ADDR
    SWD R0, R1

    // outgoing_packet.data[2] = ship_placement_state.ship_size_index;
    INC R0, R0
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_ship_placement_state, cur_ship_state_t_ship_size_index_offset, RAM_BASE_ADDR
    SWD R0, R1

    // outgoing_packet.data[3] = ship_placement_state.horizontal;
    INC R0, R0
    LOAD_OFFSET_STRUCT_IMM_IMM R1, globalvar_ship_placement_state, cur_ship_state_t_horizontal_offset, RAM_BASE_ADDR
    SWD R0, R1

    // SendPacket();
    NET_SendPacket

    // StartWaitRemote();
    Game_StartWaitRemote

_Game_ClientHandlePlacement_return:
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

    Game_ServerHandlePlacement

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