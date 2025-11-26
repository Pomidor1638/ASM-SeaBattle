



#define globalvar_x_ptr 1
#define globalvar_y_ptr 2

#define globalvar_width  40
#define globalvar_height 30

#include "sys/sys.asm"
#include "video/video.asm"
#include "keyboard/keyboard.asm"


skebob_str:
    .string "Skebob"

START:

	STACK_INIT
    
    LWI R1, 2

	JMP video_clear_loop

video_clear_loop:
    
    PUSH R1

    Input_Update_Keyboard_states
    
    POP R1
    
    

    PUSH R1

    Video_Clear R1

    POP R1

    PUSH R1
    
    LWI R0, 4
    LWI R0, 4
    LWI R1, 1
    LWI R2, 2

    Video_Print skebob_str, R0, R0, R1, R2

    Video_Present

    POP R1

    

    PUSH R1
        Input_IsKeyJustPressed globalvar_keystate_offset_up
    POP R1

    LWI R7, key_pressed_down
    JEZ R7, R0

    INC R1, R1
    LWI R7, 0x000f
    AND R1, R1, R7

key_pressed_down:

    PUSH R1
    Input_IsKeyJustPressed globalvar_keystate_offset_down
    POP R1

    LWI R7, video_clear_loop
    JEZ R7, R0

    DEC R1, R1
    LWI R7, 0x000f
    AND R1, R1, R7

    JMP video_clear_loop






	