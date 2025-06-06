	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,   32
  .equ COLOR_WHITE,   	0xFFFFFFFF
	.include "formasBasicas.s"	

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
// FONDO
	movz x10, 0x53, lsl 16
	movk x10, 0xA6D6, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
loopF2:
	mov x1, SCREEN_WIDTH         // X Size
loopF1:
	stur w10,[x0]  	    // Colorear el pixel N
	add x0,x0,4	    // Siguiente pixel
	sub x1,x1,1	    // Decrementar contador X
	cbnz x1,loopF1      // Si no terminó la fila, salto
	sub x2,x2,1	    // Decrementar contador Y
	cbnz x2,loopF2      // Si no es la última fila, salto
 
// --------- OBELISCO
    	//Punta obelisco
    	mov x3, #487       // centro X
    	mov x4, #239       // centro Y
    	mov x15, #15        // ancho base
    	mov x16, #15      //altura
    	mov w11, #COLOR_WHITE
    	bl triangulo


    //cuerpo obelisco
 	mov x1, 15
	mov x2, 130
	mov x3, 480
	mov x4, 247
	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

    //ventana oblisco
    	mov x1, 2
	mov x2, 2
	mov x3, 487
	mov x4, 244
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

//PISO color: 0xAADAD9
// // P(0,376) 640x103 

	mov x1, 640		// x1 -> ancho del rectangulo
	mov x2, 103		// x2 -> alto del rectangulo
	mov x3, 0		// x3 -> x
	mov x4, 376		// x4 -> y
	movz x11, 0xAA, lsl 16	// x11-> color
	movk x11, 0xDAD9, lsl 00
	
	bl rectangulo
 
    //skyline
    
	mov x1, 40
	mov x2, 250
	mov x3, 20
	mov x4, 127
    	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

	mov x1, 50
	mov x2, 100
	mov x3, 120
	mov x4, 277
    	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

	mov x1, 40
	mov x2, 160
	mov x3, 170
	mov x4, 217
    	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

	mov x1, 50
	mov x2, 200
	mov x3, 350
	mov x4, 177
    	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

	mov x1, 46
	mov x2, 200
	mov x3, 352
	mov x4, 174
    	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

	mov x1, 40
	mov x2, 200
	mov x3, 355
	mov x4, 168
    	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

	mov x1, 30
	mov x2, 200
	mov x3, 360
	mov x4, 163
    	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

	mov x1, 60
	mov x2, 180
	mov x3, 550
	mov x4, 197
    	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

	mov x1, 50
	mov x2, 160
	mov x3, 540
	mov x4, 217
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 50
	mov x2, 5
	mov x3, 540
	mov x4, 217
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 30
	mov x2, 2
	mov x3, 540
	mov x4, 230
	mov x11, #COLOR_WHITE
	bl rectangulo

    	mov x1, 10
	mov x2, 1
	mov x3, 540
	mov x4, 250
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 40
	mov x2, 100
	mov x3, 20
	mov x4, 277
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 40
	mov x2, 10
	mov x3, 20
	mov x4, 277
	mov x11, #COLOR_WHITE
	bl rectangulo


	mov x1, 30   
	mov x2, 150
	mov x3, 0 
	mov x4, 227
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo


	mov x1, 45
	mov x2, 200
	mov x3, 50
	mov x4, 177
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x3, #72
	mov x4, #173
	mov x15, #22
	mov x11, #COLOR_WHITE   
	bl circulo

	mov x3, #72
	mov x4, #175
	mov x15, #22
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0     
	bl circulo


	mov x1, 35
	mov x2, 130
	mov x3, 70
	mov x4, 247
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 35
	mov x2, 2
	mov x3, 70
	mov x4, 247
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 40
	mov x2, 70
	mov x3, 100
	mov x4, 307
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 40
	mov x2, 1
	mov x3, 100
	mov x4, 307
	mov x11, #COLOR_WHITE
	bl rectangulo
   
	mov x1, 30
	mov x2, 60
	mov x3, 150
	mov x4, 317
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 30
	mov x2, 2
	mov x3, 150
	mov x4, 317
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 40
	mov x2, 230
	mov x3, 160
	mov x4, 147
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo



	mov x1, 40
	mov x2, 3
	mov x3, 160
	mov x4, 147
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 15
	mov x2, 1
	mov x3, 163
	mov x4, 170
	mov x11, #COLOR_WHITE
	bl rectangulo

    	mov x1, 15
	mov x2, 1
	mov x3, 165
	mov x4, 190
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 50
	mov x2, 100
	mov x3, 180
	mov x4, 277
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 50
	mov x2, 2
	mov x3, 180
	mov x4, 277
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 50
	mov x2, 100
	mov x3, 320
	mov x4, 277
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 50
	mov x2, 2
	mov x3, 320
	mov x4, 277
	mov x11, #COLOR_WHITE
	bl rectangulo



	mov x1, 60
	mov x2, 300
	mov x3, 270
	mov x4, 77
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo


	mov x1, 60
	mov x2, 2
	mov x3, 270
	mov x4, 77
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 30
	mov x2, 1
	mov x3, 270
	mov x4, 100
	mov x11, #COLOR_WHITE
	bl rectangulo

	mov x1, 20
	mov x2, 1
	mov x3, 300
	mov x4, 85
	mov x11, #COLOR_WHITE
	bl rectangulo


	mov x1, 50
	mov x2, 100
	mov x3, 400
	mov x4, 277
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 50
	mov x2, 100
	mov x3, 530
	mov x4, 277
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo

	mov x1, 40
	mov x2, 250
	mov x3, 600
	mov x4, 127
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0
	bl rectangulo


	mov x1, 2
	mov x2, 4
	mov x3, 130
	mov x4, 320
    	movz x11, 0xFF00         
    	movk x11, 0xFFFF, lsl 16 
	bl rectangulo

	mov x1, 2
	mov x2, 4
	mov x3, 30
	mov x4, 330
    	movz x11, 0xFF00         
    	movk x11, 0xFFFF, lsl 16 
	bl rectangulo


	mov x1, 2
	mov x2, 4
	mov x3, 90
	mov x4, 270
        movz x11, 0xFF00         
    	movk x11, 0xFFFF, lsl 16 
	bl rectangulo

