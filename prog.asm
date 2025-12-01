#include "sys/sys.asm"
#include "video/video.asm"



START:
	STACK_INIT
	LWI R1, 0
	JMP video_loop

video_loop:

	PUSH R1	
		Video_Clear R1
		Video_Present
	POP R1
	
	INC R1, R1
	LWI R7, 0xf
	AND R1, R1, R7
	JMP video_loop






