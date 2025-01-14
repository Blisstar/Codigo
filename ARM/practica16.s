@ Escribir el código ARM que ejecutado bajo ARMSim# imprima los valores de un vector de
@ cuatro enteros definidos en memoria, recorriendo el vector mediante una subrutina que utilice
@ direccionamiento por registro indirecto.

.global _start
.equ SWI_fin_prog, 0x11
.equ SWI_imp_ente, 0x6b
.equ SWI_print, 0x02
.equ Stdout, 1

.data
    array: .word 94, 46, 46, 69, -1
    eol:   .asciz "/n"
.text
_start:
    ldr r2, =array
    @ mov r3, #4

mostrarLoop:
    bl   mostrarNumero
    add  r2, r2, #4
    @ subs r3, r3, #1
    ldr  r1, [r2]
    cmp  r1, #-1
    bne  mostrarLoop
    b    fin

mostrarNumero:
    stmfd sp!, {r0, r1, lr}
    ldr   r0, =Stdout
    ldr   r1, [r2]
    swi SWI_imp_ente
    ldr   r1, =eol
    swi   SWI_print
    ldmfd sp!, {r0, r1, pc}

fin:
    swi SWI_fin_prog
    .end