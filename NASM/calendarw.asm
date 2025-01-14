global main
extern printf
extern gets
extern sscanf
extern fopen
extern fread
extern fclose

section .data
    ;Definiciones del archivo binario
    nombreArchivo     db "CALEN.dat",0
    modo              db "rb",0
    msjErrorAbrirArch db "Hubo un error al abrir el archivo CALEN.dat",0
    ;Registro del archivo
    registro times 0  db "" ;Sirve como buffer para leer datos de un archivo
    dia      times 2  db "" ;El 2 porque son 2 bytes
    semana            db 0 
    descrip  times 20 db "" ;Para guardar la descripcion de la actividad, que son 20 bytes
    ;Matriz
    matriz   times 42 dw 0  ;Una matriz de 6x7=42 words que contiene puro 0
    dias              db "DOLUMAMIJUVISA"
    msjSemana         db "Ingrese la Semana [1,6]: ",0
    numFormat         db "%li",0
section .bss
    fileHandle      resq 1
    esValid         resb 1
    contador        resq 1
    diaBin          resb 1
    numIngresado    resd 1

section .text
main:
    call abrirArch

    cmp  qword[fileHandle],0
    jle  errorAbrirArchivo

    call leerArchivo
    call listarCantActividades

abrirArch:
    mov  rdi,nombreArchivo
    mov  rsi,modo
    call fopen
    mov  [fileHandle],rax
    ret

leerArchivo:

leerRegistro:
    mov  rdi,registro
    mov  rsi,23       ;Dia(2bytes),Semana(1byte),Descripcion(20bytes)
    mov  rdx,qword[fileHandle]
    call fread

    cmp  rax,0
    jle  eof

    call  VALCAL
    cmp   byte[esvalid],"s"
    jne   leerRegistro

    call  sumarActividad

    jmp   leerRegistro

eof:
    mov  rdi,qword[fileHandle]
    call fclose
    ret

VALCAL:
    mov  rbx,0    ;Utilizo rbx como puntero al vector dias
    mov  rcx,7    ;
    mov  rax,0    ;inicializo el rax en 0

compDia:
    inc  rax      ;sumo en cada iteración para obtener el numero binario
    mov  qword[contador],rcx ;resguardo el rcx en la variable contador
    mov  rcx,2    ;le indico al cmpsb que compare a 2 bytes
    lea  rsi,[dia]
    lea  rdi,[dias+rbx]
    repe cmpsb 
    mov  rcx,qword[contador] ;recupero el rcx para el lopp
    je   diaValido
    add  rbx,2     ;Avanzo en el vector de dias

    loop compDia
    jmp  invalido

diaValido:
    mov  byte[diaBin],al
    cmp  byte[semana],1
    jl   invalido
    cmp  byte[semana],6 
    jg   invalido

finValidar:
    mov byte[esValid],"s"
    ret

invalido:
    mov  byte[esValid],"n"
    jmp  finValidar

sumarActividad:
    ;Desplazamiento de una matriz
    ;(col-1)*L+(fil-1)*L*cantColu
    ;[Desplazamiento Columnas]+[Desplazamiento Filas]
    mov  rax,0

    sub  byte[diaBin],1     ;col-1
    mov  al,byte[diaBin]    

    mov  bl,2
    mul  bl                 ;*2

    mov  rdx,rax            ;rdx=(col-1)*L

    sub  byte[semana],1     ;fil-1
    mov  al,byte[semana]

    mov  bl,14              
    mul  bl                 ;*(2*7)

    add  rax,rdx

    mov  bx,word[matriz + rax]
    inc  bx
    mov  word[matriz + rax],bx
    
    ret

listarCantActividades:

ingresoSemana:
    mov  rdi,msjSemana
    sub  rax,rax
    call printf

    mov  rdi,buffer
    call gets

    mov  rdi,buffer
    mov  rsi,numFormat
    mov  rdx,numIngresado
    call gets
    
    cmp  dword[numIngresado],1
    jl   ingresoSemana

    cmp  dword[numIngresado],6
    jg   ingresoSemana

    sub  dword[numIngresado],1

    mov  rax,0
    mov  eax,dword[numIngresado]

    mov  bl,14
    mul  bl

    mov  ;falta codigo    
finPrograma:
    ret

errorAbrirArchivo:
    mov  rdi,msjErrorAbrirArch
    sub  rax,rax
    call printf
