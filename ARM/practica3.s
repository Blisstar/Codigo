@Escribir el código ARM que ejecutado bajo ARMSim# realice las siguientes operaciones
@aritméticas y lógicas sobre dos números cargados en memoria: Suma, Resta, Multiplicación,
@AND, OR, XOR, Shift Izquierda, Shift Derecha, Shift Derecha Aritmética. Dejar el resultado de
@las operaciones en los registros del R2 al R10.
.global _start
.equ SWI_fin_prog, 0x11

.data

.text
_start:
    mov r0, #-2           @ r0 = numero1
    mov r1, #7            @ r1 = numero2
    
    add r2, r0, r1        @ r2 = r0 + r1

    sub r3, r1, r0        @ r3 = r1 - r0
    rsb r4, r0, r1        @ r4 = r1 - r0
    
    mul r5, r0, r1        @ r5 = r0 * r1

    and r6, r0, r1        @ r6 = and(r0, r1)
    eor r7, r0, r1        @ r7 = exclusiveOr(r0, r1)
    orr r8, r0, r1        @ r8 = or(r0, r1)

    mov r9, r1, lsl #1    @ r9 = shiftLSL(r1)
    mov r10, r9, lsr #1   @ r10 = shiftLSR(r9)
    mov r11, r0, asr #1   @ r11 = shiftASR(r0)

    swi SWI_fin_prog