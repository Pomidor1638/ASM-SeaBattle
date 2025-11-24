



#define globalvar_x_ptr 1
#define globalvar_y_ptr 2

#define globalvar_width  40
#define globalvar_height 30

#include "sys/sys.asm"
#include "video/video.asm"
#include "keyboard/keyboard.asm"


START:
	STACK_INIT
	JMP while_true_loop

while_true_loop:
	Input_Update_Keyboard_states
	JMP while_true_loop




	