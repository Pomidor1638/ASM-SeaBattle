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
#define placement_state_t_field_offset        20
#define placement_state_t_ships_count_offset  220
#define placement_state_t_ships_offset        222
#define placement_state_t_ready_offset        252
#define placement_state_t_sizeof              253

// =============================================
// Global variables memory layout
// =============================================

// Keyboard states (9 bytes)
#define globalvar_keystates          0

// Feedback variables
#define globalvar_bg_blink_counter   9
#define globalvar_warning_counter    11

// Client only variables
#define globalvar_wait_remote        13
#define globalvar_remote_waiting_counter 14
#define globalvar_remote_waiting_attemps 16

// Game beginning variables
#define globalvar_server_ready_counter   18
#define globalvar_server_ready_attempts  20

// Cursor blinking variables
#define globalvar_cursor_blink_counter   22
#define globalvar_cursor_visible         24

// Network variables
#define globalvar_cursor_send_counter    25

// Cursor positions
#define globalvar_my_cursor_x            27
#define globalvar_my_cursor_y            29
#define globalvar_enemy_cursor_x         31
#define globalvar_enemy_cursor_y         33

// Game state variables
#define globalvar_need_switch            35
#define globalvar_my_turn                36
#define globalvar_all_ships_destroyed    37

// Program state variables
#define globalvar_running                38
#define globalvar_server_mode            39
#define globalvar_game_state             40

// Placement states
#define globalvar_my_placement_state     42
#define globalvar_enemy_placement_state  295

// Current ship placement state
#define globalvar_ship_placement_state   548

// Ship sizes and count array
#define globalvar_SHIP_SIZES_AND_COUNT   556

#endif