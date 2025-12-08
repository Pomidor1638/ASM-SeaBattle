
#ifndef _STRING_ASM_
#define _STRING_ASM_

#include "../sys/sys.asm"


FUNCTION _strlen, 0

#define _strlen_localarg_str 3

    LOAD_SP R6
    LOAD_OFFSET_IMM_REG R1, _strlen_localarg_str, R6

    // R0 - length
    // R1 - str
    // R2 - word
    // R3 - char
    // R6 - 0

    LWI R7, _strlen_return
    LWI R6, 0
    MOV R0, R6

_strlen_loop:

    LWD R2, R1
    MLL R3, R6, R2
    JEZ R7, R3

    INC R0, R0

    MLH R3, R6, R2
    JEZ R7, R3
    
    INC R0, R0

    INC R1, R1

    JMP _strlen_loop


_strlen_return:
ENDFUNCTION


#macro strlen, reg_str
    PUSH_PREV_SP
    PUSH reg_str
    CALL _strlen
#endmacro

#endif