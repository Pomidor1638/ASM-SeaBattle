#ifndef _VIDEO_ASM_
#define _VIDEO_ASM_

#include "../sys/sys.asm"
#include "../globalvars/globalvars.asm"
#include "../string/string.asm"


FUNCTION _Video_Clear, 0

	#define _Video_Clear_localarg_clear_color 3
	
	LOAD_SP R6

	LWI R0, BUF_VRAM_BASE_ADDR	

	LOAD_OFFSET_IMM_REG R4, _Video_Clear_localarg_clear_color, R6
	MLH R4, R4, R4

	LWI R1, VRAM_SIZE
	ADD R5, R0, R1

_Video_Clear_i_loop:

	SUB R1, R0, R5 
	LWI R7, __Video_Clear_return
	JEZ R7, R1

	SWD R0, R4

	INC R0, R0

	JMP _Video_Clear_i_loop
	
__Video_Clear_return:
ENDFUNCTION

#macro Video_Clear reg_color
	PUSH_PREV_SP
	PUSH reg_color
	CALL _Video_Clear
#endmacro

FUNCTION _Video_PutChar, 0

	#define _Video_PutChar_localarg_reg_x    3
	#define _Video_PutChar_localarg_reg_y    4
	#define _Video_PutChar_localarg_reg_char 5
	#define _Video_PutChar_localarg_reg_fg   6
	#define _Video_PutChar_localarg_reg_bg   7 

	LOAD_SP R6

	LOAD_OFFSET_IMM_REG R0, _Video_PutChar_localarg_reg_x   , R6
	LOAD_OFFSET_IMM_REG R1, _Video_PutChar_localarg_reg_y   , R6
	LOAD_OFFSET_IMM_REG R2, _Video_PutChar_localarg_reg_char, R6
	LOAD_OFFSET_IMM_REG R3, _Video_PutChar_localarg_reg_fg  , R6
	LOAD_OFFSET_IMM_REG R4, _Video_PutChar_localarg_reg_bg  , R6

	LWI R7, globalvar_width
	UML R1, R1, R7
	ADD R1, R1, R0
	

	LWI R6, VRAM_SIZE
	LWI R7, _Video_PutChar_put

	JPL R7, R1, R6
	RETURN

_Video_PutChar_put:

	ADD R1, R1, R6 

	// R1 - VRAM_ADDR

	LWI R7, 0xf
	AND R3, R3, R7
	AND R4, R4, R7

	LWI R7, 12
	SLL R3, R3, R7

	LWI R7, 8
	SLL R3, R4, R7

	ADD R0, R3, R4
	ADD R0, R0, R2
	
	LWD R1, R0

_Video_PutChar_return:
ENDFUNCTION

#macro Video_PutChar reg_x, reg_y, reg_char, reg_fg, reg_bg
	PUSH_PREV_SP

	PUSH reg_bg
	PUSH reg_fg
	PUSH reg_char
	PUSH reg_y
	PUSH reg_x

	CALL _Video_PutChar
#endmacro

FUNCTION _Video_Print, 0

//
// this func is hell for debugging
//

	#define _Video_Print_localarg_str      3
	#define _Video_Print_localvar_x        4
	#define _Video_Print_localvar_y        5
	#define _Video_Print_localvar_fg_color 6
	#define _Video_Print_localvar_bg_color 7

	LOAD_SP R6 

	LOAD_OFFSET_IMM_REG R0, _Video_Print_localarg_str  , R6
	LOAD_OFFSET_IMM_REG R1, _Video_Print_localvar_x    , R6
	LOAD_OFFSET_IMM_REG R2, _Video_Print_localvar_y    , R6
	LOAD_OFFSET_IMM_REG R3, _Video_Print_localvar_bg_color, R6
	LOAD_OFFSET_IMM_REG R4, _Video_Print_localvar_fg_color, R6

	LWI R7, 0x000f 
	AND R3, R3, R7 // bg_color & 0x000f
	LWI R7, 8
	SLL R3, R3, R7 // bg_color << 8

	LWI R7, 0x000f 
	AND R4, R4, R7 // fg_color & 0x000f
	LWI R7, 12
	SLL R4, R4, R7 // fg_color << 12

	ORR R6, R3, R4 // fg_color << 12 || bg_color << 8

	// now R6 is color

	LWI R4, globalvar_width

	MUL R4, R4, R2 // START_ADDR = 40 * y
	ADD R4, R4, R1 // START_ADDR += x

	LWI R7, BUF_VRAM_BASE_ADDR
	ADD R4, R4, R7 // START_ADDR += BUF_VRAM_BASE_ADDR

	LWI R5, VRAM_SIZE
	ADD R5, R5, R7

	LWI R3, 0x0000

	// R0 - str_ptr
	// R1 
	// R2
	// R3 - even
	// R4 - START_ADDR
	// R5 - VRAM_END_ADDR + 1
	// R6 - color
	// R7 - buf or for labels


