#ifndef _VIDEO_PLACINGSHIPS_ASM_
#define _VIDEO_PLACINGSHIPS_ASM_

FUNCTION _Video_DrawNumbers, 7

    #define _Video_DrawNumbers_localvar_i             3
    #define _Video_DrawNumbers_localvar_char          4
    #define _Video_DrawNumbers_localvar_digit         5

    #define _Video_DrawNumbers_localvar_cur_x         6
    #define _Video_DrawNumbers_localvar_cur_y         7

    #define _Video_DrawNumbers_localvar_end_x         8
    #define _Video_DrawNumbers_localvar_end_y         9

    #define _Video_DrawNumbers_localarg_start_x      10
    #define _Video_DrawNumbers_localarg_start_y      11

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localarg_start_x, R6
    LWI R7, FIELD_SIZE
    INC R7, R7
    ADD R0, R0, R7
    STORE_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_end_x, R6
    
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localarg_start_y, R6
    LWI R7, FIELD_SIZE
    INC R7, R7
    ADD R0, R0, R7
    STORE_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_end_y, R6
    
    //LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localarg_start_x, R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localarg_start_y, R6
    LWI R2, 0
    LWI R3, CHAR_OVER_WALL_COLOR
    LWI R4, FIELD_WALL_COLOR
    Video_PutChar R0, R1, R2, R3, R4

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localarg_start_x, R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localvar_end_y, R6
    LWI R2, 0
    LWI R3, CHAR_OVER_WALL_COLOR
    LWI R4, FIELD_WALL_COLOR
    Video_PutChar R0, R1, R2, R3, R4

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_end_x, R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localarg_start_y, R6
    LWI R2, 0
    LWI R3, CHAR_OVER_WALL_COLOR
    LWI R4, FIELD_WALL_COLOR
    Video_PutChar R0, R1, R2, R3, R4

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_end_x, R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localvar_end_y, R6
    LWI R2, 0
    LWI R3, CHAR_OVER_WALL_COLOR
    LWI R4, FIELD_WALL_COLOR
    Video_PutChar R0, R1, R2, R3, R4

    LWI R0, 0
    LOAD_SP R6
    STORE_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_i, R6

_Video_DrawNumbers_loop:

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localvar_i, R6

    LWI R7, _Video_DrawNumbers_return
    LWI R5, FIELD_SIZE 
    JEQ R7, R1, R5
    
    LWI R0, 16
    ADD R0, R0, R1
    STORE_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_digit, R6

    LWI R0, 33
    ADD R0, R0, R1
    STORE_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_char, R6

    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localarg_start_x, R6  
    ADD R0, R0, R1
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_cur_x, R6  
    
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localarg_start_y, R6  
    ADD R0, R0, R1
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_cur_y, R6 
    

    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_cur_x  , R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localarg_start_y, R6
    LOAD_OFFSET_IMM_REG R2, _Video_DrawNumbers_localvar_char, R6
    LWI R3, CHAR_OVER_WALL_COLOR
    LWI R4, FIELD_WALL_COLOR
    Video_PutChar R0, R1, R2, R3, R4

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_cur_x  , R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localvar_end_y, R6
    LOAD_OFFSET_IMM_REG R2, _Video_DrawNumbers_localvar_char, R6
    LWI R3, CHAR_OVER_WALL_COLOR
    LWI R4, FIELD_WALL_COLOR
    Video_PutChar R0, R1, R2, R3, R4

    
    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localarg_start_x  , R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localvar_cur_y, R6
    LOAD_OFFSET_IMM_REG R2, _Video_DrawNumbers_localvar_digit, R6
    LWI R3, CHAR_OVER_WALL_COLOR
    LWI R4, FIELD_WALL_COLOR
    Video_PutChar R0, R1, R2, R3, R4

    
    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawNumbers_localvar_end_x  , R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localvar_cur_y, R6
    LOAD_OFFSET_IMM_REG R2, _Video_DrawNumbers_localvar_digit, R6
    LWI R3, CHAR_OVER_WALL_COLOR
    LWI R4, FIELD_WALL_COLOR
    Video_PutChar R0, R1, R2, R3, R4

    
    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawNumbers_localvar_i, R6
    INC R1, R1
    STORE_OFFSET_IMM_REG R1, _Video_DrawNumbers_localvar_i, R6
    JMP _Video_DrawNumbers_loop

