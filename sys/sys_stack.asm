
#ifndef _SYS_STACK_ASM_
#define _SYS_STACK_ASM_

#define RETURN_BUF_PTR  63113
#define PREV_SP_BUF_PTR 63112
#define SP_PTR          63111
#define STACK_START     63110

#macro STACK_INIT
	LWI R7, STACK_START
	LWI R6, SP_PTR
	SWD R6, R7
#endmacro

#macro PUSH reg 
	
	LWI R6, SP_PTR // R7 <- SP_PTR
	LWD R7, R6 // (SP) R7 <- mem[SP_PTR] 
	SWD R7, reg // mem[SP] <- reg

	DEC R7, R7 // SP--
	SWD R6, R7     // mem[SP_PTR] <- SP

#endmacro

#macro POP reg

	LWI R6, SP_PTR // R7 <- SP_PTR
	LWD R7, R6 // (SP) R7 <- mem[SP_PTR] 
	INC R7, R7 // SP++

	LWD reg, R7 // reg <- mem[SP]
	SWD R6, R7     // mem[SP_PTR] <- SP

#endmacro

// this can use all regs
#macro LOAD_SP reg_src
	LWI R7, SP_PTR
	LWD reg_src, R7
#endmacro

#endif