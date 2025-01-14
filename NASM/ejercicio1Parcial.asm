global main
extern printf
extern gets
extern sscanf
extern fopen
extern fread
extern fclose

section .data
    ;Definiciones del archivo binario
    nombreArchivo     db "eles.dat",0
    modoArchivo       db "rb",0
    msjErrorAbrirArch db "Hubo un error al abrir el archivo eles.dat",0
    ;Registro del archivo
    registro  times 0 db "" ;Sirve como buffer para leer datos de un archivo
    fila      times 2 db 0
    columna   times 2 db 0
    altura    times 2 db 0
    longitud  times 2 db 0
    ;Matriz
    matriz  times 225 dw 0 ;Una matriz de 15x15=225 words que contiene puro 0
    longitudElementoM dw 2
    dimensionM        dw 15

section .bss
    fileHandle      resq 1
    esValid         resb 1

section .text
main:
    call abrirArch

    cmp  qword[fileHandle], 0
    jle  errorAbrirArchivo

    call leerArchivo
    
abrirArch:
    mov  rdi, nombreArchivo
    mov  rsi, modoArchivo
    call fopen
    mov  [fileHandle], rax
    ret

leerArchivo:

leerRegistro:
    mov  rdi, registro
    mov  rsi, 8                ;fila(2bytes), columna(2bytes), altura(2bytes),longitud(2bytes)
    mov  rdx, qword[registro]
    call fread

    cmp  rax, 0
    jle  eof

    call VALREG
    cmp  byte[esValid], "s"
    jne  leerArchivo

    call asignarEles

eof:
    mov  rdi,qword[fileHandle]
    call fclose
    ret

VALREG:
    mov byte[esValid], "s"

validarFilaYColumna:
    ;Validación de fila
    cmp  word[fila],0
    jle  datosInvalidos
    cmp  word[fila],15
    jg   datosInvalidos
    ;Validación de columna
    cmp  word[columna],0
    jle  datosInvalidos
    cmp  word[columna],15
    jg   datosInvalidos

validarAltura:
    mov  ax, word[fila]
    add  ax, 1             ;En el caso sea la fila 2, la máxima altura es 2 asi, pero si hago la resta entre los dos me va a dar una fila invalida.
    sub  ax, word[altura]
    cmp  ax, 0
    jle  datosInvalidos

validarLongitud:
    mov  ax, word[columna]
    sub  ax, 1
    add  ax, word[longitud]   
    cmp  ax, 15
    jg   datosInvalidos

finValidar:
    ret

datosInvalidos:
    mov  byte[esValid], "n"
    jmp  finValidar

asignarEles:
    
calcularPosicion:
    mov  ax, word[fila]
    sub  ax, 1
    imul word[longitudElementoM]
    imul word[dimensionM]
    mov  bx, ax
    mov  ax, word[columna]

    

errorAbrirArchivo:
    mov  rdi, msjErrorAbrirArch
    sub  rax, rax
    call printf
