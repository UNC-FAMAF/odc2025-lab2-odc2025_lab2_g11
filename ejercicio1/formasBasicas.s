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
    stp x29, x30, [sp, #-16]!   // Guardar frame
    mov x29, sp

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
    ldp x29, x30, [sp], #16
    ret

// TRIÁNGULO usando dimensiones rectangulares
// Parámetros:
// x3: centro X
// x4: centro Y
// x15: ancho de la base
// x16: altura
// w11: color
// x20: dirección base del framebuffer

triangulo:
    stp x29, x30, [sp, #-16]!   // Guardar FP y LR
    mov x29, sp                  // Establecer FP

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
    
    ldp x29, x30, [sp], #16  // Restaurar FP y LR
    ret                      // Retornar


//................LETRAS.............//

letras: 
	 stp x29, x30, [sp, #-16]!  // Guardar x29 (fp) y x30 (lr)
	 mov x29, sp                // Establecer nuevo frame pointer
	 
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
	ldp x29, x30, [sp], #16    // Restaurar x29 y x30
	br lr