_Video_DrawNumbers_return:
ENDFUNCTION

#macro Video_DrawNumbers reg_start_x, reg_start_y

    PUSH_PREV_SP
    PUSH reg_start_y
    PUSH reg_start_x
    CALL _Video_DrawNumbers

#endmacro

FUNCTION _Video_DrawField, 7

    #define _Video_DrawField_localvar_symbol       3
    #define _Video_DrawField_localvar_front_color  4 
    #define _Video_DrawField_localvar_back_color   5
    #define _Video_DrawField_localvar_x            6
    #define _Video_DrawField_localvar_y            7
    #define _Video_DrawField_localvar_i            8
    #define _Video_DrawField_localvar_j            9

    #define _Video_DrawField_localarg_start_x     10
    #define _Video_DrawField_localarg_start_y     11
    #define _Video_DrawField_localarg_field_ptr   12
    #define _Video_DrawField_localarg_draw_ships  13

    #define _Video_DrawField_localvar_grid_size 12 // FIELD_SIZE + 2

    LOAD_SP R6
    LWI R0, 0
    STORE_OFFSET_IMM_REG R0, _Video_DrawField_localvar_i, R6

_Video_DrawField_i_loop:
    
    LOAD_OFFSET_IMM_REG R0, _Video_DrawField_localvar_i, R6

    LWI R1, FIELD_SIZE 
    LWI R7, _Video_DrawField_draw_numbers
    JEQ R7, R0, R1

    LWI R1, 0
    STORE_OFFSET_IMM_REG R1, _Video_DrawField_localvar_j, R6

_Video_DrawField_j_loop:

    LOAD_OFFSET_IMM_REG R0, _Video_DrawField_localvar_i, R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawField_localvar_j, R6

    LWI R2, FIELD_SIZE 
    LWI R7, _Video_DrawField_i_loop_end
    JEQ R7, R1, R2
    
    MUL R2, R0, R2
    ADD R2, R1, R2
    LWI R7, 1
    SLL R2, R2, R7

    LOAD_OFFSET_IMM_REG R3, _Video_DrawField_localarg_field_ptr, R6
    ADD R2, R2, R3
    LWD R2, R2

// R2 - current_cell->state
    
// switch    

    LWI R3, WATER_SYMBOL
    LWI R4, WATER_FRONT_COLOR

// case CELL_EMPTY
    LWI R3, CELL_EMPTY
    LWI R7, _Video_DrawField_cell_ship
    JNQ R7, R2, R3

    LWI R3, WATER_SYMBOL
    LWI R4, WATER_FRONT_COLOR

    JMP _Video_DrawField_put_symbol

// case CELL_SHIP
_Video_DrawField_cell_ship:
    LWI R3, CELL_SHIP
    LWI R7, _Video_DrawField_cell_miss
    JNQ R7, R2, R3

    LWI R3, WATER_SYMBOL
    LWI R4, WATER_FRONT_COLOR

    LOAD_OFFSET_IMM_REG R5, _Video_DrawField_localarg_draw_ships, R6
    LWI R7, _Video_DrawField_put_symbol
    JEZ R7, R5

    LWI R3, SHIP_SYMBOL
    LWI R4, SHIP_FRONT_COLOR

    JMP _Video_DrawField_put_symbol

// case CELL_MISS
_Video_DrawField_cell_miss:
    LWI R3, CELL_MISS
    LWI R7, _Video_DrawField_cell_hit
    JNQ R7, R2, R3

    LWI R3, DITHER_LEVEL1
    LWI R4, MISS_FRONT_COLOR

    JMP _Video_DrawField_put_symbol

// case CELL_HIT
_Video_DrawField_cell_hit:
    LWI R3, CELL_HIT
    LWI R7, _Video_DrawField_cell_sunk
    JNQ R7, R2, R3

    LWI R3, HIT_SYMBOL
    LWI R4, HIT_FRONT_COLOR

    JMP _Video_DrawField_put_symbol

