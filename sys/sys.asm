
#ifndef _SYS_ASM_
#define _SYS_ASM_


#include "sys_mem.asm"
#include "sys_stack.asm"
#include "sys_func.asm"
#include "sys_mem_funcs.asm"

#macro SYS_INIT
    STACK_INIT
    LWI R0, RAM_BASE_ADDR
    LWI R1, 0
    LWI R2, RAM_SIZE
    LWI R3, 10
    SUB R2, R2, R3
    memset R0, R1, R2
#endmacro

#endif