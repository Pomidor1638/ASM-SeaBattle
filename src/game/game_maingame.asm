#ifndef _GAME_MAIN_GAME_ASM_
#define _GAME_MAIN_GAME_ASM_


FUNCTION _Game_DamageShip, 1

    #define _Game_DamageShip_localvar_h 3

    #define _Game_DamageShip_localarg_s 4
    #define _Game_DamageShip_localarg_x 5
    #define _Game_DamageShip_localarg_y 6

    LOAD_SP R6

    // s->horizontal
    LOAD_OFFSET_IMM_REG R0, _Game_DamageShip_localarg_s, R6
    OFFSET_STRUCT_REG_IMM R1, R0, ship_t_horizontal_offset
    LWD R1, R1

    // if (s->horizontal)
    LWI R7, _Game_DamageShip_not_horizontal
    JEZ R7, R1

    LOAD_OFFSET_IMM_REG R1, _Game_DamageShip_localarg_x, R6
    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_x_offset
    LWD R2, R2

    SUB R1, R1, R2

    JMP _Game_DamageShip_check_bounds

_Game_DamageShip_not_horizontal:

    LOAD_OFFSET_IMM_REG R1, _Game_DamageShip_localarg_y, R6
    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_y_offset
    LWD R2, R2

    SUB R1, R1, R2

    JMP _Game_DamageShip_check_bounds

_Game_DamageShip_check_bounds:

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_size_offset
    LWD R2, R2
    LWI R7, _Game_DamageShip_return_false

    JLZ R7, R1
    JGQ R7, R1, R2

    // s->hits |= 1 << h

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_hits_offset    
    LWD R3, R2
    LWI R4, 1
    SLL R4, R4, R1
    ORR R3, R3, R4

    SWD R2, R3

    OFFSET_STRUCT_REG_IMM R1, R0, ship_t_size_offset
    LWD R1, R1
    LWI R2, 1
    SLL R2, R2, R1
    DEC R2, R2

    LWI R7, _Game_DamageShip_return_false
    JNQ R7, R3, R2

_Game_DamageShip_return_true:
    LWI R0, 0xFFFF
    RETURN
_Game_DamageShip_return_false:
    LWI R0, 0x0000
ENDFUNCTION

#macro Game_DamageShip s, x, y

    PUSH_PREV_SP 

    PUSH y
    PUSH x
    PUSH s

    CALL _Game_DamageShip

#endmacro 


FUNCTION _Game_SunkShip, 6

    #define _Game_SunkShip_localvar_start_x           3
    #define _Game_SunkShip_localvar_start_y           4
    #define _Game_SunkShip_localvar_end_x             5
    #define _Game_SunkShip_localvar_end_y             6
    #define _Game_SunkShip_localvar_x                 7
    #define _Game_SunkShip_localvar_y                 8
 
    #define _Game_SunkShip_localarg_placement_state   9
    #define _Game_SunkShip_localarg_s                10


    LOAD_SP R6

    LOAD_OFFSET_IMM_REG R0, _Game_SunkShip_localarg_s, R6
    
    OFFSET_STRUCT_REG_IMM R1, R0, ship_t_x_offset
    LWD R1, R1
    DEC R3, R1
    STORE_OFFSET_IMM_REG R3, _Game_SunkShip_localvar_start_x, R6

    OFFSET_STRUCT_REG_IMM R2, R0, ship_t_y_offset
    LWD R2, R2
    DEC R3, R2
    STORE_OFFSET_IMM_REG R3, _Game_SunkShip_localvar_start_y, R6

    OFFSET_STRUCT_REG_IMM R3, R0, ship_t_size_offset
    LWD R3, R3

    // R0 - s
    // R1 - s->x
    // R2 - s->y
    // R3 - s->size

    OFFSET_STRUCT_REG_IMM R4, R0, ship_t_horizontal_offset
    LWD R4, R4
    LWI R7, _Game_SunkShip_not_horizontal
    JEZ R7, R4

    ADD R1, R1, R3
    INC R2, R2

    JMP _Game_SunkShip_fill_cell_miss


_Game_SunkShip_not_horizontal:

    INC R1, R1
    ADD R2, R2, R3

_Game_SunkShip_fill_cell_miss:

    STORE_OFFSET_IMM_REG R1, _Game_SunkShip_localvar_end_x, R6
    STORE_OFFSET_IMM_REG R2, _Game_SunkShip_localvar_end_y, R6

    LOAD_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_start_y, R6
    STORE_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_y, R6

    // R0 - y 
    // R1 - x
    // R2 - field_ptr
    // R3 - 
    // R4 - 
    // R5 - 
    // R6 - SP 
    // R7 -


