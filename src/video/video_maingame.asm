#ifndef _VIDEO_MAIN_GAME_ASM_
#define _VIDEO_MAIN_GAME_ASM_

FUNCTION _Video_DrawFields, 2

    
    // const int field_size = FIELD_SIZE + 2;
    // const int spacing = 4;
    // 
    // int total_width = 2 * field_size + spacing;

    // int my_field_start_x = (BUFFER_WIDTH - total_width) / 2;
    #define _Video_DrawFields_const_my_field_start_x 6

    // int my_field_start_y = (BUFFER_HEIGHT - field_size) / 2;
    #define _Video_DrawFields_const_my_field_start_y 9

    // int enemy_field_start_x = my_field_start_x + field_size + spacing;
    #define _Video_DrawFields_const_enemy_field_start_x 22
    
    // int enemy_field_start_y = my_field_start_y;
    #define _Video_DrawFields_const_enemy_field_start_y 9


    #define _Video_DrawFields_localvar_x 3
    #define _Video_DrawFields_localvar_y 4

    #define _Video_DrawFields_localarg_cursor_x 5
    #define _Video_DrawFields_localarg_cursor_y 6
    #define _Video_DrawFields_localarg_my_turn  7


    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R2, _Video_DrawFields_localarg_my_turn, R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawFields_localarg_cursor_x, R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawFields_localarg_cursor_y, R6

    LWI R7, _Video_DrawFields_not_my_turn
    JEZ R7, R2

    LWI R2, _Video_DrawFields_const_enemy_field_start_x
    LWI R3, _Video_DrawFields_const_enemy_field_start_y
    
    JMP _Video_DrawFields_draw_fields

_Video_DrawFields_not_my_turn:

    LWI R2, _Video_DrawFields_const_my_field_start_x
    LWI R3, _Video_DrawFields_const_my_field_start_y
    

_Video_DrawFields_draw_fields:

    
    INC R2, R2
    INC R3, R3
    ADD R0, R0, R2
    ADD R1, R1, R3

    STORE_OFFSET_IMM_REG R0, _Video_DrawFields_localvar_x, R6
    STORE_OFFSET_IMM_REG R1, _Video_DrawFields_localvar_y, R6

    LWI R0, _Video_DrawFields_const_my_field_start_x
    LWI R1, _Video_DrawFields_const_my_field_start_y

    OFFSET_IMM_IMM R2, globalvar_my_placement_state, RAM_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R2, R2, placement_state_t_field_offset

    LWI R3, 0xFFFF
    Video_DrawField R0, R1, R2, R3

    LWI R0, _Video_DrawFields_const_enemy_field_start_x
    LWI R1, _Video_DrawFields_const_enemy_field_start_y

    OFFSET_IMM_IMM R2, globalvar_enemy_placement_state, RAM_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R2, R2, placement_state_t_field_offset

    LWI R3, 0x0000
    Video_DrawField R0, R1, R2, R3

    LOAD_OFFSET_IMM_IMM R0, globalvar_cursor_visible, RAM_BASE_ADDR
    LWI R7, _Video_DrawFields_return

    JEZ R7, R0

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Video_DrawFields_localvar_x, R6
    LOAD_OFFSET_IMM_REG R1, _Video_DrawFields_localvar_y, R6
    LWI R2, CURSOR_SYMBOL
    
    LOAD_OFFSET_IMM_REG R3, _Video_DrawFields_localarg_my_turn, R6

    LWI R7, _Video_DrawFields_enemy_cursor
    
    JEZ R7, R3 

    LWI R3, 2

    JMP _Video_DrawFields_draw_cursor

_Video_DrawFields_enemy_cursor:
    LWI R3, 1
_Video_DrawFields_draw_cursor:

    LWI R4, CURSOR_BACK_COLOR
    Video_PutChar R0, R1, R2, R3, R4

_Video_DrawFields_return:
ENDFUNCTION

#macro Video_DrawFields cursor_x, cursor_y, my_turn
    PUSH_PREV_SP
    PUSH my_turn
    PUSH cursor_y
    PUSH cursor_x
    CALL _Video_DrawFields
#endmacro











































_Video_DrawMyTurn_arrow_str:
    .string "->"
_Video_DrawMyTurn_your_turn_str: 
    .string "YOUR TURN"

FUNCTION _Video_DrawMyTurn, 0


    LOAD_OFFSET_IMM_IMM R0, globalvar_my_cursor_x, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R1, globalvar_my_cursor_y, RAM_BASE_ADDR
    LWI R2, 0xFFFF 
    
    Video_DrawFields R0, R1, R2


    LWI R0, _Video_DrawMyTurn_arrow_str
    LWI R1, 19 // BUFFER_WIDTH / 2 - 1
    LWI R2, 15 // BUFFER_HEIGHT / 2
    LWI R3, 7
    LWI R4, 0

    Video_Print R0, R1, R2, R3, R4


    LWI R0, _Video_DrawMyTurn_your_turn_str
    LWI R1, 6 
    LWI R2, 7
    LWI R3, 0

    Video_PrintCentered R0, R1, R2, R3

ENDFUNCTION

#macro Video_DrawMyTurn
    PUSH_PREV_SP
    CALL _Video_DrawMyTurn
#endmacro







































_Video_DrawEnemyTurn_arrow_str: 
    .string "<-"
_Video_DrawEnemyTurn_enemy_turn_str: 
    .string "ENEMY'S TURN"

FUNCTION _Video_DrawEnemyTurn, 0

    
    LOAD_OFFSET_IMM_IMM R0, globalvar_enemy_cursor_x, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R1, globalvar_enemy_cursor_y, RAM_BASE_ADDR
    LWI R2, 0x0000 
    
    Video_DrawFields R0, R1, R2


    LWI R0, _Video_DrawEnemyTurn_arrow_str
    LWI R1, 19 // BUFFER_WIDTH  / 2 - 1
    LWI R2, 15 // BUFFER_HEIGHT / 2
    LWI R3, 7
    LWI R4, 0

    Video_Print R0, R1, R2, R3, R4


    LWI R0, _Video_DrawEnemyTurn_enemy_turn_str
    LWI R1, 6 
    LWI R2, 1
    LWI R3, 0

    Video_PrintCentered R0, R1, R2, R3


ENDFUNCTION

#macro Video_DrawEnemyTurn
    PUSH_PREV_SP
    CALL _Video_DrawEnemyTurn
#endmacro



#endif