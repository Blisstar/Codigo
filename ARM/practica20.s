@ Escribir el código ARM que ejecutado bajo ARMSim# encuentre e imprima el menor elemento
@ de un vector, donde el vector está especificado con el label vector y la longitud del vector con
@ el label long_vector.

.global _start
.equ SWI_fin_prog, 0x11
.equ SWI_imp_ente, 0x6b
.equ Stdout, 1

.data
    vector:     .word 94, 46, 44, 69, 25, 8, 3, 78, 100
    longVector: .word 9

.text
_start:
    ldr   r2, =vector
    ldr   r4, [r2]
    ldr   r3, =longVector
    ldr   r3, [r3]

sacarMinimo:
    bl    verificarMinimo
    add   r2, r2, #4
    subs  r3, r3, #1
    bne   sacarMinimo
    b     fin

verificarMinimo:
    stmfd sp!, {r0, lr}
    ldr   r0, [r2]
    cmp   r0, r4
    movmi r4, r0
    ldmfd sp!, {r0, pc}

fin:
    ldr   r0, =Stdout
    mov   r1, r4
    swi   SWI_imp_ente
    swi   SWI_fin_prog