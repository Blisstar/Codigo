@ Escribir el código ARM que ejecutado bajo ARMSim# lea dos enteros desde un archivo e
@ imprima el mínimo y el máximo respectivamente de la siguiente manera:
@ Min: <mínimo>
@ Max: <máximo>

.global _start
.equ SWI_fin_prog, 0x11
.equ SWI_abri_arch, 0x66
.equ SWI_leer_ente, 0x6c
.equ SWI_cerrar_arch, 0x68
.equ SWI_imp_ente, 0x6b
.equ SWI_print, 0x02

.data
    nombreArch:     .asciz "numeroEntero.txt"
    minTexto:       .asciz "Min: "
    maxTexto:       .asciz "Max: "
    numeroEntero1:  .word 5
    numeroEntero2:  .word -6

.text
_start:
    ldr   r0, =numeroEntero1
    mov   r0, [r0]
    ldr   r1, =numeroEntero1
    mov   r1, [r1]
    cmp   r0, r1
    bmi   imprimirResultado

swap:
    mov r2, r0
    mov r0, r1
    mov r1, r2

imprimirResultado:
    
    