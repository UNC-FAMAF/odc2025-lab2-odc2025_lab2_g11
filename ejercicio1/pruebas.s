//rectangulo en el medio
//paso 1 guardar constantes de ancho y alto van a ser contadores

.equ ANCHOREC, 300
.equ ALTOREC,  200

// paso 2 guardar color y constante altorec en registro
movz x11, 0xFF, lsl 16
movk x11, 0x0000, lsl 0

mov x2, ALTOREC             // contador de filas

// //paso 3 encontrar direccion base para arrancar en rectangulo del pixel que querramos, en este caso elijo el pixel (200,120) x=200 y=120
//usando la formula direcion=base + 4*(x + (y*640))  
mov x3, #200                // x
mov x4, #120                // y
mov x6, SCREEN_WIDTH        // ancho pantalla = 640
// elijo x5 como registro base
mul x5, x6, x4              // y * 640
add x5, x5, x3              // x + y*640
lsl x5, x5, #2              // 4*(x + (y*640)
add x5, x20, x5              // base + 4*(x + (y*640))

// Precalcular tamaño fila
mov x8, #640
lsl x8, x8, #2              // x8 = 640 * 4 = 2560

// Dibujo del rectángulo
loop2:                      // filas
    mov x1, ANCHOREC        // columnas restantes
    mov x7, x5              // puntero a comienzo de fila
loop3:
    stur w11, [x7]          // pintar píxel
    add x7, x7, #4          // avanzar a próximo píxel
    sub x1, x1, #1
    cbnz x1, loop3          // volver si no terminó la fila

    add x5, x5, x8          // avanzar a próxima fila
    sub x2, x2, #1
    cbnz x2, loop2
