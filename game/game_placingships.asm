#ifndef _GAME_PLACINGSHIPS_
#define _GAME_PLACINGSHIPS_

FUNCTION _Game_PlacingShips, 0

    HandleCursorMovement

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
    Video_Present

ENDFUNCTION

#macro Game_PlacingShips
    PUSH_PREV_SP
    CALL _Game_PlacingShips
#endmacro

#endif