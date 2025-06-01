	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  		32
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
    mov x3, #490       // centro X
    mov x4, #125       // centro Y
    mov x15, #30        // ancho base
    mov x16, #35        //altura
    mov w11, #COLOR_WHITE
    bl triangulo


    //cuerpo obelisco
 	mov x1, 30
	mov x2, 240
	mov x3, 475
	mov x4, 143
	movz x11, 0xDC, lsl 16
	movk x11, 0xDCDC, lsl 0
	bl rectangulo

    //ventana oblisco
    mov x1, 4
	mov x2, 8
	mov x3, 488
	mov x4, 125
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
	

//--------CUERPO color: 0x6C421F -------//
// //--------------------------------------- C0 (160,434) 195x45 

	mov x1, 195		// x1 -> ancho del rectangulo
	mov x2, 45		// x2 -> alto del rectangulo
	mov x3, 160		// x3 -> x
	mov x4, 434		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 421F, lsl 00 
	
	bl rectangulo
	
	

// //--------------------------------------- C1 (170,396) 185x83 
        mov x1, 185		// x1 -> ancho del rectangulo
	mov x2, 83		// x2 -> alto del rectangulo
	mov x3, 170		// x3 -> x
	mov x4, 396		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 421F, lsl 00 
	
	bl rectangulo

	
	
// //--------------------------------------- C2 (179,366) 176x113 

        mov x1, 176		// x1 -> ancho del rectangulo
	mov x2, 113		// x2 -> alto del rectangulo
	mov x3, 179		// x3 -> x
	mov x4, 366		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 421F, lsl 00 
	
	bl rectangulo
	

// //--------------------------------------- C3 (189,347) 166x132 

        mov x1, 166		// x1 -> ancho del rectangulo
	mov x2, 132		// x2 -> alto del rectangulo
	mov x3, 189		// x3 -> x
	mov x4, 347		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 421F, lsl 00 
	
	bl rectangulo

	
	
// //--------------------------------------- C4 (199,337) 156x142 

        mov x1, 156		// x1 -> ancho del rectangulo
	mov x2, 142		// x2 -> alto del rectangulo
	mov x3, 199		// x3 -> x
	mov x4, 337		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 421F, lsl 00 
	
	bl rectangulo
	
// //--------------------------------------- C5 (209,298) 146x181 
        mov x1, 146		// x1 -> ancho del rectangulo
	mov x2, 181		// x2 -> alto del rectangulo
	mov x3, 209		// x3 -> x
	mov x4, 298		// x4 -> y
	movz x11, 0x6C, lsl 16	// x11-> color
	movk x11, 421F, lsl 00 
	
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


	movz x11, 0xFF, lsl 16
	movk x11, 0x9C5E, lsl 0

	mov x2, 68            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #286                // x
	mov x4, #239               // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopCA12:                      	// filas
    	mov x1, 87       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopCA11:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopCA11          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopCA12
	

// ------- BORDE CAPUCHA color 0xDDB97B
// //--------------------------------------- BC0 (286,239) 9x68


	movz x11, 0xDD, lsl 16
	movk x11, 0xB97B, lsl 0

	mov x2, 68            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #286                // x
	mov x4, #239               // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopBC02:                      	// filas
    	mov x1, 9       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopBC01:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopBC01          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopBC02
	
// //--------------------------------------- BC1 (296,230) 77x9


	movz x11, 0xDD, lsl 16
	movk x11, 0xB97B, lsl 0

	mov x2, 9            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #296                // x
	mov x4, #230               // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopBC12:                      	// filas
    	mov x1, 77       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopBC11:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopBC11          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopBC12
	
	
// ------- MASCARA OSCURA color 0x282531
// //--------------------------------------- MO0 (286,308) 97x38


	movz x11, 0x28, lsl 16
	movk x11, 0x2531, lsl 0

	mov x2, 38            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #286                // x
	mov x4, #308               // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopMO02:                      	// filas
    	mov x1, 97       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopMO01:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopMO01          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopMO02
	
// //--------------------------------------- MO1 (286,308) 107x29


	movz x11, 0x28, lsl 16
	movk x11, 0x2531, lsl 0

	mov x2, 29            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #286                // x
	mov x4, #308               // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopMO12:                      	// filas
    	mov x1, 107       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopMO11:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopMO11          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopMO12
	
// //--------------------------------------- MO2 (294,298) 77x58


	movz x11, 0x28, lsl 16
	movk x11, 0x2531, lsl 0

	mov x2, 58            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #294                // x
	mov x4, #298               // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopMO22:                      	// filas
    	mov x1, 77       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopMO21:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopMO21          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopMO22
	
// //--------------------------------------- MO3 (345,363) 9x8


	movz x11, 0x28, lsl 16
	movk x11, 0x2531, lsl 0

	mov x2, 8            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #345                // x
	mov x4, #363                // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopMO32:                      	// filas
    	mov x1, 9       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopMO31:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopMO31          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopMO32
	
// //--------------------------------------- MO4 (335,354) 29x9


	movz x11, 0x28, lsl 16
	movk x11, 0x2531, lsl 0

	mov x2, 9            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #335                // x
	mov x4, #354                // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopMO42:                      	// filas
    	mov x1, 29       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopMO41:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopMO41          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopMO42
	

// ------------- MASCARA CLARA color 0x37495B
//-------------- MC0 (355,328) 18x28

