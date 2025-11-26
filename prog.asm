

#include "sys/sys.asm"
#include "video/video.asm"
#include "keyboard/keyboard.asm"


START:
	STACK_INIT
	JMP while_true_loop

while_true_loop:
	Input_Update_Keyboard_states
	JMP while_true_loop




	