_Game_SunkShip_fill_cell_miss_y_loop:

    LOAD_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_y, R6
    LOAD_OFFSET_IMM_REG R1, _Game_SunkShip_localvar_end_y, R6
    LWI R7, _Game_SunkShip_fill_cell_sunk
    JPG R7, R0, R1

    LOAD_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_start_x, R6
    STORE_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_x, R6

_Game_SunkShip_fill_cell_miss_x_loop:

    LOAD_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_x, R6
    LOAD_OFFSET_IMM_REG R1, _Game_SunkShip_localvar_end_x, R6
    LWI R7, _Game_SunkShip_fill_cell_miss_y_loop_end
    JPG R7, R0, R1

    LOAD_OFFSET_IMM_REG R1, _Game_SunkShip_localvar_y, R6
    LWI R2, FIELD_SIZE
    LWI R7, _Game_SunkShip_fill_cell_miss_x_loop_end

    // if (x < 0 || x >= FIELD_SIZE || y < 0 || y >= FIELD_SIZE)
    //      continue;
    
    JLZ R7, R0
    JLZ R7, R1
    JGQ R7, R0, R2
    JGQ R7, R1, R2

    LOAD_OFFSET_IMM_REG R3, _Game_SunkShip_localarg_placement_state, R6
    OFFSET_STRUCT_REG_IMM R3, R3, placement_state_t_field_offset
    
    ARRAY_INDEX_REG_REG R3, R3, R1, 20 // FIELD_SIZE * sizeof(fieldcell_t)
    ARRAY_INDEX_REG_REG R3, R3, R0, 2  //              sizeof(fieldcell_t)
    
    OFFSET_STRUCT_REG_IMM R3, R3, fieldcell_t_state_offset

    LWI R4, CELL_MISS
    SWD R3, R4

_Game_SunkShip_fill_cell_miss_x_loop_end:
    
    LOAD_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_x, R6
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_x, R6
    JMP _Game_SunkShip_fill_cell_miss_x_loop

_Game_SunkShip_fill_cell_miss_y_loop_end:
    
    LOAD_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_y, R6
    INC R0, R0
    STORE_OFFSET_IMM_REG R0, _Game_SunkShip_localvar_y, R6
    JMP _Game_SunkShip_fill_cell_miss_y_loop


_Game_SunkShip_fill_cell_sunk:

    // R0 - ptr
    // R1 - inc
    // R2 - size
    // R3 - CELL_SUNK
    // R4 - 
    // R5 - 
    // R6 -
    // R7 - 

    // R0 - ptr
    LOAD_OFFSET_IMM_REG R0, _Game_SunkShip_localarg_placement_state, R6
    OFFSET_STRUCT_REG_IMM R0, R0, placement_state_t_field_offset
    OFFSET_STRUCT_REG_IMM R0, R0, fieldcell_t_state_offset

    LOAD_OFFSET_IMM_REG R5, _Game_SunkShip_localarg_s, R6
    OFFSET_STRUCT_REG_IMM R2, R5, ship_t_x_offset
    LWD R2, R2
    OFFSET_STRUCT_REG_IMM R3, R5, ship_t_y_offset
    LWD R3, R3

    ARRAY_INDEX_REG_REG R0, R0, R3, 20 // FIELD_SIZE * sizeof(fieldcell_t)
    ARRAY_INDEX_REG_REG R0, R0, R2, 2  //              sizeof(fieldcell_t)

    // R1 - inc
    OFFSET_STRUCT_REG_IMM R2, R5, ship_t_horizontal_offset
    LWD R2, R2

    LWI R7, _Game_SunkShip_fill_cell_sunk_not_horizontal
    JEZ R7, R2

    LWI R1, 2

    JMP _Game_SunkShip_fill_cell_sunk_size_init

_Game_SunkShip_fill_cell_sunk_not_horizontal:


    LWI R1, 20


_Game_SunkShip_fill_cell_sunk_size_init:

    
    OFFSET_STRUCT_REG_IMM R2, R5, ship_t_size_offset
    LWD R2, R2

    LWI R3, CELL_SUNK

    LWI R7, _Game_SunkShip_return

    // R0 - ptr
    // R1 - inc
    // R2 - size
    // R3 - CELL_SUNK
    // R4 - 
    // R5 - 
    // R6 -
    // R7 - 

_Game_SunkShip_fill_cell_sunk_loop:

    JEZ R7, R2

    SWD R0, R3

    DEC R2, R2
    ADD R0, R0, R1
    JMP _Game_SunkShip_fill_cell_sunk_loop

_Game_SunkShip_return:
ENDFUNCTION

