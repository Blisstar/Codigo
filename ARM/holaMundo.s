.global _start
.data
cadena: .asciz "Hola Mundo ARM!"

.text
_start:
    ldr  r0,=cadena      @cargo dir de cadena en registro 0
    swi  0x02            @llamo a la interrupcion 2/Imprimir en stdout

    swi  0x11            @llamo a la interrupcion 11/Fin de programa
.end