//-------nieve piso

    mov x3, #114       // centro X
    mov x4, #455       // centro Y
    mov x15, #50        // ancho base
    mov x16, #10      //altura
    mov w11, #COLOR_WHITE
    bl triangulo

    mov x3, #46       // centro X
    mov x4, #455       // centro Y
    mov x15, #50        // ancho base
    mov x16, #10      //altura
    mov w11, #COLOR_WHITE
    bl triangulo

    mov x3, #350       // centro X
    mov x4, #400       // centro Y
    mov x15, #300        // ancho base
    mov x16, #20      //altura
    mov w11, #COLOR_WHITE
    bl triangulo

    mov x3, #100       // centro X
    mov x4, #370       // centro Y
    mov x15, #300        // ancho base
    mov x16, #20      //altura
    mov w11, #COLOR_WHITE
    bl triangulo

    mov x3, #560       // centro X
    mov x4, #373       // centro Y
    mov x15, #130        // ancho base
    mov x16, #10      //altura
    mov w11, #COLOR_WHITE
    bl triangulo

    mov x3, #490       // centro X
    mov x4, #450       // centro Y
    mov x15, #300        // ancho base
    mov x16, #20      //altura
    mov w11, #COLOR_WHITE
    bl triangulo

	
//cartel

	mov x1, 3
	mov x2, 100
	mov x3, 46
	mov x4, 360
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0 
	bl rectangulo

	mov x1, 3
	mov x2, 100
	mov x3, 112
	mov x4, 360
	movz x11, 0x64, lsl 16
	movk x11, 0x6464, lsl 0 
	bl rectangulo

	mov x1, 100
	mov x2, 50
	mov x3, 30
	mov x4, 350
    movz x11, 0x8440         // Green=0x84 (132), Blue=0x40 (64)  
    movk x11, 0xFF00, lsl 16 // Alpha=0xFF, Red=0x00
	bl rectangulo

	mov x1, 96
	mov x2, 46
	mov x3, 32
	mov x4, 352
    mov x11, #COLOR_WHITE      
	bl rectangulo

	mov x1, 94
	mov x2, 44
	mov x3, 33
	mov x4, 353
    movz x11, 0x8440         // Green=0x84 (132), Blue=0x40 (64)  
    movk x11, 0xFF00, lsl 16 // Alpha=0xFF, Red=0x00    
	bl rectangulo
	
	
// LETRAS
	bl letras
	

	