// case CELL_SUNK
_Video_DrawField_cell_sunk:
    LWI R3, CELL_SUNK
    LWI R7, _Video_DrawField_put_symbol
    JNQ R7, R2, R3

    LWI R3, SUNK_SYMBOL
    LWI R4, HIT_FRONT_COLOR

    JMP _Video_DrawField_put_symbol


_Video_DrawField_put_symbol:

    LOAD_OFFSET_IMM_REG R5, _Video_DrawField_localarg_start_x, R6
    ADD R1, R1, R5
    INC R1, R1

    LOAD_OFFSET_IMM_REG R5, _Video_DrawField_localarg_start_y, R6
    ADD R0, R0, R5
    INC R0, R0


    LWI R5, WATER_BACK_COLOR

    // R0 - y
    // R1 - x
    // R2 - 
    // R3 - symbol
    // R4 - fg_color
    // R5 - bg_color
    // R6 - 
    // R7 - 

    LWI R7, BUF_VRAM_BASE_ADDR
    LWI R6, 40 // WIDTH

    MUL R0, R0, R6
    ADD R0, R0, R1 
    ADD R0, R0, R7

    // 40 * y + x + BUF_VRAM_BASE_ADDR

    // R0 - buf_vram_addr
    // R1 - 
    // R2 - 
    // R3 - symbol
    // R4 - fg_color
    // R5 - bg_color
    // R6 - 
    // R7 - BUF_VRAM_BASE_ADDR

    LWI R7, 12
    SLL R4, R4, R7
    LWI R7, 8
    SLL R5, R5, R7
    ORR R1, R4, R5

    // R0 - buf_vram_addr
    // R1 - fg_color, bg_color
    // R2 - 
    // R3 - symbol
    // R4 - 
    // R5 - 
    // R6 - 
    // R7 - BUF_VRAM_BASE_ADDR

    ORR R1, R1, R3
    SWD R0, R1

_Video_DrawField_j_loop_end:
    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawField_localvar_j, R6
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Video_DrawField_localvar_j, R6 
    JMP _Video_DrawField_j_loop


_Video_DrawField_i_loop_end:
    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawField_localvar_i, R6
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Video_DrawField_localvar_i, R6 
    JMP _Video_DrawField_i_loop

_Video_DrawField_draw_numbers:

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawField_localarg_start_x, R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawField_localarg_start_y, R6

    Video_DrawNumbers R0, R1

ENDFUNCTION

FUNCTION _Video_DrawShip, 0

    #define _Video_DrawShip_x          3 
    #define _Video_DrawShip_y          4
    #define _Video_DrawShip_size       5
    #define _Video_DrawShip_horizontal 6

    LOAD_SP R6

    LOAD_OFFSET_IMM_REG R0, _Video_DrawShip_x         , R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawShip_y         , R6
    LOAD_OFFSET_IMM_REG R2, _Video_DrawShip_size      , R6
    LOAD_OFFSET_IMM_REG R3, _Video_DrawShip_horizontal, R6

    LWI R7, 40 // WIDTH

    MUL R1, R1, R7             // 40 * y
    ADD R0, R0, R1             // 40 * y + x
    LWI R7, BUF_VRAM_BASE_ADDR 
    ADD R0, R0, R7             // 40 * y + x + BUF_VRAM_BASE_ADDR

    

    LWI R4, SHIP_SYMBOL
    
    LWI R6, SHIP_PLACING_FRONT_COLOR
    LWI R7, 12
    SLL R6, R6, R7
    ADD R4, R4, R6

    LWI R6, SHIP_BACK_COLOR
    LWI R7, 8
    SLL R6, R6, R7
    ADD R4, R4, R6

    LWI R7, _Video_DrawShip_return
    
    LWI R6, _Video_DrawShip_y_inc
    JEZ R6, R3

    LWI R1, 1
    JMP _Video_DrawShip_draw_loop

_Video_DrawShip_y_inc:
    LWI R1, 40 // WIDTH


