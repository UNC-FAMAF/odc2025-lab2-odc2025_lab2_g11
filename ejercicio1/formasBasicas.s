.ifndef formasBasicas_s
.equ SCREEN_WIDTH, 640

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
 
	 stp x29, x30, [sp, #-16]!  // Guardar x29 (fp) y x30 (lr)
	 mov x29, sp                // Establecer nuevo frame pointer
 
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

	ldp x29, x30, [sp], #16    // Restaurar x29 y x30
	br lr
.endif
