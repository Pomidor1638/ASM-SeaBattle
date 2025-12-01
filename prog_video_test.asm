

#include "sys/sys.asm"
#include "video/video.asm"
#include "keyboard/keyboard.asm"
#include "net/net.asm"


skebob_str:
    .string "Mega Skebob"

START:

    STACK_INIT

    LWI R1, 1
    JMP mega_loop
mega_loop:

    PUSH R1
        Input_Update_Keyboard_states
    POP R1

    PUSH R1
        Input_IsKeyJustPressed globalvar_keystate_offset_up
    POP R1

    LWI R7, check_pressed_down
    JEZ R7, R0

    INC R1, R1

    LWI R7, 0x000f
    AND R1, R1, R7

check_pressed_down:
    PUSH R1
        Input_IsKeyJustPressed globalvar_keystate_offset_down
    POP R1

    LWI R7, enter_pressed_down
    JEZ R7, R0

    DEC R1, R1

    LWI R7, 0x000f
    AND R1, R1, R7

enter_pressed_down:
    PUSH R1
        Input_IsKeyJustPressed globalvar_keystate_offset_return
    POP R1

    LWI R7, pakcet_recevied
    JEZ R7, R0

    PUSH R1
        NET_SendPacket
    POP R1

pakcet_recevied:
    
    PUSH R1
        NET_CheckPacket
    POP R1

    LWI R7, draw
    JEZ R7, R0

    PUSH R1
        NET_PopPacket
    POP R1

    INC R1, R1

    LWI R7, 0x000f
    AND R1, R1, R7

    JMP pakcet_recevied

draw:

    PUSH R1
        Video_Clear R1

        LWI R1, 5
        LWI R2, 1
        LWI R3, 0

        LWI R0, skebob_str
        Video_Print R0, R1, R1, R2, R3
        
        Video_Present
    POP R1


    JMP mega_loop





	