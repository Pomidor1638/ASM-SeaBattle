#include "sys/sys.asm"
#include "video/video.asm"
#include "net/net.asm"
#include "keyboard/keyboard.asm"


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

    LWI R7, 0xf
    AND R1, R1, R7

check_pressed_down:

    PUSH R1
    Input_IsKeyJustPressed globalvar_keystate_offset_down
    POP R1

    LWI R7, check_pressed_return
    JEZ R7, R0

    DEC R1, R1

    LWI R7, 0xf
    AND R1, R1, R7



check_pressed_return:

    PUSH R1
    Input_IsKeyJustPressed globalvar_keystate_offset_return
    POP R1

    LWI R7, check_recv
    JEZ R7, R0

    PUSH R1
    STORE_OFFSET_IMM_IMM R1, NET_SEND_PACKET, NET_BASE_ADDR
    NET_SendPacket
    POP R1

check_recv:


    PUSH R1
    NET_CheckPacket
    POP R1

    LWI R7, draw
    JEZ R7, R0

    NET_PopPacket
    LOAD_OFFSET_IMM_IMM R1, NET_RECV_PACKET, NET_BASE_ADDR

    LWI R7, 0xf
    AND R1, R1, R7

    JMP check_recv

draw:

    PUSH R1
    Video_Clear R1
    Video_Present
    POP R1

    JMP mega_loop