#macro Game_SunkShip placement_state, s
    PUSH_PREV_SP
    PUSH s
    PUSH placement_state
    CALL _Game_SunkShip
#endmacro


FUNCTION _Game_ShootToField, 2

    #define _Game_ShootToField_localvar_cell 3
    #define _Game_ShootToField_localvar_s    4

    #define _Game_ShootToField_localarg_res              5
    #define _Game_ShootToField_localarg_placement_state  6
    #define _Game_ShootToField_localarg_x                7
    #define _Game_ShootToField_localarg_y                8

    LOAD_SP R6
    
    // fieldcell_t* cell = &placement_state->field[y][x];
    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localarg_placement_state, R6
    OFFSET_STRUCT_REG_IMM R0, R0, placement_state_t_field_offset
    
    LOAD_OFFSET_IMM_REG R1, _Game_ShootToField_localarg_y, R6
    ARRAY_INDEX_REG_REG R0, R0, R1, 20 // FIELD_SIZE * sizeof(fieldcell_t)
    
    LOAD_OFFSET_IMM_REG R1, _Game_ShootToField_localarg_x, R6
    ARRAY_INDEX_REG_REG R0, R0, R1, 2 // sizeof(fieldcell_t)
    
    STORE_OFFSET_IMM_REG R0, _Game_ShootToField_localvar_cell, R6
    
    // fieldcell_t res = *cell;
    LOAD_OFFSET_IMM_REG R1, _Game_ShootToField_localarg_res, R6
    LWD R2, R0
    SWD R1, R2
    INC R1, R1
    INC R0, R0
    LWD R2, R0
    SWD R1, R2
    
    // Восстанавливаем указатель на cell
    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localvar_cell, R6
    
    // switch (cell->state)
    OFFSET_STRUCT_REG_IMM R1, R0, fieldcell_t_state_offset
    LWD R2, R1  // R2 = cell->state
    
    // case CELL_EMPTY:
    LWI R7, _Game_ShootToField_check_cell_ship
    LWI R5, CELL_EMPTY
    JNQ R7, R2, R5  // Если НЕ равно CELL_EMPTY, переходим к следующей проверке

    // Здесь код для CELL_EMPTY
    LWI R5, CELL_MISS
    SWD R1, R5  // cell->state = CELL_MISS
    LOAD_OFFSET_IMM_REG R2, _Game_ShootToField_localarg_res, R6
    OFFSET_STRUCT_REG_IMM R2, R2, fieldcell_t_state_offset
    SWD R2, R5  // res.state = CELL_MISS
    
    JMP _Game_ShootToField_return

_Game_ShootToField_check_cell_ship:
    // case CELL_SHIP:
    LWI R7, _Game_ShootToField_case_default
    LWI R5, CELL_SHIP
    JNQ R7, R2, R5 
    
    LOAD_OFFSET_IMM_REG R2, _Game_ShootToField_localarg_placement_state, R6
    OFFSET_STRUCT_REG_IMM R2, R2, placement_state_t_ships_offset
    // R2 = placement_state->ships

    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localvar_cell, R6
    OFFSET_STRUCT_REG_IMM R3, R0, fieldcell_t_ship_index_offset
    LWD R3, R3  // R3 = cell->ship_index

    // s = placement_state->ships + cell->ship_index;
    LWI R4, 5  // sizeof(ship_t) в словах
    MUL R3, R3, R4
    ADD R2, R2, R3  // R2 = s

    STORE_OFFSET_IMM_REG R2, _Game_ShootToField_localvar_s, R6

    LOAD_OFFSET_IMM_REG R3, _Game_ShootToField_localarg_x, R6
    LOAD_OFFSET_IMM_REG R4, _Game_ShootToField_localarg_y, R6

    // DamageShip(s, x, y)
    Game_DamageShip R2, R3, R4

    LOAD_SP R6
    LWI R7, _Game_ShootToField_ship_not_sunked
    JEZ R7, R0 

    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localarg_placement_state, R6
    LOAD_OFFSET_IMM_REG R1, _Game_ShootToField_localvar_s, R6
    
    // SunkShip(placement_state, s)
    Game_SunkShip R0, R1
    LOAD_SP R6

    // res.state = CELL_SUNK
    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localarg_res, R6
    OFFSET_STRUCT_REG_IMM R0, R0, fieldcell_t_state_offset
    LWI R5, CELL_SUNK
    SWD R0, R5
    
    // bg_blink_counter = 10
    LWI R5, 10
    STORE_OFFSET_IMM_IMM R5, globalvar_bg_blink_counter, RAM_BASE_ADDR

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localarg_placement_state, R6

    OFFSET_STRUCT_REG_IMM R1, R0, placement_state_t_ships_count_offset
    LWD R2, R1
    DEC R2, R2
    SWD R1, R2

    LWI R7, _Game_ShootToField_remove_sunked_ship
    JNZ R7, R2

    LWI R5, 0xFFFF
    STORE_OFFSET_IMM_IMM R5, globalvar_all_ships_destroyed, RAM_BASE_ADDR

