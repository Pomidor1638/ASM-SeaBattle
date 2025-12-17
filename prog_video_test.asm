

#include "game/game.asm"


START:
    SYS_INIT
    Game_Init
    JMP forever_loop

forever_loop:
    Game_Tick
    JMP forever_loop



	