_Video_Print_print_loop:

	// check vram bounds
	SUB R1, R4, R5
	LWI R7, _Video_Print_return
	JEZ R7, R1

	// ----- payload -----

	// pulling char

	LWI R1, 0
	LWD R2, R0

	LWI R7, _Video_Print_pull_high_byte
	JNZ R7, R3 // even ? goto _Video_Print_pull_high_byte
	MLL R1, R1, R2
	JMP _Video_Print_put_char


_Video_Print_pull_high_byte:
	MLH R1, R1, R2  

_Video_Print_put_char:

	LWI R7, _Video_Print_return
	JEZ R7, R1

	LWI R7, 32
	SUB R1, R1, R7

	ADD R1, R1, R6
	SWD R4, R1

	INC R4, R4
	NOT R3, R3 // even = ~even

	LWI R7, _Video_Print_str_inc
	JEZ R7, R3
	JMP _Video_Print_print_loop
_Video_Print_str_inc:
	INC R0, R0
	JMP _Video_Print_print_loop

_Video_Print_return:
ENDFUNCTION

#macro Video_Print reg_str, reg_x, reg_y, reg_fg_color, reg_bg_color

	PUSH_PREV_SP

	PUSH reg_bg_color
	PUSH reg_fg_color
	PUSH reg_y
	PUSH reg_x
	PUSH reg_str

	CALL _Video_Print
#endmacro


FUNCTION _Video_PrintCentered, 0

#define _Video_PrintCentered_localarg_reg_str      3
#define _Video_PrintCentered_localarg_reg_y        4
#define _Video_PrintCentered_localarg_reg_fg_color 5
#define _Video_PrintCentered_localarg_reg_bg_color 6

	LOAD_SP R6
	LOAD_OFFSET_IMM_REG R0, _Video_PrintCentered_localarg_reg_str     , R6
	
	strlen R0

	LWI R7, 1
	LWI R6, globalvar_width

	SUB R0, R6, R0
	SRL R0, R0, R7

	LOAD_SP R6
	LOAD_OFFSET_IMM_REG R1, _Video_PrintCentered_localarg_reg_str     , R6
	LOAD_OFFSET_IMM_REG R2, _Video_PrintCentered_localarg_reg_y       , R6
	LOAD_OFFSET_IMM_REG R3, _Video_PrintCentered_localarg_reg_fg_color, R6
	LOAD_OFFSET_IMM_REG R4, _Video_PrintCentered_localarg_reg_bg_color, R6

	Video_Print R1, R0, R2, R3, R4

_Video_PrintCentered_return:
ENDFUNCTION

#macro Video_PrintCentered reg_str, reg_y, reg_fg_color, reg_bg_color

	PUSH_PREV_SP

	PUSH reg_bg_color
	PUSH reg_fg_color
	PUSH reg_y
	PUSH reg_str

	CALL _Video_PrintCentered
#endmacro


#macro Video_Present
	memcpy BUF_VRAM_BASE_ADDR, VRAM_SIZE, VRAM_BASE_ADDR
#endmacro

#macro Video_Init
	//PUSH_PREV_SP
	//CALL _Video_Init
#endmacro


#include "video_choosemode.asm"
#include "video_wait_for_connection.asm"
#include "video_placingships.asm"


#endif