// MC0 (355,328) 18x28
	mov x1, 18
	mov x2, 28
	mov x3, 355
	mov x4, 328
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

	// MC1 (345,336) 28x20
	mov x1, 28
	mov x2, 20
	mov x3, 345
	mov x4, 336
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

	// MC2 (325,305) 19x9
	mov x1, 19
	mov x2, 9
	mov x3, 325
	mov x4, 305
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

	// MC3 (327,318) 9x9
	mov x1, 9
	mov x2, 9
	mov x3, 326
	mov x4, 313
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

	// MC4 (335,269) 18x38
	mov x1, 18
	mov x2, 38
	mov x3, 335
	mov x4, 269
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

	// MC5 (325,279) 39x28
	mov x1, 39
	mov x2, 28
	mov x3, 325
	mov x4, 279
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

	// MC6 (315,289) 58x18
	mov x1, 58
	mov x2, 18
	mov x3, 315
	mov x4, 289
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo

	// MC7 (286,308) 29x29
	mov x1, 29
	mov x2, 29
	mov x3, 286
	mov x4, 308
	movz x11, 0x37, lsl 16
	movk x11, 0x495B, lsl 0
	bl rectangulo


	
// ---------- OJOS	color 0x000000
// //--------------------------------------- O0 (306,259) 18x19


	movz x11, 0x00, lsl 16
	movk x11, 0x0000, lsl 0

	mov x2, 19            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #308                // x
	mov x4, #261                // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopO02:                      	// filas
    	mov x1, 18       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopO01:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopO01          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopO02
	
	
// //--------------------------------------- O1 (355,259) 10x19


	movz x11, 0x00, lsl 16
	movk x11, 0x0000, lsl 0

	mov x2, 19            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #353                // x
	mov x4, #260                // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopO12:                      	// filas
    	mov x1, 10       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopO11:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopO11          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopO12
	
// --------- NIEVE color 0xFFFFFF
// //--------------------------------------- N0 (169,288) 11x11


	movz x11, 0xFF, lsl 16
	movk x11, 0xFFFF, lsl 0

	mov x2, 11            // contador de filas

//usando la formula direcion=base + 4*(x + (y*640))  

	mov x3, #169                // x
	mov x4, #288                // y
	mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
	mul x5, x6, x4              // y * ancho
	add x5, x5, x3              // x + y*ancho
	lsl x5, x5, #2              // *4 → offset en bytes
	add x5, x20, x5              // framebuffer base + offset

// Precalcular tamaño fila
	mov x8, #640
	lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loopN02:                      	// filas
    	mov x1, 11       	// columnas restantes
    	mov x7, x5              // puntero a comienzo de fila
loopN01:
    	stur w11, [x7]          // pintar píxel
	add x7, x7, #4          // avanzar a próximo píxel
	sub x1, x1, #1
	cbnz x1, loopN01          // volver si no terminó la fila

	add x5, x5, x8          // avanzar a próxima fila
	sub x2, x2, #1
	cbnz x2, loopN02

 // --------- NIEVE (círculos)
	mov w11, #COLOR_WHITE

	// Copo 1
	mov x3, #320         // Centro X 
	mov x4, #240         // Centro Y 
	mov x15, #2          // Radio del círculo
	bl circulo

	// Copo 2
	mov x3, #400      
	mov x4, #200       
	mov x15, #4       
	bl circulo

	// Copo 3
	mov x3, #350
	mov x4, #350    
	mov x15, #6     
	bl circulo

	// Copo 4
	mov x3, #50
	mov x4, #350    
	mov x15, #6  
	bl circulo

	// Copo 5
	mov x3, #30
	mov x4, #100
	mov x15, #2      
	bl circulo

	// Copo 6
	mov x3, #600
	mov x4, #100
	mov x15, #3
	bl circulo

	// Copo 7
	mov x3, #580
	mov x4, #300
	mov x15, #5
	bl circulo

	// Copo 8
	mov x3, #100
	mov x4, #400
	mov x15, #4
	bl circulo

	// Copo 9
	mov x3, #500
	mov x4, #50
	mov x15, #2
	bl circulo

	// Copo 10
	mov x3, #150
	mov x4, #200
	mov x15, #3
	bl circulo

	// Copo 11
	mov x3, #400
	mov x4, #420
	mov x15, #4
	bl circulo

	// Copo 12
	mov x3, #250
	mov x4, #150
	mov x15, #5
	bl circulo

	// Copo 13
	mov x3, #70
	mov x4, #180
	mov x15, #3
	bl circulo

	// Copo 14
	mov x3, #200
	mov x4, #80
	mov x15, #2
	bl circulo

	// Copo 15
	mov x3, #450
	mov x4, #280
	mov x15, #4
	bl circulo

	// Copo 16
	mov x3, #550
	mov x4, #180
	mov x15, #3
	bl circulo

	// Copo 17
	mov x3, #300
	mov x4, #400
	mov x15, #5
	bl circulo

	// Copo 18
	mov x3, #120
	mov x4, #300
	mov x15, #2
	bl circulo

	// Copo 19
	mov x3, #380
	mov x4, #150
	mov x15, #3
	bl circulo

	// Copo 20
	mov x3, #480
	mov x4, #380
	mov x15, #4
	bl circulo

	// Copo 21
	mov x3, #180
	mov x4, #250
	mov x15, #2
	bl circulo

	// Copo 22
	mov x3, #420
	mov x4, #320
	mov x15, #3
	bl circulo

InfLoop:
	b InfLoop
