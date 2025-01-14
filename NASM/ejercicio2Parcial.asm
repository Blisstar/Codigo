global main
extern printf
extern gets
extern sscanf
extern fopen
extern fread
extern fclose

section .data
    ;Definiciones del archivo binario
    nombreArchivo              db "vacunacion.dat",0
    modoArchivo                db "rb",0
    msjErrorAbrirArch          db "Hubo un error al abrir el archivo eles.dat",0
    ;Registro del archivo
    registro           times 0 db "" 
    dni                times 4 db 0   
    codProvResidencia          db 0   ; de 1 a 24
    edad                       db 0
    ;Matriz
    matriz            times 96 dd 0   ;Una matriz de 24*4=96 dwords que contiene puro 0
    columna                    dw 0
    ;Mensajes de peticion de datos
    msjPedirCodProvRes         db "Ingrese un codigo de provincia [de 1 a 24]: ",0
    msjPedirPoblacion          db "Ingrese la poblacion total de la misma: ",0
    ;Formatos
    formatCodProvRes           db "%li",0
    formatPoblacion            db "%li",0
    ;otros
    poblacionVacunada          dd 0
    msjResultado               db "La provincia %s tiene mas del 50% de vacunados.",0

section .bss
    fileHandle               resq 1
    esValid                  resb 1
    codProvResIngresado      resb 50
    poblacionIngresada       resb 50
    codProvRes               resq 1
    poblacion                resq 1
    resultado                resb 1

section .text
main:
    call abrirArch

    cmp  qword[fileHandle], 0
    jle  errorAbrirArchivo

    call leerArchivo

    call analizarPoblacionVacunada

    ret
    
abrirArch:
    mov  rdi, nombreArchivo
    mov  rsi, modoArchivo
    call fopen
    mov  [fileHandle], rax
    ret

leerArchivo:

leerRegistro:
    mov  rdi, registro
    mov  rsi, 6                ;dni(4bytes), codigo de provicia de residencia(1byte), edad(1byte)
    mov  rdx, qword[registro]
    call fread

    cmp  rax, 0
    jle  eof

    call VALREG
    cmp  byte[esValid], "s"
    jne  leerRegistro

    call completarM

    jmp  leerRegistro

eof:
    mov  rdi,qword[fileHandle]
    call fclose
    ret

VALREG:
    mov byte[esValid], "s"

validarCodProvResidencia:
    cmp  dword[codProvResidencia],0
    jle  datosInvalidos
    cmp  dword[codProvResidencia],24
    jg   datosInvalidos

validarAltura:
    cmp  word[edad],35
    jl   datosInvalidos

finValidar:
    ret

datosInvalidos:
    mov  byte[esValid], "n"
    jmp  finValidar

completarM:

determinarColumna:
    mov  word[columna], 4
    cmp  byte[edad], 40
    jl   primerColumna
    cmp  byte[edad], 50
    jl   segundaColumna
    cmp  byte[edad], 60
    jl   tercerColumna
    jmp  añadoPersonaAM

primerColumna:
    mov  word[columna], 1
    jmp  añadoPersonaAM

segundaColumna:
    mov  word[columna], 2
    jmp  añadoPersonaAM

tercerColumna:
    mov  word[columna],3

añadoPersonaAM:
    mov  al, byte[codProvResidencia]
    sub  al, 1
    mov  dl, 4
    mul  dl
    mul  dl

    add  rbx, rax

    mov  al, byte[columna]
    sub  al, 1
    mul  dl

    add  rbx, rax

    mov  edx, dword[matriz+rbx]
    inc  edx
    mov  dword[matriz+rbx], edx

    ret

analizarPoblacionVacunada:

pedirDatos:   
    mov  rdi, msjPedirCodProvRes
    call printf

    mov  rdi, codProvResIngresado
    call gets

    mov  rdi, msjPedirPoblacion
    call printf

    mov  rdi, poblacionIngresada
    call gets

escanearDatos:
    mov  rdi, codProvResIngresado
    mov  rsi, formatCodProvRes
    mov  rdx, codProvRes
    call sscanf

    cmp  rax,1
    jl   pedirDatos

    mov  rdi, poblacionIngresada
    mov  rsi, formatPoblacion
    mov  rdx, poblacion
    call sscanf

    cmp  rax,1
    jl   pedirDatos

    mov  rcx, 4

sumarCantVacunadosProv:
    mov  rax, qword[codProvRes]
    sub  rax, 1
    mov  rdx, 4
    imul rdx
    imul rdx

    mov  rbx, rax

    mov  rax, rcx
    sub  rax, 1
    imul rdx

    add  rbx, rax

    mov  eax, dword[poblacionVacunada]
    add  eax, dword[matriz+rbx]

    loop sumarCantVacunadosProv

determinarResultado:
    mov  rax, poblacion
    mov  rcx, 2
    idiv rcx

    ret

imprimirResultado:

errorAbrirArchivo:
    mov  rdi,msjErrorAbrirArch
    call printf