.global _start
.equ SWI_fin_prog, 0x11
.equ SWI_print, 0x02

.data
cadena1: .asciz "Hola!"
cadena2: .asciz "chan"

.text
_start:
    ldr   r9,=cadena1
    bl    printStr
    ldr   r9,=cadena2
    bl    printStr

    swi   SWI_fin_prog

printStr:
    stmfd sp!,{r0,lr}
    mov   r0,r9
    swi   SWI_print
    ldmfd sp!,{r0,pc}