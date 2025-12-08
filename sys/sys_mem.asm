
#ifndef _SYS_MEM_ASM_
#define _SYS_MEM_ASM_

#define ROM_BASE_ADDR 0
#define ROM_SIZE 32768

#define RAM_BASE_ADDR 32768
#define RAM_SIZE 30348

#define TIMER_BASE_ADDR 63114
#define TIMER_SIZE 2

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
// !!! NEVER USE R7 in args !!!

// don't use R6
#macro LOAD_OFFSET_IMM_IMM reg_dst, imm_offset, imm_base
	LWI R7, imm_base
	LWI R6, imm_offset
	ADD R7, R7, R6
	LWD reg_dst, R7
#endmacro

// don't use R6
#macro STORE_OFFSET_IMM_IMM reg_src, imm_offset, imm_base
	LWI R7, imm_base
	LWI R6, imm_offset
	ADD R7, R7, R6
	SWD R7, reg_src
#endmacro

#macro LOAD_OFFSET_REG_IMM reg_dst, reg_offset, imm_base
	LWI R7, imm_base
	ADD R7, R7, reg_offset
	LWD reg_dst, R7
#endmacro

#macro STORE_OFFSET_REG_IMM reg_src, reg_offset, imm_base
	LWI R7, imm_base
	ADD R7, R7, reg_offset
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

#macro LOAD_OFFSET_REG_REG reg_dst, reg_offset, reg_base
	ADD R7, reg_base, reg_offset
	LWD reg_dst, R7
#endmacro

#macro STORE_OFFSET_REG_REG reg_src, reg_offset, reg_base
	ADD R7, reg_base, reg_offset
	SWD R7, reg_src
#endmacro

// IMM
#macro ALLOC_LOCAL_IMM words
    LWI R5, words
    LWI R6, SP_PTR
    LWD R7, R6
    SUB R7, R7, R5
    SWD R6, R7
#endmacro
// REG
#macro ALLOC_LOCAL_REG reg
    LWI R6, SP_PTR
    LWD R7, R6
    SUB R7, R7, reg
    SWD R6, R7
#endmacro

#endif