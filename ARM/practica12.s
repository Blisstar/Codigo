@ Escribir el código ARM que ejecutado bajo ARMSim# lea un entero desde un archivo, calcule el
@ factorial de ese entero y muestre los valores intermedios del proceso. El algoritmo podría
@ resumirse como:
@ n = <<entero leído desde archivo>>
@ accum = 1
@ while (n != 0) {
@ accum = accum * n
@ print accum
@ print "\n"
@ n = n - 1
@
@ }
@ print accum
@ print "\n"
@ Una salida aceptable del programa sería, para el caso que el valor de entrada fuera 5:
@ 5
@ 20
@ 60
@ 120
@ 120
@ 120
@ Puede asumirse que el archivo no contendrá un entero negativo.

.global _start
.equ SWI_fin_prog, 0x11
.equ SWI_abri_arch, 0x66
.equ SWI_leer_ente, 0x6c
.equ SWI_cerrar_arch, 0x68
.equ SWI_imp_ente, 0x6b

.data
    nombreArch: .asciz "numeroEnteroPositivo.txt"

.text
_start:
    @Abro archivo
    ldr   r0, =nombreArch      @ r0 -> nombreArch
    mov   r1, #0               @ r1 -> modo : entrada
    swi   SWI_abri_arch
    mov   r5, r0               @ r5 = idArchivo = r0
    @Leo entero
    mov   r0, r5               @ r0 = r5 = idArchivo
    swi   SWI_leer_ente
    mov   r4, r0               @ r4 = numeroEntero = r0
    @Cierro archivo
    mov   r0, r5               @ r0 = r5 = idArchivo
    swi   SWI_cerrar_arch
    @Imprimo todos los resultados cada vez que se multiplica el numero en su factorial
    mov   r3, r4
    bl    impEnteroR4

impFactorial:
    @Calculo factorial
    sub   r3, r3, #1
    cmp   r3, #0
    beq   finPrograma
    mul   r4, r4, r3
    @Imprimo el entero
    bl    impEnteroR4
    b     impFactorial

impEnteroR4:
    stmfd sp!, {lr}
    mov   r0, #1               @ r0 = Stdout(salida por pantalla)
    mov   r1, r4               @ r1 = r4
    swi   SWI_imp_ente
    ldmfd sp!, {pc}

finPrograma:
    swi   SWI_fin_prog