_Video_DrawShip_draw_loop:


    // R0 - buf_vram_addr
    // R1 - addr_increment
    // R2 - size
    // R3 - horizontal
    // R4 - video cell
    JEZ R7, R2

    SWD R0, R4
    DEC R2, R2
    ADD R0, R0, R1
    JMP _Video_DrawShip_draw_loop
    
_Video_DrawShip_return:
ENDFUNCTION

#macro Video_DrawShip reg_x, reg_y, reg_size, reg_horizontal
    PUSH_PREV_SP
    PUSH reg_horizontal
    PUSH reg_size
    PUSH reg_y
    PUSH reg_x
    CALL _Video_DrawShip
#endmacro

#macro Video_DrawField start_x, start_y, field_ptr, draw_ships
    PUSH_PREV_SP

    PUSH draw_ships
    PUSH field_ptr
    PUSH start_y
    PUSH start_x

    CALL _Video_DrawField
#endmacro

_Video_PlacingShips_warning_counter_str:
    .string "BAD SHIP PLACEMENT"
_Video_PlacingShips_enemy_is_ready_str:
    .string "Enemy is READY"
_Video_PlacingShips_ready_str:
    .string "READY"
_Video_PlacingShips_are_you_ready:
    .string "Are you READY?"

FUNCTION _Video_DrawStats, 5

    #define _Video_DrawStats_localvar_i     3
    #define _Video_DrawStats_localvar_j     4
    #define _Video_DrawStats_localvar_x     5
    #define _Video_DrawStats_localvar_y     6
    #define _Video_DrawStats_localvar_cur_s 7
    

    LWI R0, 0

    LOAD_SP R6
    STORE_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_i, R6

    LWI R0, 3
    STORE_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_x, R6

_Video_DrawStats_i_loop:

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_i, R6

    LWI R7, _Video_DrawStats_return
    LWI R5, MAX_SHIPS_SIZE
    JEQ R7, R0, R5 // i != MAX_SHIPS_SIZE ? 

    LWI R7, globalvar_SHIP_SIZES_AND_COUNT
    LWI R5, 1
    SLL R2, R0, R5
    ADD R5, R7, R2

    STORE_OFFSET_IMM_REG R5, _Video_DrawStats_localvar_cur_s, R6


    LWI R1, 11 // BUFFER_HEIGHT / 2 - 4
    ADD R1, R1, R2 // BUFFER_HEIGHT / 2 - 4 + (i << 1)
    STORE_OFFSET_IMM_REG R1, _Video_DrawStats_localvar_y, R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_x, R6

    OFFSET_STRUCT_IMM_IMM R2, globalvar_my_placement_state, placement_state_t_placed_ships_offset, RAM_BASE_ADDR, R5 // my_placement_state.placed_ships

    LOAD_OFFSET_IMM_REG R4, _Video_DrawStats_localvar_i, R6
    ARRAY_INDEX_REG_REG R2, R2, R4, 1

    LWD R2, R2 // my_placement_state.placed_ships[i]
    

    LWI R7, 16 // '0'
    ADD R2, R2, R7 

    LWI R3, 7
    LWI R4, 0

    // R0 - x
    // R1 - y
    // R2 - '0' + my_placement_state.placed_ships[i]
    // R3 - 7
    // R4 - 0


    Video_PutChar R0, R1, R2, R3, R4


    LOAD_SP R6

    // R0 - x + 1
    // R1 - y
    // R2 - '/'
    // R3 - 7
    // R4 - 0

    LOAD_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_x, R6
    INC R0, R0
    LOAD_OFFSET_IMM_REG R1, _Video_DrawStats_localvar_y, R6
    LWI R2, 15 // '/'
    LWI R3, 7
    LWI R4, 0

    Video_PutChar R0, R1, R2, R3, R4


    LOAD_SP R6

    
    // R0 - x + 1
    // R1 - y
    // R2 - '0' + SHIP_SIZES_AND_COUNT[i].count
    // R3 - 7
    // R4 - 0

    LOAD_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_x, R6
    INC R0, R0
    INC R0, R0
    LOAD_OFFSET_IMM_REG R1, _Video_DrawStats_localvar_y, R6

    LWI R2, 16 // '0'

    LOAD_OFFSET_IMM_REG R3, _Video_DrawStats_localvar_cur_s, R6

    LWI R7, ship_placement_t_count_offset
    ADD R3, R3, R7
    LWD R3, R3 // SHIP_SIZES_AND_COUNT[i].count

    ADD R2, R2, R3 // '0' + SHIP_SIZES_AND_COUNT[i].count

    LWI R3, 7
    LWI R4, 0

    Video_PutChar R0, R1, R2, R3, R4

    LOAD_SP R6
    LWI R0, 0
    STORE_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_j, R6

