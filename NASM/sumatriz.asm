global main
extern printf
extern puts
extern gets

section .data
    msjPedirFilCol db "Ingrese fila (1 a 5) y columna (1 a 5): ",10,0 ;el 10 es para aplicar /n(fin de linea) y el 0 es para indicar el fin de la cadena
    msjSumatoria db "La sumatoria es : %i"10,0 ; el %i es un número entero con signo base 10 de 32 bits
    formatoValidoFilCol db "%hi %hi"
    matriz dw 1,1,1,1,1
           dw 2,2,2,2,2
           dw 3,3,3,3,3
           dw 4,4,4,4,4
           dw 5,5,5,5,5

section .bss
    fila resw 1
    columna resw 1
    entradaEsValida resb 1 ; 'S' Valido  'N' Invalido
    sumatoria resd 1
    entradaFilCol resb 50 

section .text
main:
pedirDatos:
    mov rdi,msjIngFilCol ;Preparación para usar el printf y sin corchetes porque quiero mandar la direccion inicial a printf
    call printf

    mov rdi,entradaFilCol
    call gets

    call validarEntrada

    cmp byte[entradaEsValida],'N'
    je pedirDatos

    call calcDesplaz

    call calcSumatoria

    mov rdi,msjSumatoria
    mov esi,dword[sumatoria]
    call printf

ret

validarEntrada:
    mov byte[entradaEsValida],'N'

    mov rdi,entradaFilCol
    mov rsi,formatoValidoFilCol
    mov rdx,fila
    mov rcx,columna
    call sscanf

    cmp rax,2
    jl invalido

    cmp word[fila],1
    jl invalido
    cmp word[fila],5
    jg invalido

    cmp word[columna],1
    jl invalido
    cmp word[columna],5
    jg invalido

invalido:
    ret

calcDesplaz:
    ;Cálculo de desplazamiento hasta llegar (fila,col) de la matriz
    ; [(fila-1)*longFila] +[(columna-1)*longElemento]
    ; longFila = longElemento *cantidadColumnas
    mov bx,word[fila]
    sub bx,1
    imul bx,bx,10

    mov word[desplazamiento],bx

    mov bx,word[columna]
    sub bx,1
    imul bx,bx,2

    add word[desplazamiento],bx

    ret

calcSumatoria:
    mov dword[sumatoria],0

    mov rcx,0
    mov cx,6
    sub cx,word[columna]

    mov rbx,0
    mov bx,word[desplazamiento]

    mov rax,0
    mov ax,word[matriz + rbx]

    add dword[sumatoria],eax

    add rbx,2

    loop sumarSgte

    ret;le falta codigo a ese archivo
