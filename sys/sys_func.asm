
#ifndef _SYS_FUNC_ASM_
#define _SYS_FUNC_ASM_

#include "sys_stack.asm"
#include "sys_mem.asm"

// STACK FRAME

// <HIGHER ADDRESS>
//   <prev frame>
//
// . [ARGUMENTS]
// 3 [LOCAL VARS]
// 2 [PREVIOS SP]
// 1 [RETURN ADDRESS] 
// 0                 <- SP
//   <next frame>
// <LOWER ADDRESS>

// SP points on address were could PUSH
// BP it's SP - 1
#define FUNC_VARS_OFFSET 3

#macro FUNCTION _name_, _local_words_

_name_:
    
    LWI R7, RETURN_BUF_PTR
    SWD R7, R6

    ALLOC_LOCAL _local_words_

    LWI R7, PREV_SP_BUF_PTR
    LWD R5, R7
    PUSH R5

    LWI R7, RETURN_BUF_PTR
    LWD R5, R7
    PUSH R5

#endmacro

#macro RETURN

    POP R4 // RETURN ADDRESS
    POP R5 // PREVIOS SP

    LWI R3, SP_PTR
    SWD R3, R5
    JPR R4

#endmacro

#macro ENDFUNCTION
    RETURN
#endmacro

#macro CALL _func_name_
    LWI R7, _func_name_ 
    JRL R6, R7
#endmacro

#macro PUSH_PREV_SP
    LWI R7, SP_PTR
    LWD R7, R7
    LWI R6, PREV_SP_BUF_PTR
    SWD R6, R7
#endmacro

//
// For Using functions do this:
//
// EXAMPLE print(char* fmt)
//
// FUNCTION _printf, 0 <- allocate local words
//  ... do something
// ENDFUNCTION
// 
//
//
//
// #macro printf str_ptr_imm 
//      PUSH_PREV_SP // NECESSARILY !!!
//
//      //!!! PUSH ARGS TO STACK IN REVERSE ORDER (right to left) !!!
//      LWI R5, str_ptr_imm 
//      PUSH R5 // PUSHING ARG TO STACK
// 
//      CALL _printf // NECESSARILY !!!
//
// #endmacro
//
// RETURN RESULT ONLY IN R0 !!!
// Be careful with macroses, they distorts regs contents
//
//
// !!!!!!!! NEVER USE PUSH AND POP IN FUNCTION BLOCK (or use very carefull)  !!!!!!!!
// !!!!!!!! ALL FUNCTIONS DISTORTS ALL REGS                                  !!!!!!!!
// !!!!!!!! functions return's value contains only in R0                     !!!!!!!!
// !!!!!!!! DO NOT USE RETURN IN FUNC BLOCK, use _<func_name>_return instead !!!!!!!!
//

#endif