_Game_ShootToField_remove_sunked_ship:
    OFFSET_STRUCT_REG_IMM R0, R0, placement_state_t_placed_ships_offset
    
    // MAX_SHIPS_SIZE - s->size
    LOAD_OFFSET_IMM_REG R1, _Game_ShootToField_localvar_s, R6
    OFFSET_STRUCT_REG_IMM R1, R1, ship_t_size_offset
    LWD R1, R1
    LWI R7, MAX_SHIPS_SIZE
    SUB R1, R7, R1

    ARRAY_INDEX_REG_REG R0, R0, R1, 1
    LWD R1, R0
    DEC R1, R1
    SWD R0, R1

    JMP _Game_ShootToField_return

_Game_ShootToField_ship_not_sunked:
    // Корабль не потоплен
    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localvar_cell, R6
    OFFSET_STRUCT_REG_IMM R0, R0, fieldcell_t_state_offset
    LWI R5, CELL_HIT
    SWD R0, R5  // cell->state = CELL_HIT

    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localarg_res, R6
    OFFSET_STRUCT_REG_IMM R0, R0, fieldcell_t_state_offset
    SWD R0, R5  // res.state = CELL_HIT

    LWI R5, 5
    STORE_OFFSET_IMM_IMM R5, globalvar_bg_blink_counter, RAM_BASE_ADDR

    JMP _Game_ShootToField_return

_Game_ShootToField_case_default:
    // default case
    LWI R5, CELL_DONT_SHOT
    LOAD_OFFSET_IMM_REG R0, _Game_ShootToField_localarg_res, R6
    OFFSET_STRUCT_REG_IMM R0, R0, fieldcell_t_state_offset
    SWD R0, R5  // res.state = CELL_DONT_SHOT

_Game_ShootToField_return:
    RETURN
ENDFUNCTION



#macro Game_ShootToField cell_ptr, placement_state, x, y

    PUSH_PREV_SP

    PUSH y
    PUSH x
    PUSH placement_state
    PUSH cell_ptr

    CALL _Game_ShootToField

#endmacro


FUNCTION _Game_ServerShoot, 3

    #define _Game_ServerShoot_localvar_cell 3 // sizeof == 2 (state, ship_index)
    #define _Game_ServerShoot_localvar_s    5 // ship_t* pointer

    LOAD_SP R6
    
    // Создаем локальную переменную cell на стеке
    LWI R7, _Game_ServerShoot_localvar_cell
    ADD R0, R6, R7  // R0 = &cell (указатель на fieldcell_t)
    
    // Загружаем аргументы для Game_ShootToField
    OFFSET_IMM_IMM R1, globalvar_enemy_placement_state, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R2, globalvar_my_cursor_x, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R3, globalvar_my_cursor_y, RAM_BASE_ADDR
    
    // Вызов Game_ShootToField(&cell, enemy_placement_state, my_cursor_x, my_cursor_y)
    Game_ShootToField R0, R1, R2, R3
    // После вызова cell содержит результат
    
    LOAD_SP R6
    
    // outgoing_packet.data[0] = cell.state;
    OFFSET_IMM_REG R0, _Game_ServerShoot_localvar_cell, R6
    OFFSET_STRUCT_REG_IMM R0, R0, fieldcell_t_state_offset
    LWD R1, R0  // R1 = cell.state
    
    LWI R2, NET_BASE_ADDR
    LWI R3, NET_SEND_PACKET
    ADD R2, R2, R3
    INC R2, R2  // R2 = &outgoing_packet.data[0]
    SWD R2, R1
    
    // outgoing_packet.data[1] = my_cursor_x;
    INC R2, R2
    LOAD_OFFSET_IMM_IMM R0, globalvar_my_cursor_x, RAM_BASE_ADDR
    SWD R2, R0
    
    // outgoing_packet.data[2] = my_cursor_y;
    INC R2, R2
    LOAD_OFFSET_IMM_IMM R0, globalvar_my_cursor_y, RAM_BASE_ADDR
    SWD R2, R0

    LOAD_SP R6
    OFFSET_IMM_REG R0, _Game_ServerShoot_localvar_cell, R6
    OFFSET_STRUCT_REG_IMM R0, R0, fieldcell_t_state_offset
    LWD R1, R0  
    
    LWI R5, CELL_SUNK
    LWI R7, _Game_ServerShoot_not_sunked
    JNQ R7, R1, R5
    
    // s = enemy_placement_state.ships + cell.ship_index;
    OFFSET_IMM_IMM R0, globalvar_enemy_placement_state, RAM_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R0, R0, placement_state_t_ships_offset 
    // R0 - enemy_placement_state.ships
    
    LOAD_SP R6
    OFFSET_IMM_REG R1, _Game_ServerShoot_localvar_cell, R6
    OFFSET_STRUCT_REG_IMM R1, R1, fieldcell_t_ship_index_offset
    LWD R1, R1  // R1 = cell.ship_index
    
    // Умножаем индекс на размер структуры ship_t (5 слов)
    ARRAY_INDEX_REG_REG R0, R0, R1, 5
    STORE_OFFSET_IMM_REG R0, _Game_ServerShoot_localvar_s, R6

    // outgoing_packet.data[3] = s->x;
    LWI R2, NET_BASE_ADDR
    LWI R3, NET_SEND_PACKET
    ADD R2, R2, R3
    INC R2, R2
    LWI R3, 3
    ADD R2, R2, R3  // R2 = &outgoing_packet.data[3]
    
    OFFSET_STRUCT_REG_IMM R3, R0, ship_t_x_offset
    LWD R3, R3  // R3 = s->x
    SWD R2, R3
    
    // outgoing_packet.data[4] = s->y;
    INC R2, R2
    OFFSET_STRUCT_REG_IMM R3, R0, ship_t_y_offset
    LWD R3, R3  // R3 = s->y
    SWD R2, R3
    
    // outgoing_packet.data[5] = s->size;
    INC R2, R2
    OFFSET_STRUCT_REG_IMM R3, R0, ship_t_size_offset
    LWD R3, R3  // R3 = s->size
    SWD R2, R3
    
    // outgoing_packet.data[6] = s->horizontal;
    INC R2, R2
    OFFSET_STRUCT_REG_IMM R3, R0, ship_t_horizontal_offset
    LWD R3, R3  // R3 = s->horizontal
    SWD R2, R3
    
    JMP _Game_ServerShoot_return

