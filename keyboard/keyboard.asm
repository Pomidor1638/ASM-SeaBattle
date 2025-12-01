
#ifndef _KEYBOARD_ASM_
#define _KEYBOARD_ASM_

#include "../globalvars/globalvars.asm"


#define KEYBOARD_SCANCODE_MASK 0x01FF
#define KEYBOARD_PRESSED_MASK  0x0200

#define SCANCODE_UP     0x0175
#define SCANCODE_RIGHT  0x0174
#define SCANCODE_DOWN   0x0172
#define SCANCODE_LEFT   0x016B

#define SCANCODE_Q      0x0015
#define SCANCODE_E      0x0024
#define SCANCODE_R      0x002D
#define SCANCODE_RETURN 0x005A
#define SCANCODE_ESCAPE 0x0076

FUNCTION _Input_Update_Keyboard_states, 0

// update prev states

    LWI R6, globalvar_keystates_base_ptr
    LWI R7, RAM_BASE_ADDR
    ADD R6, R6, R7
    LWI R0, 0

_Input_Update_Keyboard_states_prev_sates_update_loop:

    LWI R1, globalvar_keystates_size
    //SUB R1, R0, R7 // i - size
    LWI R7, _Input_Update_Keyboard_states_payload_loop
    JEQ R7, R0, R1 // i == size ?

    ADD R1, R0, R6

    LWD R2, R1
    MLL R2, R2, R2
    SWD R1, R2

    INC R0, R0
    JMP _Input_Update_Keyboard_states_prev_sates_update_loop

_Input_Update_Keyboard_states_payload_loop:

    LWI R0, KEYBOARD_BASE_ADDR
    LWD R0, R0

    
    LWI R7, _Input_Update_Keyboard_states_return
    JEZ R7, R0 

    LWI R1, KEYBOARD_SCANCODE_MASK
    AND R1, R1, R0
    
// R1 - scancode only
// scancode_up

// case SCANCODE_Q:
    // sc == SCANCODE_Q ?
    LWI R2, SCANCODE_Q
    LWI R7, _Input_Update_Keyboard_states_CASE_SCANCODE_E
    JNQ R7, R1, R2 // sc != SCANCODE_Q  ? -> JMP _Input_Update_Keyboard_states_CASE_SCANCODE_E
    // sc == SCANCODE_Q
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_q
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop


_Input_Update_Keyboard_states_CASE_SCANCODE_E:
    // sc == SCANCODE_E ?
    LWI R2, SCANCODE_E
    SUB R2, R1, R2
    LWI R7, _Input_Update_Keyboard_states_CASE_SCANCODE_R 
    JNZ R7, R2 // sc != SCANCODE_E  ? -> JMP _Input_Update_Keyboard_states_CASE_SCANCODE_R
    // sc == SCANCODE_E
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_e
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop

_Input_Update_Keyboard_states_CASE_SCANCODE_R:
    // sc == SCANCODE_R ?
    LWI R2, SCANCODE_R
    SUB R2, R1, R2
    LWI R7, _Input_Update_Keyboard_states_CASE_SCANCODE_RETURN // for now shut this
    JNZ R7, R2 // sc != SCANCODE_R  ? -> JMP _Input_Update_Keyboard_states_CASE_SCANCODE_ESCAPE
    // sc == SCANCODE_R
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_r
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop

_Input_Update_Keyboard_states_CASE_SCANCODE_RETURN:
    // sc == SCANCODE_RETURN ?
    LWI R2, SCANCODE_RETURN
    LWI R7, _Input_Update_Keyboard_states_CASE_SCANCODE_ESCAPE // for now shut this
    JNQ R7, R1, R2 // sc != SCANCODE_RETURN  ? -> JMP _Input_Update_Keyboard_states_CASE_SCANCODE_ESCAPE
    // sc == SCANCODE_RETURN
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_return
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop

