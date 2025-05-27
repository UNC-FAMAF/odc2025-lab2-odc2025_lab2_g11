calculardireccion:
// paramentros:
//x3 -> x
//x4-> y
//queda en x0 la direcion de (x,y)

mov x6, SCREEN_WIDTH        // ancho pantalla = 640

mul x0, x6, x4              // y * ancho
add x0, x0, x3              // x + y*ancho
lsl x0, x0, #2              // *4 → offset en bytes
add x0, x20, x0              // framebuffer base + offset

ret

rectangulo:
//parametros 
// x1 -> ancho del rectangulo
// x2 -> alto del rectangulo
// x3 -> x
// x4 -> y
// x11-> color
 
 mov x5, x2
 
 bl calculardireccion

// Precalcular tamaño fila
mov x8, #640
lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loop2:                      // filas
    mov x9, x1        // columnas restantes ancho rectangulo #200
    mov x7, x0              // puntero a comienzo de fila
loop3:
    stur w11, [x7]          // pintar píxel
    add x7, x7, #4          // avanzar a próximo píxel
    sub x9, x9, #1
    cbnz x9, loop3          // salta a loop3 si no terminó de pintar cada pixel de la fila

    add x0, x0, x8          // avanzar a próxima fila
    sub x5, x5, #1
    cbnz x5, loop2
ret   
