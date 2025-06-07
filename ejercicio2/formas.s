.equ SCREEN_WIDTH, 		640
.equ COLOR_WHITE,   	0xFFFFFFFF


//FUNCIONES BASICAS//
calculardireccion:

//x3 -> x
//x4 -> y
//queda en x0 la direcion de (x,y)

			mov x6, SCREEN_WIDTH        // ancho pantalla

			mul x0, x6, x4              // y * ancho
			add x0, x0, x3              // x + y*ancho
			lsl x0, x0, #2              // *4 → offset en bytes
			add x0, x20, x0             // framebuffer base + offset
			br lr

rectangulo:

// x1 -> ancho del rectangulo
// x2 -> alto del rectangulo
// x3 -> x
// x4 -> y
// x11-> color
	 
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
		 
			mov x5, x2
			bl calculardireccion
		 
// Precalcular tamaño fila
			mov x8, #640
			lsl x8, x8, #2          // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loop2:                    	// nroColumnas (ancho) y direccion a c/fila
			mov x9, x1          
			mov x7, x0              
loop3:				// pintar toda la fila
			stur w11, [x7]          
			add x7, x7, #4          
			sub x9, x9, #1
			cbnz x9, loop3          // termina fila

			add x0, x0, x8          // salta a próxima fila
			sub x5, x5, #1
			cbnz x5, loop2		// termina 

			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar


//CIRCULO
// x3: centro X
// x4: centro Y
// x15: radio
// w11: color
// x20: framebuffer base

//brief: recorre un cuadro cuadrado de tamaño 2r×2r centrado en (xc,yc)(xc,yc) 
//para cada punto, verifica si cae dentro del círculo usando la fórmula x−xc​)^2 + (y−yc​)^2 ≤ r^2
//si cae dentro y además está en pantalla, lo pinta