_Video_DrawStats_j_loop:
    
    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_j, R6

    LOAD_OFFSET_IMM_REG R1, _Video_DrawStats_localvar_cur_s, R6
    LWI R7, ship_placement_t_size_offset
    ADD R1, R1, R7
    LWD R1, R1

    LWI R7, _Video_DrawStats_i_loop_end
    JEQ R7, R0, R1

    
    LOAD_OFFSET_IMM_REG R1, _Video_DrawStats_localvar_x, R6

    ADD R0, R0, R1
    LWI R7, 4
    ADD R0, R0, R7

    LOAD_OFFSET_IMM_REG R1, _Video_DrawStats_localvar_y, R6
    LWI R2, SHIP_SYMBOL
    LWI R3, SHIP_FRONT_COLOR
    LWI R4, 0

    // R0 - x + 4 + j
    // R1 - y
    // R2 - SHIP_SYMBOL
    // R3 - SHIP_FRONT_COLOR
    // R4 - 0

    Video_PutChar R0, R1, R2, R3, R4

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_j, R6
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_j, R6
    JMP _Video_DrawStats_j_loop


_Video_DrawStats_i_loop_end:

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_i, R6
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Video_DrawStats_localvar_i, R6
    JMP _Video_DrawStats_i_loop
    
_Video_DrawStats_return:
ENDFUNCTION

#macro Video_DrawStats 
    PUSH_PREV_SP
    CALL _Video_DrawStats
#endmacro

FUNCTION _Video_PlacingShips, 3

    #define _Video_PlacingShips_localvar_grid_size 12 // FIELD_SIZE + 2
    #define _Video_PlacingShips_localvar_start_x   14 // (BUFFER_WIDTH  - grid_size) / 2
    #define _Video_PlacingShips_localvar_start_y    9 // (BUFFER_HEIGHT - grid_size) / 2

    #define _Video_PlacingShips_localvar_i 3
    #define _Video_PlacingShips_localvar_j 4
    #define _Video_PlacingShips_localvar_x 5
    #define _Video_PlacingShips_localvar_y 6

    LOAD_SP R6

    // Funny arguments
    LWI R0, _Video_PlacingShips_localvar_start_x
    LWI R1, _Video_PlacingShips_localvar_start_y
    LWI R2, globalvar_my_placement_state
    LWI R3, placement_state_t_field_offset
    ADD R2, R2, R3
    LWI R3, RAM_BASE_ADDR
    ADD R2, R2, R3
    LWI R3, 0xffff

    Video_DrawField R0, R1, R2, R3


    LOAD_OFFSET_IMM_IMM R0, globalvar_cursor_visible, RAM_BASE_ADDR

    LWI R7, _Video_PlacingShips_draw_bad_placement
    JEZ R7, R0
    
    // my_placement_state->ships_count
    OFFSET_STRUCT_IMM_IMM R0, globalvar_my_placement_state, placement_state_t_ships_count_offset, RAM_BASE_ADDR, R5
    LWD R0, R0

    LWI R6, MAX_SHIPS
    LWI R7, _Video_PlacingShips_draw_bad_placement

    JGQ R7, R0, R6

