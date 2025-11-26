#ifndef _VIDEO_ASM_
#define _VIDEO_ASM_


#include "video_impl.asm"

#macro Video_Clear reg_color
	PUSH_PREV_SP
	PUSH reg_color
	CALL _Video_Clear
#endmacro

#macro Video_Print imm_str, reg_x, reg_y, reg_fg_color, reg_bg_color

	PUSH_PREV_SP

	PUSH reg_bg_color
	PUSH reg_fg_color
	PUSH reg_y
	PUSH reg_x
	
	LWI R0, imm_str
	PUSH R0

	CALL _Video_Print
#endmacro

#macro Video_Present
	memcpy BUF_VRAM_BASE_ADDR, VRAM_SIZE, VRAM_BASE_ADDR
#endmacro

#endif