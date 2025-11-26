
#ifndef _SYS_MEM_ASM_
#define _SYS_MEM_ASM_

#define ROM_BASE_ADDR 0
#define ROM_SIZE 32768

#define RAM_BASE_ADDR 32768
#define RAM_SIZE 30348

#define VRAM_BASE_ADDR 63116
#define VRAM_SIZE 1200

#define BUF_VRAM_BASE_ADDR 64316

#define NET_BASE_ADDR 65516
#define NET_SIZE 17

#define KEYBOARD_BASE_ADDR 65533
#define KEYBOARD_SIZE 1

#define SEVEN_SEG_BASE_ADDR 65534
#define SEVEN_SEG_SIZE 2

// This macroses distort R7 and R6 regs,
// !!! NEVER USE R7 or R6 as reg_dst or reg_src !!!

#macro LOAD_OFFSET_IMM_IMM reg_dst, imm_offset, imm_base
	LWI R7, imm_base
	LWI R6, imm_offset
	ADD R7, R7, R6
	LWD reg_dst, R7
#endmacro

#macro STORE_OFFSET_IMM_IMM reg_src, imm_offset, imm_base
	LWI R7, imm_base
	LWI R6, imm_offset
	ADD R7, R7, R6
	SWD R7, reg_src
#endmacro

#macro LOAD_OFFSET_IMM_REG reg_dst, imm_offset, reg_base
	LWI R7, imm_offset
	ADD R7, reg_base, R7
	LWD reg_dst, R7
#endmacro

#macro STORE_OFFSET_IMM_REG reg_src, imm_offset, reg_base
	LWI R7, imm_offset
	ADD R7, reg_base, R7
	SWD R7, reg_src
#endmacro

// IMM
#macro ALLOC_LOCAL words
    LWI R5, words
    LWI R6, SP_PTR
    LWD R7, R6
    SUB R7, R7, R5
    SWD R6, R7
#endmacro




#endif