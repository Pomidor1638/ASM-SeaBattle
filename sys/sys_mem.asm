
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

#macro LOAD_OFFSET_STRUCT_IMM_IMM reg_dst, imm_struct_ptr, imm_struct_offset, imm_base
	LWI R7, imm_base
	LWI R6, imm_struct_ptr
	ADD R7, R6, R7
	LWI R6, imm_struct_offset
	ADD R7, R6, R7
	LWD reg_dst, R7
#endmacro

#macro STORE_OFFSET_STRUCT_IMM_IMM reg_src, imm_struct_ptr, imm_struct_offset, imm_base
	LWI R7, imm_base
	LWI R6, imm_struct_ptr
	ADD R7, R6, R7
	LWI R6, imm_struct_offset
	ADD R7, R6, R7
	SWD R7, reg_src
#endmacro

#macro OFFSET_STRUCT_IMM_IMM reg_dst, imm_struct_ptr, imm_struct_offset, imm_base, buf_reg
	LWI R7, imm_base
	LWI buf_reg, imm_struct_ptr
	ADD R7, buf_reg, R7
	LWI buf_reg, imm_struct_offset
	ADD R7, buf_reg, R7
	MOV reg_dst, R7
#endmacro

#macro OFFSET_STRUCT_REG_IMM reg_dst, reg_struct_ptr, imm_struct_offset
	LWI R7, imm_struct_offset
	ADD R7, reg_struct_ptr, R7
	MOV reg_dst, R7
#endmacro

#macro OFFSET_IMM_REG reg_dst, imm_offset, reg_base
	LWI R7, imm_offset
	ADD R7, reg_base, R7
	MOV reg_dst, R7
#endmacro

#macro OFFSET_IMM_IMM reg_dst, imm_offset, imm_base
	LWI R7, imm_base
	LWI R6, imm_offset
	ADD R7, R7, R6
	MOV reg_dst, R7
#endmacro

#macro ARRAY_INDEX_REG_REG reg_dst, reg_base, reg_index, imm_sizeof
	LWI R7, imm_sizeof
	MUL R7, R7, reg_index
	ADD R7, reg_base, R7
	MOV reg_dst, R7
#endmacro

#macro ARRAY_INDEX_IMM_REG reg_dst, imm_base, reg_index, imm_sizeof, buf_reg
	LWI R7, imm_sizeof
	LWI buf_reg, imm_base
	MUL R7, R7, reg_index
	ADD R7, buf_reg, R7
	MOV reg_dst, R7
#endmacro

#macro ALLOC_LOCAL_IMM imm_words
    LWI R5, imm_words
    LWI R6, SP_PTR
    LWD R7, R6
    SUB R7, R7, R5
    SWD R6, R7
#endmacro

#macro ALLOC_LOCAL_REG reg_words
    LWI R6, SP_PTR
    LWD R7, R6
    SUB R7, R7, reg_words
    SWD R6, R7
#endmacro

#endif