//--------CUERPO color: 0x6C421F -------//
// //--------------------------------------- C0 (160,434) 195x45 

	mov x1, 195		// x1 -> ancho del rectangulo
	mov x2, 45		// x2 -> alto del rectangulo
	mov x3, 160		// x3 -> x
	mov x4, 434		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 0x421F, lsl 00 
	
	bl rectangulo
	
	

// //--------------------------------------- C1 (170,396) 185x83 
        mov x1, 185		// x1 -> ancho del rectangulo
	mov x2, 83		// x2 -> alto del rectangulo
	mov x3, 170		// x3 -> x
	mov x4, 396		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 0x421F, lsl 00 
	
	bl rectangulo

	
	
// //--------------------------------------- C2 (179,366) 176x113 

        mov x1, 176		// x1 -> ancho del rectangulo
	mov x2, 113		// x2 -> alto del rectangulo
	mov x3, 179		// x3 -> x
	mov x4, 366		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 0x421F, lsl 00 
	
	bl rectangulo
	

// //--------------------------------------- C3 (189,347) 166x132 

        mov x1, 166		// x1 -> ancho del rectangulo
	mov x2, 132		// x2 -> alto del rectangulo
	mov x3, 189		// x3 -> x
	mov x4, 347		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 0x421F, lsl 00 
	
	bl rectangulo

	
	
// //--------------------------------------- C4 (199,337) 156x142 

        mov x1, 156		// x1 -> ancho del rectangulo
	mov x2, 142		// x2 -> alto del rectangulo
	mov x3, 199		// x3 -> x
	mov x4, 337		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 0x421F, lsl 00 
	
	bl rectangulo
	
// //--------------------------------------- C5 (209,298) 146x181 
        mov x1, 146		// x1 -> ancho del rectangulo
	mov x2, 181		// x2 -> alto del rectangulo
	mov x3, 209		// x3 -> x
	mov x4, 298		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 0x421F, lsl 00 
	
	bl rectangulo

	
// -------- CAPUCHA color: 0x5093BA
// //--------------------------------------- CP0 (238,221) 145x77

	mov x1, 145 // x1 -> ancho del rectangulo
	mov x2, 77 // x2 -> alto del rectangulo
	mov x3, 238 // x3 -> x // x11-> color
	mov x4, 221 // x4 -> y // x11-> color
	
	movz x11, 0x50, lsl 16
	movk x11, 0x93BA, lsl 0
	bl rectangulo

// //--------------------------------------- CP1 (247,201) 126x36

	mov x1, 126 // x1 -> ancho del rectangulo
	mov x2, 36 // x2 -> alto del rectangulo
 	mov x3, 247 // x3 -> x
	mov x4, 201 // x4 -> y
	
	movz x11, 0x50, lsl 16 // x11-> color
	movk x11, 0x93BA, lsl 0 // x11-> color
	
	bl rectangulo

// //--------------------------------------- CP2 (257,191) 108x17

	mov x1, 108 // x1 -> ancho del rectangulo
	mov x2, 17 // x2 -> alto del rectangulo
	mov x3, 257 // x3 -> x
	mov x4, 191 // x4 -> y
	
	movz x11, 0x50, lsl 16 // x11-> color
	movk x11, 0x93BA, lsl 0 // x11-> color
	
	bl rectangulo

// //--------------------------------------- CP3 (266,182) 78x14

	mov x1, 78 // x1 -> ancho del rectangulo
	mov x2, 14 // x2 -> alto del rectangulo
	mov x3, 266 // x3 -> x
	mov x4, 182 // x4 -> y
	
	movz x11, 0x50, lsl 16 // x11-> color
	movk x11, 0x93BA, lsl 0 // x11-> color
	
	bl rectangulo
// //--------------------------------------- CP4 (276,326) 9x11

	mov x1, 9 // x1 -> ancho del rectangulo
	mov x2, 11 // x2 -> alto del rectangulo
	mov x3, 276 // x3 -> x
	mov x4, 326 // x4 -> y
	
	movz x11, 0x50, lsl 16 // x11-> color
	movk x11, 0x93BA, lsl 0 // x11-> color
	
	bl rectangulo

// //--------------------------------------- CP5 (267,316) 18x11

	mov x1, 18 // x1 -> ancho del rectangulo
	mov x2, 11 // x2 -> alto del rectangulo
	mov x3, 267 // x3 -> x
	mov x4, 316 // x4 -> y
	
	movz x11, 0x50, lsl 16 // x11-> color
	movk x11, 0x93BA, lsl 0 // x11-> color
	
	bl rectangulo
	