_Video_PlacingShips_draw_ship:

    // mega funny args
    LOAD_OFFSET_IMM_IMM R0, globalvar_my_cursor_x, RAM_BASE_ADDR
    LWI R7, _Video_PlacingShips_localvar_start_x

    ADD R0, R0, R7 // start_x + my_cursor_x
    INC R0, R0     // start_x + 1 + my_cursor_x

    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_y, RAM_BASE_ADDR

    LWI R7, _Video_PlacingShips_localvar_start_y
    
    ADD R1, R1, R7 // start_y + my_cursor_y
    INC R1, R1     // start_y + 1 + my_cursor_y
     
    // R0 - start_x + 1 + my_cursor_x
    // R1 - start_y + 1 + my_cursor_y

    LWI R6, globalvar_ship_placement_state
    LWI R7, RAM_BASE_ADDR
    ADD R6, R6, R7
    LWI R7, cur_ship_state_t_ship_size_index_offset 
    ADD R2, R6, R7
    LWD R2, R2

    // R2 - ship_size_index

    LWI R3, globalvar_SHIP_SIZES_AND_COUNT
    LWI R7, 2 // sizeof(SHIP_SIZES_AND_COUNT[0]) 
    MUL R2, R2, R7

    ADD R2, R2, R3
    // R2 - SHIP_SIZES_AND_COUNT[ship_placement_state.ship_size_index]

    LWI R7, ship_placement_t_size_offset
    ADD R2, R2, R7
    LWD R2, R2
    // R2 - SHIP_SIZES_AND_COUNT[ship_placement_state.ship_size_index].size

    LWI R7, cur_ship_state_t_horizontal_offset
    ADD R3, R6, R7
    LWD R3, R3
    // ship_placement_state.horizontal

    Video_DrawShip R0, R1, R2, R3


_Video_PlacingShips_draw_bad_placement:

    LOAD_OFFSET_IMM_IMM R0, globalvar_warning_counter, RAM_BASE_ADDR
    //LWI R0, 1
    LWI R7, _Video_PlacingShips_draw_enemy_is_ready
    JEZ R7, R0

    LWI R0, _Video_PlacingShips_warning_counter_str
    LWI R1, 28 // BUFFER_HEIGHT - 2 
    LWI R2, 1  // fg_color
    LWI R3, 0  // bg_color
    Video_PrintCentered R0, R1, R2, R3 

_Video_PlacingShips_draw_enemy_is_ready:

    LOAD_OFFSET_STRUCT_IMM_IMM R0, globalvar_enemy_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR
    //LWI R0, 1
    LWI R7, _Video_PlacingShips_draw_i_am_ready
    JEZ R7, R0

    LWI R0, _Video_PlacingShips_enemy_is_ready_str
    LWI R1, 6  // y
    LWI R2, 1  // fg_color
    LWI R3, 0  // bg_color
    Video_PrintCentered R0, R1, R2, R3 

_Video_PlacingShips_draw_i_am_ready:
    LOAD_OFFSET_STRUCT_IMM_IMM R0, globalvar_my_placement_state, placement_state_t_ready_offset, RAM_BASE_ADDR
    LWI R7, _Video_PlacingShips_draw_am_i_ready
    JEZ R7, R0

    LWI R0, _Video_PlacingShips_ready_str
    LWI R1, 26 // BUFFER_HEIGHT - 4
    LWI R2, 7  // fg_color  
    LWI R3, 0  // bg_color 
    Video_PrintCentered R0, R1, R2, R3 
    JMP _Video_PlacingShips_draw_stats

_Video_PlacingShips_draw_am_i_ready:

    OFFSET_STRUCT_IMM_IMM R0, globalvar_my_placement_state, placement_state_t_ships_count_offset, RAM_BASE_ADDR, R5
    LWD R0, R0
    LWI R6, MAX_SHIPS
    LWI R7, _Video_PlacingShips_draw_stats
    JNQ R7, R0, R6

    LWI R0, _Video_PlacingShips_are_you_ready
    LWI R1, 26 // BUFFER_HEIGHT - 4
    LWI R2, 7  // fg_color
    LWI R3, 0  // bg_color
    Video_PrintCentered R0, R1, R2, R3 

_Video_PlacingShips_draw_stats:
    Video_DrawStats
_Video_PlacingShips_return:
ENDFUNCTION

#macro Video_PlacingShips
    PUSH_PREV_SP
    CALL _Video_PlacingShips
#endmacro

#endif