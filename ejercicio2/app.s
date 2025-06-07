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
		bl piso
		
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
		
//150 , 420, 350, 180
//------------------------------------------------------------------

//ANIMACION: Parpadeo
		bl parpadeoCall

//METIORITO150//------------------------------------------------------------------

// Posición inicial del meteorito(inicializacion)
		mov x21, #150     // x actual
		mov x22, #0       // y actual
		mov x23, #-1      // dx (izquierda) lo que queremos que reste el x para moverse a la izquierda
		mov x24, #1       // dy (abajo) lo que queremos que baje 
		mov x25, #0       // contador de frames 

		bl meteoritoCall
		bl parpadeoCall
		
		
//METEORITO420//------------------------------------------------------------------
// Posición inicial del meteorito(inicializacion)
		mov x21, #420     // x actual
		mov x22, #0       // y actual
		mov x23, #-1      // dx (izquierda) lo que queremos que reste el x para moverse a la izquierda
		mov x24, #1       // dy (abajo) lo que queremos que baje 
		mov x25, #0       // contador de frames 

		bl meteoritoCall
		bl parpadeoCall

//METEORITO350//------------------------------------------------------------------
// Posición inicial del meteorito(inicializacion)
		mov x21, #350     // x actual
		mov x22, #0       // y actual
		mov x23, #-1      // dx (izquierda) lo que queremos que reste el x para moverse a la izquierda
		mov x24, #1       // dy (abajo) lo que queremos que baje 
		mov x25, #0       // contador de frames 

		bl meteoritoCall
		bl parpadeoCall

//METIORITO180//------------------------------------------------------------------
// Posición inicial del meteorito(inicializacion)
		mov x21, #180     // x actual
		mov x22, #0       // y actual
		mov x23, #-1      // dx (izquierda) lo que queremos que reste el x para moverse a la izquierda
		mov x24, #1       // dy (abajo) lo que queremos que baje 
		mov x25, #0       // contador de frames 

		bl meteoritoCall
		bl parpadeoCall

// ANIMACIÓN: Meteorito + impacto
//------------------------------------------------------------------

// Posición inicial del meteorito(inicializacion)
		mov x21, #620     // x actual
		mov x22, #0       // y actual
		mov x23, #-1      // dx (izquierda) lo que queremos que reste el x para moverse a la izquierda
		mov x24, #1       // dy (abajo) lo que queremos que baje 
		mov x25, #0       // contador de frames 


loop_meteorito:


//--------------------------------------------------------------
// 1) Borrar meteorito anterior con fondo
//--------------------------------------------------------------
		mov x15, #8 //radio
		mov x3, x21 //x
		mov x4, x22  //y
		movz x11, 0x53, lsl 16
		movk x11, 0xA6D6, lsl 0
		bl circulo

//--------------------------------------------------------------
// 2) Actualizar posición
//--------------------------------------------------------------
		add x22, x22, x24   // y++
		add x25, x25, #1
		cmp x25, #2        //si x25 < 2 → salta y no mueve x, si x25 = 2 → NO salta
		blt saltea_dx
		add x21, x21, x23   // x-- cada 2 frames
		mov x25, #0         //resetea el contador de frames
saltea_dx:

		cmp x22, #239     // compara pero no guarda resultado solo flag
		bgt explosion_obelisco  //si x22 > 239 que es donde esta la punta del obelisco entonces salta a explosion en obelisco y no sigue con dibujar meteoro

//--------------------------------------------------------------
// 3) Dibujar meteorito nuevo (rojo + naranja)
//--------------------------------------------------------------
// borde rojo
		mov x15, #8
		mov x3, x21
		mov x4, x22
		movz x11, 0xFFFF, lsl 16
		movk x11, 0x0000, lsl 0
		bl circulo

// centro naranja
		mov x15, #5
		mov x3, x21
		mov x4, x22
		movz x11, 0xFFFF, lsl 16
		movk x11, 0x8000, lsl 0
		bl circulo

//--------------------------------------------------------------
// 4) Delay
//--------------------------------------------------------------
		movz x5, 0xDFFF, lsl 0     
    		movk x5, 0x004D, lsl 16    
delay_loop:
		subs x5, x5, #1
		bne delay_loop

		b loop_meteorito

//------------------------------------------------------------------
// IMPACTO: explosion
//------------------------------------------------------------------

explosion_obelisco:
	   mov x21, #3  // radio inicial circulo rojo
	   mov x22, #0  // radio inicial circulo naranja
	   mov x3, #487
	   mov x4, #239 
loop_explosion:  
	 
// agrando radio crece explosion
		 add x21, x21, #5
		 add x22, x22, #3
		
		
// condicion para que frene la explosion cuando el circulo sea mas grande que la pantalla que se salga por el lado derecho que esta mas cerca
		
		 add x6, x3, x21     // x + r
		 cmp x6, #640
		 bge fin_explosion    // si (x + r) ≥ 640 → salir
	 
	 
//dibujo explosion 
		// borde rojo
		mov x15, x21
		mov x3, #487
		mov x4, #239
		movz x11, 0xFFFF, lsl 16
		movk x11, 0x0000, lsl 0
		bl circulo

// centro naranja
		mov x15, x22
		mov x3, #487
		mov x4, #239
		movz x11, 0xFFFF, lsl 16
		movk x11, 0x8000, lsl 0
		bl circulo
		
		
// Redibujar elementos al frente para simular perspectiva
		bl piso
		bl skyline
		bl nievepiso
		bl cartel
		bl nievepiso_cartel
		bl letras
		bl eternauta
	
		
		movz x5, 0xDFFF, lsl 0     
        movk x5, 0x012D, lsl 16      
delay_loop2:
		subs x5, x5, #1
		bne delay_loop2
		
		b loop_explosion
		
fin_explosion:

InfLoop:
			b InfLoop
