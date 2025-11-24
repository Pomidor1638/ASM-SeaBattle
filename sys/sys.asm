
#ifndef _SYS_ASM_
#define _SYS_ASM_


#include "sys_mem.asm"
#include "sys_stack.asm"
#include "sys_func.asm"

// I don't like to fuck my eyes

#macro JMP imm_addr
	LWI R7, imm_addr
	JPR R7
#endmacro

#endif