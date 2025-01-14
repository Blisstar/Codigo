@Escribir el código ARM que ejecutado bajo ARMSim# lea un entero desde un archivo e imprima
@el valor absoluto del entero. Utilizar bifurcaciones condicionales.

.global _start
.equ SWI_fin_prog, 0x11
.equ SWI_abri_arch, 0x66
.equ SWI_leer_ente, 0x6c
.equ SWI_cerrar_arch, 0x68
.equ SWI_imp_ente, 0x6b

.data
    nombreArch: .asciz "numeroEntero.txt"

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
    @Si el numero es negativo le saco el signo y queda el valor absoluto
    cmp   r4, #0
    bpl   imprimirValorAbsoluto

sacarValorAbsoluto:
    rsb   r4, #0               @ r4 = r0 - r4

imprimirValorAbsoluto:
    @Imprimo el valor absoluto del número entero
    mov   r0, #1               @ r0 = Stdout(salida por pantalla)
    mov   r1, r4               @ r1 = r4
    swi   SWI_imp_ente
    @Fin del programa
    swi   SWI_fin_prog