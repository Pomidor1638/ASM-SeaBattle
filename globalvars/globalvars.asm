#ifndef _GLOBALVARS_ASM_
#define _GLOBALVARS_ASM_

// =============================================
// Keyboard state variables
// =============================================
#define globalvar_keystates_base_ptr        0
#define globalvar_keystates_size            9

#define globalvar_keystate_offset_up        0
#define globalvar_keystate_offset_left      1
#define globalvar_keystate_offset_down      2
#define globalvar_keystate_offset_right     3
#define globalvar_keystate_offset_q         4
#define globalvar_keystate_offset_e         5
#define globalvar_keystate_offset_r         6
#define globalvar_keystate_offset_return    7
#define globalvar_keystate_offset_escape    8

// =============================================
// Video constants
// =============================================
#define globalvar_width  40
#define globalvar_height 30

// =============================================
// Game constants
// =============================================
#define FIELD_SIZE 10
#define MAX_SHIPS  10
#define MAX_SHIPS_SIZE 4

// symbol consts
#define WATER_SYMBOL               0
#define WATER_FRONT_COLOR          0
#define WATER_BACK_COLOR          10
#define SHIP_SYMBOL                3
#define SHIP_FRONT_COLOR          15
#define DITHER_LEVEL1            112
#define MISS_FRONT_COLOR          15
#define HIT_SYMBOL                54
#define HIT_FRONT_COLOR            1
#define SUNK_SYMBOL              114
#define SHIP_PLACING_FRONT_COLOR   1
#define SHIP_BACK_COLOR           10
 
// Cell states
#define CELL_EMPTY     0
#define CELL_SHIP      1
#define CELL_MISS      2
#define CELL_HIT       3
#define CELL_SUNK      4
#define CELL_DONT_SHOT 5

// Game states
#define STATE_INIT                  0   
#define STATE_CHOOSE_MODE           1
#define STATE_WAIT_FOR_CONNECTION   2
#define STATE_PLACING_SHIPS         3
#define STATE_WAITING_REMOTE_READY  4
#define STATE_ERROR                 5
#define STATE_MAIN_GAME             6
#define STATE_GAME_OVER             7
#define STATE_VIDEO_TEST            8
#define STATE_GAME_END              9
#define STATE_QUIT                  10


#define PACKET_CONNECTION_REQUEST    0
#define PACKET_CONNECTION_ACCEPTED   1
#define PACKET_READY_REQUEST         2
#define PACKET_READY_RESPONSE        3
#define PACKET_START_GAME_REQUEST    4
#define PACKET_START_GAME_RESPONSE   5
#define PACKET_END_GAME_REQUEST      6
#define PACKET_END_GAME_RESPONSE     7
#define PACKET_SHIP_PLACE_REQUEST    8
#define PACKET_SHIP_PLACE_RESPONSE   9
#define PACKET_SHIP_REMOVE_REQUEST  10
#define PACKET_SHIP_REMOVE_RESPONSE 11
#define PACKET_TURN_SWITCH_REQUEST  12
#define PACKET_TURN_SWITCH_RESPONSE 13
#define PACKET_HEARTBEAT_REQUEST    14
#define PACKET_HEARTBEAT_RESPONSE   15
#define PACKET_CURSOR_POS           16
#define PACKET_SHOOT_REQUEST        17
#define PACKET_SHOOT_RESPONSE       18
#define PACKET_REMOTE_ERROR         19

// =============================================
// Structure definitions with offsets
// =============================================

// fieldcell_t structure (2 bytes)
#define fieldcell_t_state_offset      0
#define fieldcell_t_ship_index_offset 1
#define fieldcell_t_sizeof            2

// ship_t structure (packed, 3 bytes)
#define ship_t_x_offset              0
#define ship_t_y_offset              1
#define ship_t_size_offset           2
#define ship_t_hits_offset           3
#define ship_t_horizontal_offset     4
#define ship_t_sizeof                5

// ship_placement_t structure (4 bytes)
#define ship_placement_t_size_offset  0
#define ship_placement_t_count_offset 1
#define ship_placement_t_sizeof       2

// cur_ship_state_t structure (8 bytes)
#define cur_ship_state_t_x_offset               0
#define cur_ship_state_t_y_offset               1
#define cur_ship_state_t_ship_size_index_offset 2
#define cur_ship_state_t_horizontal_offset      3
#define cur_ship_state_t_sizeof                 4

// placement_state_t structure
#define placement_state_t_placed_ships_offset 0
#define placement_state_t_field_offset        4
#define placement_state_t_ships_count_offset  204
#define placement_state_t_ships_offset        205
#define placement_state_t_ready_offset        255
#define placement_state_t_sizeof              256

// =============================================
// Global variables memory layout
// =============================================

// Keyboard states (9 bytes)
#define globalvar_keystates               0

// Feedback variables
#define globalvar_bg_blink_counter        9
#define globalvar_warning_counter        10

// Cursor blinking variables
#define globalvar_cursor_blink_counter   11
#define globalvar_cursor_visible         12

#define globalvar_wait_remote            13
#define globalvar_remote_waiting_counter 14
#define globalvar_remote_waiting_attemps 15
#define globalvar_cursor_send_counter    16

#define globalvar_dot_counter            17
#define globalvar_dots_count             18

#define globalvar_last_time_ptr          19 // sizeof == 2

#define globalvar_server_mode            21
#define globalvar_game_state             22

#define globalvar_my_placement_state     23  // sizeof  == 256
#define globalvar_enemy_placement_state  279 // sizeof == 256

#define globalvar_my_cursor_x 280
#define globalvar_my_cursor_y 281

#define globalvar_enemy_cursor_x 282
#define globalvar_enemy_cursor_y 283

#define globalvar_ship_placement_state 284 // sizeof == 4

globalvar_SHIP_SIZES_AND_COUNT:
    .data32 4, 1
    .data32 3, 2
    .data32 2, 3
    .data32 1, 4

#endif