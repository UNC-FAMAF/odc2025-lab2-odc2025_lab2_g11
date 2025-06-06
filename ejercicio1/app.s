.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,   	32
.equ COLOR_WHITE,   	0xFFFFFFFF
.include "formas.s"	
.globl main

main:

// x0 contiene la direccion base del framebuffer
 		mov x20, x0	// Guarda la dirección base del framebuffer en x20

//---------------- CODE HERE ------------------------------------
//-----FONDO
		movz x10, 0x53, lsl 16
		movk x10, 0xA6D6, lsl 00

		mov x2, SCREEN_HEIGH    // Y Size
loopF2:
		mov x1, SCREEN_WIDTH    // X Size
loopF1:
		stur w10,[x0]  	    	// Colorear el pixel N
		add x0,x0,4	    		// Siguiente pixel
		sub x1,x1,1	    		// Decrementar contador X
		cbnz x1,loopF1      	// Si no terminó la fila, salto
		sub x2,x2,1	    		// Decrementar contador Y
		cbnz x2,loopF2      	// Si no es la última fila, salto

//-----PISO color: 0xAADAD9
//P(0,376) 640x103 

		mov x1, 640		// x1 -> ancho del rectangulo
		mov x2, 103		// x2 -> alto del rectangulo
		mov x3, 0		// x3 -> x
		mov x4, 376		// x4 -> y
		movz x11, 0xAA, lsl 16	// x11-> color
		movk x11, 0xDAD9, lsl 00
		
		bl rectangulo
		
//----- OBELISCO
		bl obelisco

//-----Skyline
		bl skyline

//-------nieve piso
		bl nievepiso
		
// CARTEL
		bl cartel
		
// NIEVEPISO CARTEL	
		bl nievepiso_cartel

// LETRAS
		bl letras

//------ETERNAUTA
		bl eternauta
		
//-----NIEVE color 0xFFFFFF
		bl nievecopos

InfLoop:
		b InfLoop