_Game_ServerShoot_not_sunked:

    // else блок из C кода: need_switch = cell.state == CELL_MISS;
    
    // Проверяем cell.state == CELL_MISS
    // R1 все еще содержит cell.state
    LWI R5, CELL_MISS
    LWI R0, 0x0000  // Предполагаем false (0)
    
    LWI R7, _Game_ServerShoot_set_need_switch_true
    JEQ R7, R1, R5
    
    // Если не равно CELL_MISS, то уже false
    JMP _Game_ServerShoot_store_need_switch

_Game_ServerShoot_set_need_switch_true:
    LWI R0, 0xFFFF  
_Game_ServerShoot_store_need_switch:
    STORE_OFFSET_IMM_IMM R0, globalvar_need_switch, RAM_BASE_ADDR
_Game_ServerShoot_return:
ENDFUNCTION

#macro Game_ServerShoot
    PUSH_PREV_SP
    CALL _Game_ServerShoot
#endmacro


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
    Game_ServerShoot

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

    OFFSET_IMM_IMM R0, NET_RECV_PACKET, NET_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R0, R0, packet_t_data_offset

    LWD R1, R0
    STORE_OFFSET_IMM_IMM R1, globalvar_enemy_cursor_x, RAM_BASE_ADDR

    INC R0, R0
    LWD R1, R0
    STORE_OFFSET_IMM_IMM R1, globalvar_enemy_cursor_y, RAM_BASE_ADDR

    LOAD_SP R6
    LWI R0, _Game_Server_HandleShootRequest_localvar_cell
    ADD R0, R0, R6
    OFFSET_IMM_IMM R1, globalvar_my_placement_state, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R2, globalvar_enemy_cursor_x, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R3, globalvar_enemy_cursor_y, RAM_BASE_ADDR

    Game_ShootToField R0, R1, R2, R3

    // outgoing_packet.type = PACKET_SHOOT_RESPONSE;
    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R7, PACKET_SHOOT_RESPONSE
    SWD R0, R7

    // outgoing_packet.data[0] = cell.state;
    INC R0, R0
    LOAD_SP R6
    OFFSET_IMM_REG R1, _Game_Server_HandleShootRequest_localvar_cell, R6
    OFFSET_STRUCT_REG_IMM R2, R1, fieldcell_t_state_offset
    LWD R2, R2
    SWD R0, R2

	// outgoing_packet.data[1] = enemy_cursor_x;
    INC R0, R0
    LOAD_OFFSET_IMM_IMM R1, globalvar_enemy_cursor_x, RAM_BASE_ADDR
    SWD R0, R1

    
	// outgoing_packet.data[2] = enemy_cursor_y;
    INC R0, R0
    LOAD_OFFSET_IMM_IMM R1, globalvar_enemy_cursor_y, RAM_BASE_ADDR
    SWD R0, R1

    LOAD_SP R6
    OFFSET_IMM_REG R1, _Game_Server_HandleShootRequest_localvar_cell, R6
    OFFSET_STRUCT_REG_IMM R2, R1, fieldcell_t_state_offset
    LWD R2, R2

    LWI R5, CELL_SUNK
    LWI R7, _Game_Server_ship_not_sunked
    JNQ R7, R2, R5

    // s = my_placement_state.ships + cell.ship_index;
    OFFSET_IMM_IMM R2, globalvar_my_placement_state, RAM_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R2, R2, placement_state_t_ships_offset

    OFFSET_STRUCT_REG_IMM R1, R1, fieldcell_t_ship_index_offset
    LWD R1, R1

    ARRAY_INDEX_REG_REG R1, R2, R1, 5 // sizeof(ship_t)

    // outgoing_packet.data[3] = s->x;
    INC R0, R0
    OFFSET_STRUCT_REG_IMM R2, R1, ship_t_x_offset
    LWD R2, R2
    SWD R0, R2

    // outgoing_packet.data[4] = s->y;
    INC R0, R0
    OFFSET_STRUCT_REG_IMM R2, R1, ship_t_y_offset
    LWD R2, R2
    SWD R0, R2

    // outgoing_packet.data[5] = s->size;
    INC R0, R0
    OFFSET_STRUCT_REG_IMM R2, R1, ship_t_size_offset
    LWD R2, R2
    SWD R0, R2

    // outgoing_packet.data[6] = s->horizontal;
    INC R0, R0
    OFFSET_STRUCT_REG_IMM R2, R1, ship_t_horizontal_offset
    LWD R2, R2
    SWD R0, R2

    JMP _Game_Server_ship_send_packet