_Input_Update_Keyboard_states_CASE_SCANCODE_ESCAPE:
    // sc == SCANCODE_ESCAPE ?
    LWI R2, SCANCODE_ESCAPE
    LWI R7, _Input_Update_Keyboard_states_CASE_SCANCODE_UP // for now shut this
    JNQ R7, R1, R2 // sc != SCANCODE_ESCAPE  ? -> JMP _Input_Update_Keyboard_states_CASE_SCANCODE_UP
    // sc == SCANCODE_ESCAPE
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_escape
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop

_Input_Update_Keyboard_states_CASE_SCANCODE_UP:
    // sc == SCANCODE_UP ?
    LWI R2, SCANCODE_UP
    LWI R7, _Input_Update_Keyboard_states_CASE_SCANCODE_LEFT // for now shut this
    JNQ R7, R2, R1 // sc != SCANCODE_UP  ? -> JMP _Input_Update_Keyboard_states_CASE_SCANCODE_LEFT
    // sc == SCANCODE_UP
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_up
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop

_Input_Update_Keyboard_states_CASE_SCANCODE_LEFT:
    // sc == SCANCODE_LEFT ?
    LWI R2, SCANCODE_LEFT
    LWI R7, _Input_Update_Keyboard_states_CASE_SCANCODE_DOWN // for now shut this
    JNQ R7, R1, R2 // sc != SCANCODE_LEFT  ? -> JMP _Input_Update_Keyboard_states_CASE_SCANCODE_DOWN
    // sc == SCANCODE_LEFT
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_left
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop

_Input_Update_Keyboard_states_CASE_SCANCODE_DOWN:
    // sc == SCANCODE_DOWN ?
    LWI R2, SCANCODE_DOWN
    LWI R7, _Input_Update_Keyboard_states_CASE_SCANCODE_RIGHT // for now shut this
    JNQ R7, R1, R2 // sc != SCANCODE_DOWN  ? -> JMP _Input_Update_Keyboard_states_CASE_SCANCODE_RIGHT
    // sc == SCANCODE_DOWN
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_down
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop

_Input_Update_Keyboard_states_CASE_SCANCODE_RIGHT:
    // sc == SCANCODE_RIGHT ?
    LWI R2, SCANCODE_RIGHT
    LWI R7, _Input_Update_Keyboard_states_payload_loop // for now shut this
    JNQ R7, R1, R2 // sc != SCANCODE_RIGHT  ? -> JMP _Input_Update_Keyboard_states_payload_loop
    // sc == SCANCODE_RIGHT
    
    LWI R7, RAM_BASE_ADDR
    LWI R3, globalvar_keystate_offset_right
    ADD R3, R3, R7
    // R1 - pressed flag
    LWI R1, KEYBOARD_PRESSED_MASK
    AND R1, R1, R0

    LWD R2, R3
    MHH R2, R2, R1 
    SWD R3, R2

    JMP _Input_Update_Keyboard_states_payload_loop


_Input_Update_Keyboard_states_return:
ENDFUNCTION

#macro Input_Update_Keyboard_states
	PUSH_PREV_SP
	CALL _Input_Update_Keyboard_states
#endmacro

// !!! This distorts all regs !!!
// R0 - result - cur
#macro Input_IsKeyPressed imm_key_num

    LWI R7, imm_key_num
    LWI R6, RAM_BASE_ADDR
    ADD R7, R6, R7

    LWD R1, R7

    LWI R0, 0
    
    MLL R0, R0, R1 // R0 - cur

#endmacro

// !!! This distorts all regs !!!
// R0 - result - !last && cur
#macro Input_IsKeyJustPressed imm_key_num

    LWI R7, imm_key_num
    LWI R6, RAM_BASE_ADDR
    ADD R7, R6, R7

    LWD R2, R7

    LWI R0, 0
    
    MLL R1, R0, R2 // cur
    MLH R2, R0, R2 // last

    NOT R2, R2

    AND R0, R2, R1 // !last && cur

#endmacro



#endif