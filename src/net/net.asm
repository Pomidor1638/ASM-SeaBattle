
#ifndef _NET_ASM_
#define _NET_ASM_

#include "../sys/sys.asm"

#define NET_CTRL_CELL       0 // NET_BASE_ADDR + 0
#define NET_RECV_PACKET     1 // NET_BASE_ADDR + 1
#define NET_SEND_PACKET     9 // NET_BASE_ADDR + 9

#define NET_PACKET_TYPE_OFFSET 0

// [0000 00SP AAAA AAAA] <- target COM module's MMIO
// A - availability (it's could be just 1 bit, but anyway ...)
// S - send
// P - pull

// pop
// [0000 0001 0000 0000]

// send
// [0000 0010 0000 0000]

#macro NET_CheckPacket
    LWI R7, NET_BASE_ADDR
    LWD R0, R7
#endmacro

#macro NET_PopPacket

    LWI R7, NET_BASE_ADDR
    LWI R6, 0x0100
    LWD R5, R7
    ORR R5, R5, R6
    SWD R7, R5
    
#endmacro

#macro NET_SendPacket

    LWI R7, NET_BASE_ADDR
    LWI R6, 0x0200
    LWD R5, R7
    ORR R5, R5, R6
    SWD R7, R5
    
#endmacro


#endif