_Game_Server_ship_not_sunked:

    LWI R0, 0x0000

    LWI R7, _Game_Server_needswitch_true
    LWI R5, CELL_MISS
    JEQ R7, R2, R5
    JMP _Game_Server_set_needswitch

_Game_Server_needswitch_true:
    LWI R0, 0xFFFF
_Game_Server_set_needswitch:
    STORE_OFFSET_IMM_IMM R0, globalvar_need_switch, RAM_BASE_ADDR

_Game_Server_ship_send_packet:

    NET_SendPacket
    Game_EndWaitRemote

ENDFUNCTION

#macro Game_Server_HandleShootRequest
    PUSH_PREV_SP
    CALL _Game_Server_HandleShootRequest
#endmacro



FUNCTION _Game_ProcessReceivedCell, 1


    #define _Game_ProcessReceivedCell_localvar_current_cell    3

    #define _Game_ProcessReceivedCell_localarg_placement_state 4
    #define _Game_ProcessReceivedCell_localarg_state           5
    #define _Game_ProcessReceivedCell_localarg_s               6
    #define _Game_ProcessReceivedCell_localarg_x               7
    #define _Game_ProcessReceivedCell_localarg_y               8

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Game_ProcessReceivedCell_localarg_placement_state, R6
    LOAD_OFFSET_IMM_REG R1, _Game_ProcessReceivedCell_localarg_y, R6
    LOAD_OFFSET_IMM_REG R2, _Game_ProcessReceivedCell_localarg_x, R6
    
    OFFSET_STRUCT_REG_IMM R0, R0, placement_state_t_field_offset    
    ARRAY_INDEX_REG_REG R0, R0, R1, 20 // FIELD_SIZE * sizeof(fieldcell_t)
    ARRAY_INDEX_REG_REG R0, R0, R2, 2  // sizeof(fieldcell_t)
    STORE_OFFSET_IMM_REG R0, _Game_ProcessReceivedCell_localvar_current_cell, R6
    OFFSET_STRUCT_REG_IMM R0, R0, fieldcell_t_state_offset

    LOAD_OFFSET_IMM_REG R1, _Game_ProcessReceivedCell_localarg_state, R6 

// switch (state)
// {
// case CELL_HIT:

    LWI R7, _Game_ProcessReceivedCell_cell_sunk
    LWI R5, CELL_HIT
    JNQ R7, R1, R5

    SWD R0, R1

    LWI R1, 5
    STORE_OFFSET_IMM_IMM R1, globalvar_bg_blink_counter, RAM_BASE_ADDR

    JMP _Game_ProcessReceivedCell_return

