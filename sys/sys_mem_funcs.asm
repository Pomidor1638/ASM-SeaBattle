
#ifndef _SYS_MEM_FUNCS_ASM_
#define _SYS_MEM_FUNCS_ASM_

#include "sys_func.asm"

// VERY IMPORTANT!!!!
// THIS FUNCTION USE ARGS FROM REGISTERS DIRECTLY
FUNCTION _memcpy, 0

	// R0 - src
	// R1 - size
	// R2 - dst
	LWI R7, _memcpy_return
_memcpy_copy_loop:

	JEZ R7, R1 // size == 0 ?

    // size != 0

    LWD R3, R0 // R3 <- mem[src]
    SWD R2, R3 // mem[dst] <- R3

    // mem[dst] <- mem[src]

	INC R0, R0
	INC R2, R2
	DEC R1, R1
	
    JMP _memcpy_copy_loop
_memcpy_return: // size == 0
ENDFUNCTION

#macro memcpy imm_ptr_src, imm_size, imm_ptr_dst,
    PUSH_PREV_SP

    LWI R0, imm_ptr_src
    LWI R1, imm_size
    LWI R2, imm_ptr_dst

    CALL _memcpy
#endmacro

FUNCTION _memset, 0

#define _memset_dst  3
#define _memset_data 4
#define _memset_size 5
    LOAD_SP R6
    LWI R7, _memset_dst
    ADD R7, R6, R7
    // R7 = 3 + SP
    LWD R0, R7
    INC R7, R7
    // R7 = 4 + SP
    LWD R1, R7
    INC R7, R7
    // R7 = 5 + SP
    LWD R2, R7
    
    LWI R7, _memset_return

_memset_loop:
    JEZ R7, R2
    SWD R0, R1
    DEC R2, R2
    JMP _memset_loop
_memset_return:
ENDFUNCTION

#macro memset reg_dst, reg_data, reg_size 
    PUSH_PREV_SP 
    PUSH reg_size
    PUSH reg_data
    PUSH reg_dst
    CALL _memset
#endmacro

#endif