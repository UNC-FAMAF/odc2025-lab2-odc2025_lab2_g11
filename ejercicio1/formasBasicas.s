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

.endif