circulo:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
			
			stp x19, x20, [sp, #-16]!   // Guardar registros que vamos a usar
			stp x21, x22, [sp, #-16]!
			stp x23, x24, [sp, #-16]!

			mov x23, x3         // xc
			mov x24, x4         // yc
			mov x22, x15        // radio
			mov x21, x20        // framebuffer base

			sub x19, x24, x22   // y = yc - radio
			mov x5, x19

.loop_y:
			add x19, x24, x22   // y_final = yc + radio
			cmp x5, x19
			b.gt .end_circulo

			sub x18, x23, x22   // x = xc - radio
			mov x6, x18

.loop_x:
			add x18, x23, x22   // x_final = xc + radio
			cmp x6, x18
			b.gt .next_row

// Validar que el pixel esté dentro del círculo
			sub x7, x6, x23         // x - xc
			mul x7, x7, x7          // (x - xc)^2

			sub x8, x5, x24         // y - yc
			mul x8, x8, x8          // (y - yc)^2

			add x7, x7, x8          // suma de distancias al cuadrado

			mul x9, x22, x22        // radio^2
			cmp x7, x9
			b.gt .skip_pixel        // si está fuera, no lo dibujamos

// Validar que (x, y) esté dentro de la pantalla
			cmp x6, #0
			blt .skip_pixel
			cmp x6, #640
			bge .skip_pixel

			cmp x5, #0
			blt .skip_pixel
			cmp x5, #480
			bge .skip_pixel

			// Calcular dirección del píxel
			mov x7, #640
			mul x8, x5, x7      // y * SCREEN_WIDTH
			add x8, x8, x6      // + x
			lsl x8, x8, #2      // * 4 (bytes por píxel)
			add x8, x21, x8     // dirección absoluta

			stur w11, [x8]      // pintar píxel

.skip_pixel:
			add x6, x6, #1
			b .loop_x

.next_row:
			add x5, x5, #1
			b .loop_y

.end_circulo:
			ldp x23, x24, [sp], #16
			ldp x21, x22, [sp], #16
			ldp x19, x20, [sp], #16
			
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar

// TRIÁNGULO usando dimensiones rectangulares
// Parámetros:
// x3: centro X
// x4: centro Y
// x15: ancho de la base
// x16: altura
// w11: color
// x20: dirección base del framebuffer

triangulo:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
			

// Guardar registros que usaremos
			stp x19, x20, [sp, #-16]!
			stp x21, x22, [sp, #-16]!
			stp x23, x24, [sp, #-16]!
			stp x25, x26, [sp, #-16]!
			stp x27, x28, [sp, #-16]!

// Configurar parámetros
			mov x23, x3      // xc (centro X)
			mov x24, x4      // yc (centro Y)
			mov x22, x15     // ancho de la base
			mov x25, x16     // altura
			mov x21, x20     // dirección base del framebuffer

// Calcular y inicial = yc - altura/2 (parte superior)
			lsr x7, x25, #1   // altura/2
			sub x5, x24, x7   // y actual

// Calcular y final = yc + altura/2 (parte inferior)
			add x26, x24, x7

bucle_y_tri:
			cmp x5, x26
			b.gt fin_triangulo

// Calcular ancho actual: (altura_actual * ancho_base) / altura_total
			sub x10, x5, x24   // dy desde el centro
			add x10, x10, x7   // dy + altura/2 (para hacerlo positivo)
			
			mul x12, x10, x22  // dy * ancho_base
			udiv x12, x12, x25 // dividir por altura total

// Calcular límites en X
			lsr x12, x12, #1   // ancho/2
			sub x13, x23, x12  // x_min = centro - ancho/2
			add x14, x23, x12  // x_max = centro + ancho/2

			mov x6, x13        // x actual

bucle_x_tri:
			cmp x6, x14
			b.gt siguiente_fila

// Verificar límites de pantalla (640x480)
			cmp x6, #0
			blt saltar_pixel
			cmp x6, #640
			bge saltar_pixel
			cmp x5, #0
			blt saltar_pixel
			cmp x5, #480
			bge saltar_pixel

// Calcular dirección en framebuffer: (y * 640 + x) * 4
			mov x8, #640
			mul x8, x5, x8     // y * 640
			add x8, x8, x6     // + x
			lsl x8, x8, #2     // * 4 (32 bits por píxel)
			add x8, x21, x8    // + dirección base del framebuffer

			str w11, [x8]      // Almacenar color del píxel

saltar_pixel:
			add x6, x6, #1     // Incrementar x
			b bucle_x_tri

siguiente_fila:
			add x5, x5, #1     // Incrementar y
			b bucle_y_tri

fin_triangulo:
// Restaurar registros
			ldp x27, x28, [sp], #16
			ldp x25, x26, [sp], #16
			ldp x23, x24, [sp], #16
			ldp x21, x22, [sp], #16
			ldp x19, x20, [sp], #16
			
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar

// FIGURAS COMPLETAS

//................PISO.............//
piso:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
			
//P(0,376) 640x103 

			mov x1, 640		// x1 -> ancho del rectangulo
			mov x2, 103		// x2 -> alto del rectangulo
			mov x3, 0		// x3 -> x
			mov x4, 376		// x4 -> y
			movz x11, 0xAA, lsl 16	// x11-> color
			movk x11, 0xDAD9, lsl 00
			
			bl rectangulo

//END PISO
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar

//................OBELISCO.............//
obelisco:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
//Punta obelisco
			mov x3, #487        // centro X
			mov x4, #239        // centro Y
			mov x15, #15        // ancho base
			mov x16, #15        //altura
			mov w11, #COLOR_WHITE
			bl triangulo

//Cuerpo obelisco
		 	mov x1, 15
			mov x2, 130
			mov x3, 480
			mov x4, 247
			movz x11, 0xDC, lsl 16
			movk x11, 0xDCDC, lsl 0
			bl rectangulo

//Ventana oblisco
		   	mov x1, 2
			mov x2, 2
			mov x3, 487
			mov x4, 244
			movz x11, 0x64, lsl 16
			movk x11, 0x6464, lsl 0
			bl rectangulo

//END OBELISCO
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar

//................SKYLINE.............//
skyline:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
			
			
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

//END SKYLINE
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar


//................NIEVE PISO.............//
nievepiso:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP


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

//END NIEVEPISO
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar

//................CARTEL.............//
cartel:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
			
			
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

//END CARTEL
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar
			
//................NIEVEPISO CARTEL.............//			
nievepiso_cartel:			
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
			
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
//END CARTEL
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar
//................LETRAS.............//

letras: 
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
		 
//.....O
// O0 40,358 4x2
			mov x1, 4		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 40		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
// O1 38,360 2x8
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 8		// x2 -> alto del rectangulo
			mov x3, 38		// x3 -> x
			mov x4, 360		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//O2 44,360 2x8
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 8		// x2 -> alto del rectangulo
			mov x3, 44		// x3 -> x
			mov x4, 360		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//O3 40,368 4x2
			mov x1, 4		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 40		// x3 -> x
			mov x4, 368		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo

//.....D
//D0 47,358 6x2
			mov x1, 6		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 47		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//D1 47,358 2x12
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 12		// x2 -> alto del rectangulo
			mov x3, 47		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//D2 53,360 2x8
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 8		// x2 -> alto del rectangulo
			mov x3, 53		// x3 -> x
			mov x4, 360		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//D3 47,368 6x2
			mov x1, 6		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 47		// x3 -> x
			mov x4, 368		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
//.....C
//C0 58,358 6x2
			mov x1, 6		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 58		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
//C1 56,360 2x8
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 8		// x2 -> alto del rectangulo
			mov x3, 56		// x3 -> x
			mov x4, 360		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//C2 58,368 6x2
			mov x1, 6		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 58		// x3 -> x
			mov x4, 368		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
//.....2
//Dos0  87,358 8x2
			mov x1, 8		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 87		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Dos01 93,358 2x4
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 4		// x2 -> alto del rectangulo
			mov x3, 93		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Dos02 91,362 2x2
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 91		// x3 -> x
			mov x4, 362		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Dos03 89,364 2x2
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 89		// x3 -> x
			mov x4, 364		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Dos04 87,366 2x4
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 4		// x2 -> alto del rectangulo
			mov x3, 87		// x3 -> x
			mov x4, 366		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Dos05 87,368 8x2
			mov x1, 8		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 87		// x3 -> x
			mov x4, 368		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//.....5
//Cinco0 99,358 6x2
			mov x1, 6		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 99		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Cinco1 96,360  2x4
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 4		// x2 -> alto del rectangulo
			mov x3, 96		// x3 -> x
			mov x4, 360		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Cinco2 96,362  6x2
			mov x1, 6		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 96		// x3 -> x
			mov x4, 362		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Cinco3 102,364 2x4
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 4		// x2 -> alto del rectangulo
			mov x3, 102		// x3 -> x
			mov x4, 364		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Cinco4 96,366  2x2
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 96		// x3 -> x
			mov x4, 366		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//Cinco5 99,368 4x2
			mov x1, 4		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 99		// x3 -> x
			mov x4, 368		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//.....K
//K0 105,358 2x12
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 12		// x2 -> alto del rectangulo
			mov x3, 105		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//K1 111,358 2x2
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 111		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//K2 109,360 2x2
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 109		// x3 -> x
			mov x4, 360		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//K3 105 362 4x2
			mov x1, 4		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 105		// x3 -> x
			mov x4, 362		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//K4 109 364 4x2
			mov x1, 4		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 109		// x3 -> x
			mov x4, 364		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//K5 111 364 2x6
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 6		// x2 -> alto del rectangulo
			mov x3, 111		// x3 -> x
			mov x4, 364		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo

//.....M
//M0 114 358 2x12
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 12		// x2 -> alto del rectangulo
			mov x3, 114		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//M1 122 358 2x12
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 12		// x2 -> alto del rectangulo
			mov x3, 122		// x3 -> x
			mov x4, 358		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//M2 114 360 4x2
			mov x1, 4		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 114		// x3 -> x
			mov x4, 360		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//M3 120 360 4x2
			mov x1, 4		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 120		// x3 -> x
			mov x4, 360		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//M4 118 362 2x2
			mov x1, 2		// x1 -> ancho del rectangulo
			mov x2, 2		// x2 -> alto del rectangulo
			mov x3, 118		// x3 -> x
			mov x4, 362		// x4 -> y
			movz x11, 0xFF, lsl 16	// x11-> color
			movk x11, 0xFFFF, lsl 00 
			
			bl rectangulo
			
//END LETRAS
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar
//................ETERNAUTA.............//
eternauta:
			
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
			
			
			
//------CUERPO color: 0x6C421F
//C0 (160,434) 195x45 

			mov x1, 195		// x1 -> ancho del rectangulo
			mov x2, 45		// x2 -> alto del rectangulo
			mov x3, 160		// x3 -> x
			mov x4, 435		// x4 -> y
			movz x11, 0x6C, lsl 16	// x11-> color
			movk x11, 0x421F, lsl 00 
			
			bl rectangulo
		
//C1 (170,396) 185x83 
		    mov x1, 185		// x1 -> ancho del rectangulo
			mov x2, 83		// x2 -> alto del rectangulo
			mov x3, 170		// x3 -> x
			mov x4, 396		// x4 -> y
			movz x11, 0x6C, lsl 16	// x11-> color
			movk x11, 0x421F, lsl 00 
			
			bl rectangulo

//C2 (179,366) 176x113 

		    mov x1, 176		// x1 -> ancho del rectangulo
			mov x2, 113		// x2 -> alto del rectangulo
			mov x3, 179		// x3 -> x
			mov x4, 366		// x4 -> y
			movz x11, 0x6C, lsl 16	// x11-> color
			movk x11, 0x421F, lsl 00 
			
			bl rectangulo
			
//C3 (189,347) 166x132 

		    mov x1, 166		// x1 -> ancho del rectangulo
			mov x2, 132		// x2 -> alto del rectangulo
			mov x3, 189		// x3 -> x
			mov x4, 347		// x4 -> y
			movz x11, 0x6C, lsl 16	// x11-> color
			movk x11, 0x421F, lsl 00 
			
			bl rectangulo

//C4 (199,337) 156x142 

		    mov x1, 156		// x1 -> ancho del rectangulo
			mov x2, 142		// x2 -> alto del rectangulo
			mov x3, 199		// x3 -> x
			mov x4, 337		// x4 -> y
			movz x11, 0x6C, lsl 16	// x11-> color
			movk x11, 0x421F, lsl 00 
			
			bl rectangulo
			
//C5 (209,298) 146x181 
		    mov x1, 146		// x1 -> ancho del rectangulo
			mov x2, 181		// x2 -> alto del rectangulo
			mov x3, 209		// x3 -> x
			mov x4, 298		// x4 -> y
			movz x11, 0x6C, lsl 16	// x11-> color
			movk x11, 0x421F, lsl 00 
			
			bl rectangulo

//-----CAPUCHA color: 0x5093BA
//CP0 (238,221) 145x77

			mov x1, 145 // x1 -> ancho del rectangulo
			mov x2, 77 // x2 -> alto del rectangulo
			mov x3, 238 // x3 -> x // x11-> color
			mov x4, 221 // x4 -> y // x11-> color
			
			movz x11, 0x50, lsl 16
			movk x11, 0x93BA, lsl 0
			bl rectangulo

//CP1 (247,201) 126x36

			mov x1, 126 // x1 -> ancho del rectangulo
			mov x2, 36 // x2 -> alto del rectangulo
		 	mov x3, 247 // x3 -> x
			mov x4, 201 // x4 -> y
			
			movz x11, 0x50, lsl 16 // x11-> color
			movk x11, 0x93BA, lsl 0 // x11-> color
			
			bl rectangulo

//CP2 (257,191) 108x17

			mov x1, 108 // x1 -> ancho del rectangulo
			mov x2, 17 // x2 -> alto del rectangulo
			mov x3, 257 // x3 -> x
			mov x4, 191 // x4 -> y
			
			movz x11, 0x50, lsl 16 // x11-> color
			movk x11, 0x93BA, lsl 0 // x11-> color
			
			bl rectangulo

//CP3 (266,182) 78x14

			mov x1, 78 // x1 -> ancho del rectangulo
			mov x2, 14 // x2 -> alto del rectangulo
			mov x3, 266 // x3 -> x
			mov x4, 182 // x4 -> y
			
			movz x11, 0x50, lsl 16 // x11-> color
			movk x11, 0x93BA, lsl 0 // x11-> color
			
			bl rectangulo
			
//CP4 (276,326) 9x11

			mov x1, 9 // x1 -> ancho del rectangulo
			mov x2, 11 // x2 -> alto del rectangulo
			mov x3, 276 // x3 -> x
			mov x4, 326 // x4 -> y
			
			movz x11, 0x50, lsl 16 // x11-> color
			movk x11, 0x93BA, lsl 0 // x11-> color
			
			bl rectangulo

//CP5 (267,316) 18x11

			mov x1, 18 // x1 -> ancho del rectangulo
			mov x2, 11 // x2 -> alto del rectangulo
			mov x3, 267 // x3 -> x
			mov x4, 316 // x4 -> y
			
			movz x11, 0x50, lsl 16 // x11-> color
			movk x11, 0x93BA, lsl 0 // x11-> color
			
			bl rectangulo
		
//CP6 (257,306) 28x11

			mov x1, 28 // x1 -> ancho del rectangulo
			mov x2, 11 // x2 -> alto del rectangulo
			mov x3, 257 // x3 -> x
			mov x4, 306 // x4 -> y
			
			movz x11, 0x50, lsl 16 // x11-> color
			movk x11, 0x93BA, lsl 0 // x11-> color
			
			bl rectangulo
			
//CP7 (247,296) 38x11

			mov x1, 38 // x1 -> ancho del rectangulo
			mov x2, 11 // x2 -> alto del rectangulo
			mov x3, 247 // x3 -> x
			mov x4, 296 // x4 -> y
			
			movz x11, 0x50, lsl 16 // x11-> color
			movk x11, 0x93BA, lsl 0 // x11-> color
			
			bl rectangulo

//CP8 (374,289) 9x18

			mov x1, 9 // x1 -> ancho del rectangulo
			mov x2, 18 // x2 -> alto del rectangulo
			mov x3, 373 // x3 -> x
			mov x4, 289 // x4 -> y
			
			movz x11, 0x50, lsl 16 // x11-> color
			movk x11, 0x93BA, lsl 0 // x11-> color
			
			bl rectangulo
		 
//Sombra campera

			mov x3, #235       // centro X
			mov x4, #440       // centro Y
			mov x15, #10     // ancho base
			mov x16, #80    //altura
			movz x11, 0x5530, lsl 16   // Carga R y G
			movk x11, 0x00, lsl 0       // Azul a 0    
			bl triangulo

//-----CARA  color 0xFF9C5E	
//CA0 (296,230) 77x77

			mov x1, 77 		// x1 -> ancho del rectangulo
			mov x2, 77 		// x2 -> alto del rectangulo
			mov x3, 296		// x3 -> x
			mov x4, 230		// x4 -> y
			
			movz x11, 0xFF, lsl 16 // x11-> color
			movk x11, 0x9c5E, lsl 0 
			bl rectangulo
			
//CA1 (286,239) 87x68

			mov x1, 87 		// x1 -> ancho del rectangulo
			mov x2, 68 		// x2 -> alto del rectangulo
			mov x3, 286		// x3 -> x
			mov x4, 239		// x4 -> y
			
			movz x11, 0xFF, lsl 16 // x11-> color
			movk x11, 0x9c5E, lsl 0 
			bl rectangulo

//-----BORDE CAPUCHA color 0xDDB97B
//BC0 (286,239) 9x68

			mov x1, 9 		// x1 -> ancho del rectangulo
			mov x2, 68 		// x2 -> alto del rectangulo
			mov x3, 285		// x3 -> x
			mov x4, 239		// x4 -> y
			
			movz x11, 0xDD, lsl 16 // x11-> color
			movk x11, 0xB97B, lsl 0 
			bl rectangulo
			
//BC1 (296,230) 77x9

			mov x1, 77 		// x1 -> ancho del rectangulo
			mov x2, 9 		// x2 -> alto del rectangulo
			mov x3, 296		// x3 -> x
			mov x4, 230		// x4 -> y
			
			movz x11, 0xDD, lsl 16 // x11-> color
			movk x11, 0xB97B, lsl 0 
			bl rectangulo	
			
//-----MASCARA OSCURA color 0x282531
//MO0 (286,308) 97x38

			mov x1, 97 		// x1 -> ancho del rectangulo
			mov x2, 38 		// x2 -> alto del rectangulo
			mov x3, 286		// x3 -> x
			mov x4, 308		// x4 -> y
			
			movz x11, 0x28, lsl 16 // x11-> color
			movk x11, 0x2531, lsl 0 
			bl rectangulo	
		
//MO1 (286,308) 107x29

			mov x1, 107 		// x1 -> ancho del rectangulo
			mov x2, 29 		// x2 -> alto del rectangulo
			mov x3, 286		// x3 -> x
			mov x4, 307		// x4 -> y
			
			movz x11, 0x28, lsl 16 // x11-> color
			movk x11, 0x2531, lsl 0 
			bl rectangulo	
		
//MO2 (294,298) 77x58

			mov x1, 77 		// x1 -> ancho del rectangulo
			mov x2, 58 		// x2 -> alto del rectangulo
			mov x3, 294		// x3 -> x
			mov x4, 298		// x4 -> y
			
			movz x11, 0x28, lsl 16 // x11-> color
			movk x11, 0x2531, lsl 0 
			bl rectangulo	
		
//MO3 (345,363) 9x8

			mov x1, 9 		// x1 -> ancho del rectangulo
			mov x2, 8 		// x2 -> alto del rectangulo
			mov x3, 345		// x3 -> x
			mov x4, 363		// x4 -> y
			
			movz x11, 0x28, lsl 16 // x11-> color
			movk x11, 0x2531, lsl 0 
			bl rectangulo
		
//MO4 (335,354) 29x9

			mov x1, 29 		// x1 -> ancho del rectangulo
			mov x2, 9 		// x2 -> alto del rectangulo
			mov x3, 335		// x3 -> x
			mov x4, 354		// x4 -> y
			
			movz x11, 0x28, lsl 16 // x11-> color
			movk x11, 0x2531, lsl 0 
			bl rectangulo
		
//-----MASCARA CLARA color 0x37495B
//MC0 (355,328) 18x28
			mov x1, 18
			mov x2, 28
			mov x3, 355
			mov x4, 328
			movz x11, 0x37, lsl 16
			movk x11, 0x495B, lsl 0
			bl rectangulo

//MC1 (345,336) 28x20
			mov x1, 28
			mov x2, 20
			mov x3, 345
			mov x4, 336
			movz x11, 0x37, lsl 16
			movk x11, 0x495B, lsl 0
			bl rectangulo

//MC2 (325,305) 19x9
			mov x1, 19
			mov x2, 9
			mov x3, 325
			mov x4, 305
			movz x11, 0x37, lsl 16
			movk x11, 0x495B, lsl 0
			bl rectangulo

//MC3 (327,318) 9x9
			mov x1, 9
			mov x2, 9
			mov x3, 326
			mov x4, 313
			movz x11, 0x37, lsl 16
			movk x11, 0x495B, lsl 0
			bl rectangulo

//MC4 (335,269) 18x38
			mov x1, 18
			mov x2, 38
			mov x3, 335
			mov x4, 269
			movz x11, 0x37, lsl 16
			movk x11, 0x495B, lsl 0
			bl rectangulo

//MC5 (325,279) 39x28
			mov x1, 39
			mov x2, 28
			mov x3, 325
			mov x4, 279
			movz x11, 0x37, lsl 16
			movk x11, 0x495B, lsl 0
			bl rectangulo

//MC6 (315,289) 58x18
			mov x1, 58
			mov x2, 18
			mov x3, 315
			mov x4, 289
			movz x11, 0x37, lsl 16
			movk x11, 0x495B, lsl 0
			bl rectangulo

//MC7 (286,308) 29x29
			mov x1, 29
			mov x2, 29
			mov x3, 286
			mov x4, 308
			movz x11, 0x37, lsl 16
			movk x11, 0x495B, lsl 0
			bl rectangulo

//-----OJOS	color 0x000000
//O0 (306,259) 18x19

			mov x1, 18 		// x1 -> ancho del rectangulo
			mov x2, 19 		// x2 -> alto del rectangulo
			mov x3, 306		// x3 -> x
			mov x4, 259		// x4 -> y
			
			movz x11, 0x00, lsl 16 // x11-> color
			movk x11, 0x0000, lsl 0 
			bl rectangulo
			
//O1 (355,259) 10x19

			mov x1, 10 		// x1 -> ancho del rectangulo
			mov x2, 19 		// x2 -> alto del rectangulo
			mov x3, 355		// x3 -> x
			mov x4, 259		// x4 -> y
			
			movz x11, 0x00, lsl 16 // x11-> color
			movk x11, 0x0000, lsl 0 
			bl rectangulo


//END ETERNAUTA
			
			LDUR x29, [sp, #0]    // Cargar x29
			LDUR x30, [sp, #8]    // Cargar x30
			ADD sp, sp, #16       // Liberar stack
			BR x30                // Retornar
			
//................NIEVE COPOS.............//
nievecopos:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP
			
//NIEVE (círculos)
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

//END COPOS
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar
			
			
			

// FORMAS ANIMACIONES


//------------------------------------------------------------------
//ANIMACION: parpadeoCall

parpadeoCall:
			sub sp, sp, #16       // Reservar espacio
			stur x29, [sp, #0]    // Guardar x29 en [sp]
			stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
			mov x29, sp           // Establecer nuevo FP



			mov x17, #2 // inicializador parpadeo
parpadeo:
			
//delay
			movz x5, 0xDFFF, lsl 0     
			movk x5, 0x0F2D, lsl 16    
					               
delay_ojos00:
			subs x5, x5, #1
			bne delay_ojos00
			
// 1) Borrar ojos

//ojo 1
			mov x1, 18 		// x1 -> ancho del rectangulo
			mov x2, 17		// x2 -> alto del rectangulo
			mov x3, 306		// x3 -> x
			mov x4, 259		// x4 -> y
			
			movz x11, 0xFF, lsl 16 // x11-> color cara
			movk x11, 0x9c5E
			bl rectangulo
			
//ojo 2
			mov x1, 10 		// x1 -> ancho del rectangulo
			mov x2, 17 		// x2 -> alto del rectangulo
			mov x3, 355		// x3 -> x
			mov x4, 259		// x4 -> y
			
			movz x11, 0xFF, lsl 16 // x11-> color cara
			movk x11, 0x9c5E
			bl rectangulo
			
//delay
			movz x5, 0xDFFF, lsl 0     
			movk x5, 0x0E2D, lsl 16    
					               
delay_ojos:
			subs x5, x5, #1
			bne delay_ojos
			
//dibujar ojos
			mov x1, 18 		// x1 -> ancho del rectangulo
			mov x2, 19 		// x2 -> alto del rectangulo
			mov x3, 306		// x3 -> x
			mov x4, 259		// x4 -> y
			
			movz x11, 0x00, lsl 16 // x11-> color
			movk x11, 0x0000
			bl rectangulo
			

			mov x1, 10 		// x1 -> ancho del rectangulo
			mov x2, 19 		// x2 -> alto del rectangulo
			mov x3, 355		// x3 -> x
			mov x4, 259		// x4 -> y
			
			movz x11, 0x00, lsl 16 // x11-> color
			movk x11, 0x0000
			bl rectangulo
			
			sub x17, x17, #1
			cbnz x17, parpadeo
			
//END PARPADEO CALL
			ldur x29, [sp, #0]    // Cargar x29
			ldur x30, [sp, #8]    // Cargar x30
			add sp, sp, #16       // Liberar stack
			br x30                // Retornar
				

// ANIMACIÓN: Meteorito 
//------------------------------------------------------------------
meteoritoCall:
			sub sp, sp, #16       // Reservar espacio
	        stur x29, [sp, #0]    // Guardar x29 en [sp]
	        stur x30, [sp, #8]    // Guardar x30 en [sp + 8]
	        mov x29, sp           // Establecer nuevo FP

loop_meteorito00:


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
		blt saltea_dx00
		add x21, x21, x23   // x-- cada 2 frames
		mov x25, #0         //resetea el contador de frames
saltea_dx00:

		cmp x22, #239     // compara pero no guarda resultado solo flag
		bgt meteorito01  //si x22 > 239 que es donde esta la punta del obelisco entonces salta a explosion en obelisco y no sigue con dibujar meteoro

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

	// redibujo
		bl skyline
		bl nievepiso
		bl cartel
		bl nievepiso_cartel
		bl letras
		bl eternauta

//--------------------------------------------------------------
// 4) Delay
//--------------------------------------------------------------
		movz x5, 0xDFFF, lsl 0     
    		movk x5, 0x004D, lsl 16    
delay_loop00:
		subs x5, x5, #1
		bne delay_loop00

		b loop_meteorito00


meteorito01:

// redibujo
		bl skyline
		bl nievepiso
		bl cartel
		bl nievepiso_cartel
		bl letras
		bl eternauta

//END METEORITO
        ldur x29, [sp, #0]    // Cargar x29
		ldur x30, [sp, #8]    // Cargar x30
		add sp, sp, #16       // Liberar stack
		br x30                // Retornar