_Game_ProcessReceivedCell_cell_sunk:
// case CELL_SUNK:

    LWI R7, _Game_ProcessReceivedCell_cell_miss
    LWI R5, CELL_SUNK
    JNQ R7, R1, R5

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R0, _Game_ProcessReceivedCell_localarg_placement_state, R6
    LOAD_OFFSET_IMM_REG R1, _Game_ProcessReceivedCell_localarg_s, R6

    Game_SunkShip R0, R1

    LWI R1, 10
    STORE_OFFSET_IMM_IMM R1, globalvar_bg_blink_counter, RAM_BASE_ADDR

    JMP _Game_ProcessReceivedCell_return

_Game_ProcessReceivedCell_cell_miss:
// case CELL_MISS:

    LWI R7, _Game_ProcessReceivedCell_cell_dont_shot
    LWI R5, CELL_MISS
    JNQ R7, R1, R5

    SWD R0, R1 

    JMP _Game_ProcessReceivedCell_return
    
_Game_ProcessReceivedCell_cell_dont_shot:
_Game_ProcessReceivedCell_return:
ENDFUNCTION


#macro Game_ProcessReceivedCell placement_state, state, s, x, y
    PUSH_PREV_SP

    PUSH y
    PUSH x
    PUSH s
    PUSH state
    PUSH placement_state

    CALL _Game_ProcessReceivedCell
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
    LWI R6, RAM_BASE_ADDR
    LWI R7, globalvar_enemy_placement_state
    ADD R2, R6, R7
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
    Game_ProcessReceivedCell R0, R1, R2, R3, R4

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


#macro Game_Server_HandleShootResponse
    Game_EndWaitRemote
#endmacro


FUNCTION _Game_Client_HandleShootResponse, 2

    #define _Game_Client_HandleShootResponse_localvar_s     3
    #define _Game_Client_HandleShootResponse_localvar_state 4

    
    OFFSET_IMM_IMM R0, NET_RECV_PACKET, NET_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R0, R0, packet_t_data_offset

    LOAD_SP R6
    LWI R1, 0x0000
    STORE_OFFSET_IMM_REG R1, _Game_Client_HandleShootResponse_localvar_s, R6
    
    LWD R1, R0
    STORE_OFFSET_IMM_REG R1, _Game_Client_HandleShootResponse_localvar_state, R6

    INC R0, R0
    LWD R1, R0
    STORE_OFFSET_IMM_IMM R1, globalvar_enemy_cursor_x, RAM_BASE_ADDR
    
    INC R0, R0
    LWD R1, R0
    STORE_OFFSET_IMM_IMM R1, globalvar_enemy_cursor_y, RAM_BASE_ADDR

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R1, _Game_Client_HandleShootResponse_localvar_state, R6
    LWI R5, CELL_SUNK
    LWI R7, _Game_Client_HandleShootResponse_process_cell
    JNQ R7, R1, R5

    OFFSET_IMM_IMM R1, globalvar_enemy_placement_state, RAM_BASE_ADDR
    OFFSET_STRUCT_REG_IMM R1, R1, placement_state_t_ships_offset
    LOAD_SP R6
    STORE_OFFSET_IMM_REG R1, _Game_Client_HandleShootResponse_localvar_s, R6

    // s->x = incomming_packet.data[3];
    INC R0, R0
    LWD R3, R0
    OFFSET_STRUCT_REG_IMM R2, R1, ship_t_x_offset
    SWD R2, R3

    // s->y = incomming_packet.data[4];
    INC R0, R0
    LWD R3, R0
    OFFSET_STRUCT_REG_IMM R2, R1, ship_t_y_offset
    SWD R2, R3

    // s->size = incomming_packet.data[5];
    INC R0, R0
    LWD R3, R0
    OFFSET_STRUCT_REG_IMM R2, R1, ship_t_size_offset
    SWD R2, R3

    // s->horizontal = incomming_packet.data[6];
    INC R0, R0
    LWD R3, R0
    OFFSET_STRUCT_REG_IMM R2, R1, ship_t_horizontal_offset
    SWD R2, R3

_Game_Client_HandleShootResponse_process_cell:

    OFFSET_IMM_IMM R0, globalvar_enemy_placement_state, RAM_BASE_ADDR
    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R1, _Game_Client_HandleShootResponse_localvar_state, R6
    LOAD_OFFSET_IMM_REG R2, _Game_Client_HandleShootResponse_localvar_s    , R6
    LOAD_OFFSET_IMM_IMM R3, globalvar_enemy_cursor_x, RAM_BASE_ADDR
    LOAD_OFFSET_IMM_IMM R4, globalvar_enemy_cursor_y, RAM_BASE_ADDR
    
    Game_ProcessReceivedCell R0, R1, R2, R3, R4
    Game_EndWaitRemote