// //--------------------------------------- CP6 (257,306) 28x11

	mov x1, 28 // x1 -> ancho del rectangulo
	mov x2, 11 // x2 -> alto del rectangulo
	mov x3, 257 // x3 -> x
	mov x4, 306 // x4 -> y
	
	movz x11, 0x50, lsl 16 // x11-> color
	movk x11, 0x93BA, lsl 0 // x11-> color
	
	bl rectangulo
	
// //--------------------------------------- CP7 (247,296) 38x11

	mov x1, 38 // x1 -> ancho del rectangulo
	mov x2, 11 // x2 -> alto del rectangulo
	mov x3, 247 // x3 -> x
	mov x4, 296 // x4 -> y
	
	movz x11, 0x50, lsl 16 // x11-> color
	movk x11, 0x93BA, lsl 0 // x11-> color
	
	bl rectangulo

// //--------------------------------------- CP8 (374,289) 9x18

	mov x1, 9 // x1 -> ancho del rectangulo
	mov x2, 18 // x2 -> alto del rectangulo
	mov x3, 374 // x3 -> x
	mov x4, 289 // x4 -> y
	
	movz x11, 0x50, lsl 16 // x11-> color
	movk x11, 0x93BA, lsl 0 // x11-> color
	
	bl rectangulo
 
// //----------------------------------Sombra campera

    mov x3, #235       // centro X
    mov x4, #440       // centro Y
    mov x15, #10     // ancho base
    mov x16, #80    //altura
    movz x11, 0x5530, lsl 16   // Carga R y G
    movk x11, 0x00, lsl 0       // Azul a 0    
    bl triangulo


// -------- CARA  color 0xFF9C5E	
// //-----CA0 (296,230) 77x77

	mov x1, 77 		// x1 -> ancho del rectangulo
	mov x2, 77 		// x2 -> alto del rectangulo
	mov x3, 296		// x3 -> x
	mov x4, 230		// x4 -> y
	
	movz x11, 0xFF, lsl 16 // x11-> color
	movk x11, 0x9c5E
	bl rectangulo
	

// //--------------------------------------- CA1 (286,239) 87x68

	mov x1, 87 		// x1 -> ancho del rectangulo
	mov x2, 68 		// x2 -> alto del rectangulo
	mov x3, 286		// x3 -> x
	mov x4, 239		// x4 -> y
	
	movz x11, 0xFF, lsl 16 // x11-> color
	movk x11, 0x9c5E
	bl rectangulo

// ------- BORDE CAPUCHA color 0xDDB97B
// //--------------------------------------- BC0 (286,239) 9x68

	mov x1, 9 		// x1 -> ancho del rectangulo
	mov x2, 68 		// x2 -> alto del rectangulo
	mov x3, 286		// x3 -> x
	mov x4, 239		// x4 -> y
	
	movz x11, 0xDD, lsl 16 // x11-> color
	movk x11, 0xB97B
	bl rectangulo
	
// //--------------------------------------- BC1 (296,230) 77x9

	mov x1, 77 		// x1 -> ancho del rectangulo
	mov x2, 9 		// x2 -> alto del rectangulo
	mov x3, 296		// x3 -> x
	mov x4, 230		// x4 -> y
	
	movz x11, 0xDD, lsl 16 // x11-> color
	movk x11, 0xB97B
	bl rectangulo	
	
// ------- MASCARA OSCURA color 0x282531
// //--------------------------------------- MO0 (286,308) 97x38


	mov x1, 97 		// x1 -> ancho del rectangulo
	mov x2, 38 		// x2 -> alto del rectangulo
	mov x3, 286		// x3 -> x
	mov x4, 308		// x4 -> y
	
	movz x11, 0x28, lsl 16 // x11-> color
	movk x11, 0x2531
	bl rectangulo	
	
// //--------------------------------------- MO1 (286,308) 107x29


	mov x1, 107 		// x1 -> ancho del rectangulo
	mov x2, 29 		// x2 -> alto del rectangulo
	mov x3, 286		// x3 -> x
	mov x4, 308		// x4 -> y
	
	movz x11, 0x28, lsl 16 // x11-> color
	movk x11, 0x2531
	bl rectangulo	
	
