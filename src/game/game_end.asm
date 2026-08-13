#ifndef _GAME_END_ASM_
#define _GAME_END_ASM_



FUNCTION _Game_End, 0

    LOAD_OFFSET_IMM_IMM R0, globalvar_end_game_counter, RAM_BASE_ADDR
    LWI R7, _Game_End_draw_end
    JNZ R7, R0

    Input_IsKeyJustPressed globalvar_keystate_offset_return
    LWI R7, _Game_End_draw_end
    JEZ R7, R0

    LWI R0, STATE_CHOOSE_MODE
    STORE_OFFSET_IMM_IMM R0, globalvar_game_state, RAM_BASE_ADDR
    Game_Init


_Game_End_draw_end:

    Video_GameEnd

ENDFUNCTION

#macro Game_End
    PUSH_PREV_SP
    CALL _Game_End
#endmacro


#endif