ENDFUNCTION



#macro Game_Client_HandleShootResponse
    PUSH_PREV_SP
    CALL _Game_Client_HandleShootResponse
#endmacro



FUNCTION _Game_HandleShootResponse, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_server_mode, RAM_BASE_ADDR
    LWI R7, _Game_HandleShootResponse_not_server_mode
    JEZ R7, R0

    Game_Server_HandleShootResponse
    RETURN

_Game_HandleShootResponse_not_server_mode:
    Game_Client_HandleShootResponse

ENDFUNCTION




#macro Game_HandleShootResponse
    PUSH_PREV_SP
    CALL _Game_HandleShootResponse
#endmacro




FUNCTION _Game_HandleTurnRequest, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR
    NOT R0, R0
    STORE_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR

    OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR
    LWI R1, PACKET_TURN_SWITCH_RESPONSE
    SWD R0, R1

    NET_SendPacket

ENDFUNCTION


#macro Game_HandleTurnRequest
    PUSH_PREV_SP
    CALL _Game_HandleTurnRequest
#endmacro

FUNCTION _Game_HandleTurnResponse, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR
    NOT R0, R0
    STORE_OFFSET_IMM_IMM R0, globalvar_my_turn, RAM_BASE_ADDR
    Game_EndWaitRemote

ENDFUNCTION


#macro Game_HandleTurnResponse
    PUSH_PREV_SP
    CALL _Game_HandleTurnResponse
#endmacro



FUNCTION _Game_HandleEndGameRequest, 0

    LWI R0, STATE_GAME_END
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR
    LWI R0, 200
    STORE_OFFSET_IMM_IMM R0, globalvar_end_game_counter, RAM_BASE_ADDR
    LWI R0, 10
    STORE_OFFSET_IMM_IMM R0, globalvar_end_game_blink_counter, RAM_BASE_ADDR
    LWI R0, 10
    STORE_OFFSET_IMM_IMM R0, globalvar_end_game_blink_count, RAM_BASE_ADDR

    LWI R0, PACKET_END_GAME_RESPONSE
    STORE_OFFSET_IMM_IMM R0, NET_SEND_PACKET, NET_BASE_ADDR

    NET_SendPacket

ENDFUNCTION



#macro Game_HandleEndGameRequest
    PUSH_PREV_SP
    CALL _Game_HandleEndGameRequest
#endmacro


FUNCTION _Game_HandleEndGameResponse, 0

    LWI R0, STATE_GAME_END
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR
    LWI R0, 200
    STORE_OFFSET_IMM_IMM R0, globalvar_end_game_counter, RAM_BASE_ADDR
    LWI R0, 10
    STORE_OFFSET_IMM_IMM R0, globalvar_end_game_blink_counter, RAM_BASE_ADDR
    LWI R0, 10
    STORE_OFFSET_IMM_IMM R0, globalvar_end_game_blink_count, RAM_BASE_ADDR


    Game_EndWaitRemote

ENDFUNCTION


#macro Game_HandleEndGameResponse
    PUSH_PREV_SP
    CALL _Game_HandleEndGameResponse
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
    Game_HandleShootResponse
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_turn_request:
    // case PACKET_TURN_SWITCH_REQUEST:
    LWI R7, _Game_HandleRemoteInput_check_turn_response
    LWI R2, PACKET_TURN_SWITCH_REQUEST
    JNQ R7, R1, R2

    // HandleTurnRequest();
    Game_HandleTurnRequest
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_turn_response:
    // case PACKET_TURN_SWITCH_RESPONSE:
    LWI R7, _Game_HandleRemoteInput_check_end_game_request
    LWI R2, PACKET_TURN_SWITCH_RESPONSE
    JNQ R7, R1, R2

    // HandleTurnResponse();
    Game_HandleTurnResponse
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_end_game_request:
    // case PACKET_END_GAME_REQUEST:
    LWI R7, _Game_HandleRemoteInput_check_end_game_response
    LWI R2, PACKET_END_GAME_REQUEST
    JNQ R7, R1, R2

    // HandleEndGameRequest();
    Game_HandleEndGameRequest
    JMP _Game_HandleRemoteInput_check_loop

_Game_HandleRemoteInput_check_end_game_response:
    // case PACKET_END_GAME_RESPONSE:
    LWI R7, _Game_HandleRemoteInput_default
    LWI R2, PACKET_END_GAME_RESPONSE
    JNQ R7, R1, R2

    // HandleEndGameResponse();
    Game_HandleEndGameResponse
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