// //--------------------------------------- MO2 (294,298) 77x58


	mov x1, 77 		// x1 -> ancho del rectangulo
	mov x2, 58 		// x2 -> alto del rectangulo
	mov x3, 294		// x3 -> x
	mov x4, 298		// x4 -> y
	
	movz x11, 0x28, lsl 16 // x11-> color
	movk x11, 0x2531
	bl rectangulo	
	
// //--------------------------------------- MO3 (345,363) 9x8


	mov x1, 9 		// x1 -> ancho del rectangulo
	mov x2, 8 		// x2 -> alto del rectangulo
	mov x3, 345		// x3 -> x
	mov x4, 363		// x4 -> y
	
	movz x11, 0x28, lsl 16 // x11-> color
	movk x11, 0x2531
	bl rectangulo
	
// //--------------------------------------- MO4 (335,354) 29x9


	mov x1, 29 		// x1 -> ancho del rectangulo
	mov x2, 9 		// x2 -> alto del rectangulo
	mov x3, 335		// x3 -> x
	mov x4, 354		// x4 -> y
	
	movz x11, 0x28, lsl 16 // x11-> color
	movk x11, 0x2531
	bl rectangulo
	

// ------------- MASCARA CLARA color 0x37495B
//-------------- 

//-------------- MC0 (355,328) 18x28
	mov x1, 18
	mov x2, 28
	mov x3, 355
	mov x4, 328
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

//-------------- MC1 (345,336) 28x20
	mov x1, 28
	mov x2, 20
	mov x3, 345
	mov x4, 336
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

//-------------- MC2 (325,305) 19x9
	mov x1, 19
	mov x2, 9
	mov x3, 325
	mov x4, 305
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

//-------------- MC3 (327,318) 9x9
	mov x1, 9
	mov x2, 9
	mov x3, 326
	mov x4, 313
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

//-------------- MC4 (335,269) 18x38
	mov x1, 18
	mov x2, 38
	mov x3, 335
	mov x4, 269
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

//-------------- MC5 (325,279) 39x28
	mov x1, 39
	mov x2, 28
	mov x3, 325
	mov x4, 279
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

//-------------- MC6 (315,289) 58x18
	mov x1, 58
	mov x2, 18
	mov x3, 315
	mov x4, 289
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

//-------------- MC7 (286,308) 29x29
	mov x1, 29
	mov x2, 29
	mov x3, 286
	mov x4, 308
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo


	
// ---------- OJOS	color 0x000000
// //--------------------------------------- O0 (306,259) 18x19

	mov x1, 18 		// x1 -> ancho del rectangulo
	mov x2, 19 		// x2 -> alto del rectangulo
	mov x3, 306		// x3 -> x
	mov x4, 259		// x4 -> y
	
	movz x11, 0x00, lsl 16 // x11-> color
	movk x11, 0x0000
	bl rectangulo
	
// //--------------------------------------- O1 (355,259) 10x19

	mov x1, 10 		// x1 -> ancho del rectangulo
	mov x2, 19 		// x2 -> alto del rectangulo
	mov x3, 355		// x3 -> x
	mov x4, 259		// x4 -> y
	
	movz x11, 0x00, lsl 16 // x11-> color
	movk x11, 0x0000
	bl rectangulo
	
//------------------------------------------------------------------
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
    blt .saltea_dx
    add x21, x21, x23   // x-- cada 2 frames
    mov x25, #0         //resetea el contador de frames
.saltea_dx:

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
    // 4) Delay más largo (≈ 2.000.000 ciclos) contador gigante para que sea mas lerdo cada frame para que se vea un movimiento mas lento
    //--------------------------------------------------------------
    movz x5, 0xB1E0, lsl 0     // parte baja: 0xB1E0 = 45536
    movk x5, 0x002D, lsl 16    // parte alta: 0x2D0000 = 2949120
                           // total: ≈ 2994656 ciclos
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
    
      movz x5, 0xB1E0, lsl 0     // parte baja: 0xB1E0 = 45536
    movk x5, 0x002D, lsl 16    // parte alta: 0x2D0000 = 2949120
                           // total: ≈ 2994656 ciclos
delay_loop2:
    subs x5, x5, #1
    bne delay_loop2
    
    b loop_explosion
    
fin_explosion:
    
    
    b fin_meteorito

fin_meteorito:
    b fin_meteorito

    
InfLoop:
	b InfLoop
