;Realizar un programa en assembler Intel x86 que imprima por pantalla la siguiente
;frase: “El alumno [Nombre] [Apellido] de Padrón N° [Padrón] tiene [Edad] años para
;esto se debe solicitar previamente el ingreso por teclado de:
; *Nombre y Apellido
; *N° de Padrón
; *Fecha de nacimiento
global main
extern puts
extern printf
extern gets
extern sscanf


section .data
    msjPeticion       db "Ingrese los siguientes datos del alumno.",0
    msjPedirApellido  db "Apellido: ",0
    msjPedirNombre    db "Nombre: ",0
    msjPedirPadron    db "Padrón: ",0
    msjPedirFechaNac  db "Fecha de Nacimiento (dd mm aaaa): ",0
    formatoApellido   db "%s",0
    formatoNombre     db "%s",0
    formatoPadron     db "%i",0
    formatoFechaNac   db "%hhi %i %hi",0
    msjErrorPadron    db "No ingresó correctamente el Padrón N° nnnnnnnn.",0
    msjErrorPadronInv db "El padrón ingresado es invalido.",0
    msjErrorFechaNac  db "No ingresó correctamente la fecha de nacimiento dd mm aaaa.",0
    msjErrorFechaNacI db "La fecha ingresada es invalida",0
    cantDiasMesAnioB  db 31,29,31,30,31,30,31,31,30,31,30,31
    cantDiasMesAnioN  db 31,28,31,30,31,30,31,31,30,31,30,31
    msjResultado      db "El alumno %s %s de Padrón N° %i tiene %hi años",10,0
    diaActual         db 23
    mesActual         db 7
    anioActual        dw 2021

section .bss
    apellido        resb 50
    nombre          resb 50
    padron          resd 1
    diaNacimiento   resb 1
    mesNacimiento   resd 1
    anioNacimiento  resw 1
    edad            resw 1

    entradaApellido resb 50
    entradaNombre   resb 50
    entradaPadron   resb 10
    entradaFechaNac resb 12

section .text
main:
    sub  rsp,8
    ;Imprimo la solicitud de datos
    mov  rdi,msjPeticion
    call puts

solicitarApeYNom:
    ;Solicito y recibo apellido y nombre del alumno
    mov  rdi,msjPedirApellido
    sub  rax,rax
    call printf

    mov  rdi,entradaApellido
    call gets

    mov  rdi,msjPedirNombre
    sub  rax,rax
    call printf

    mov  rdi,entradaNombre
    call gets
    
validarApeYNom:
    ;Escaneo los datos con sscanf
    mov  rdi,entradaApellido
    mov  rsi,formatoApellido
    mov  rdx,apellido
    call sscanf
    ;Escaneo los datos con sscanf
    mov  rdi,entradaNombre
    mov  rsi,formatoNombre
    mov  rdx,nombre
    call sscanf
    jmp  solicitarPadron

errorIngresoPadron:
    mov  rdi,msjErrorPadron
    call puts
    jmp  solicitarPadron

errorPadronInvalido:
    mov  rdi,msjErrorPadronInv
    call puts

solicitarPadron:
    ;Solicito y recibo el padrón del alumno
    mov  rdi,msjPedirPadron
    sub  rax,rax
    call printf

    mov  rdi,entradaPadron
    call gets

validarPadron:
    ;Escaneo los datos con sscanf
    mov  rdi,entradaPadron
    mov  rsi,formatoPadron
    mov  rdx,padron
    call sscanf
    ;Verifico que se haya ingresado un numero
    cmp  rax,1
    jl   errorIngresoPadron
    ;Verifico si esta en el rango de un padrón
    cmp  dword[padron],99999999
    jg   errorPadronInvalido
    cmp  dword[padron],0
    jl   errorPadronInvalido
    jmp  solicitarFechaNac

errorIngresoFechaNac:
    mov  rdi,msjErrorFechaNac
    call puts
    jmp  solicitarFechaNac

errorFechaNacInvalido:
    mov  rdi,msjErrorFechaNacI
    call puts

solicitarFechaNac:
    ;Solicito y reibo la fecha de nacimiento del alumno
    mov  rdi,msjPedirFechaNac
    sub  rax,rax
    call printf

    mov  rdi,entradaFechaNac
    call gets

validarFechaNac:
    ;Escaneo los datos con sscanf
    mov  rdi,entradaFechaNac
    mov  rsi,formatoFechaNac
    mov  rdx,diaNacimiento
    mov  rcx,mesNacimiento
    mov  r8,anioNacimiento
    call sscanf
    ;Verifico que se haya ingresado 3 numeros
    cmp  rax,3
    jl   errorIngresoFechaNac
    ;Verifico si la fecha es valida
    ;Verifico si el año es valido
    mov  ax,[anioActual]
    cmp  word[anioNacimiento],ax
    jg   errorFechaNacInvalido
    ;Verifico si el mes es valido
    cmp  dword[mesNacimiento],0
    jle  errorFechaNacInvalido
    cmp  dword[mesNacimiento],12
    jg   errorFechaNacInvalido
    ;Verifico si el dia es menor a 0,invalido
    cmp  byte[diaNacimiento],0
    jle  errorFechaNacInvalido
    ;Verifico si el año es bisiesto
    mov  dx,0
    mov  ax,[anioNacimiento]
    mov  r8w,4 ;Pongo un 4 inmediato en el registro general r8w
    idiv r8w   ;para utilizarlo como dividendo.
    mov  ebx,[mesNacimiento] ;Calulo la posición del vector
    dec  ebx                 ;cantDiaMesAñoX segun el mes.
    cmp  dx,0
    je   validarDiaEnAnioBisiesto
    ;Verifico que el dia sea valido para un año no bisiesto
    mov  ah,[cantDiasMesAnioN+ebx]
    cmp  byte[diaNacimiento],ah
    jg   errorFechaNacInvalido
    jmp  calcularEdad
    
validarDiaEnAnioBisiesto:
    mov  ah,[cantDiasMesAnioB+ebx]
    cmp  byte[diaNacimiento],ah
    jg   errorFechaNacInvalido

calcularEdad:
    mov  ax,[anioActual]
    sub  ax,[anioNacimiento]
    mov  [edad],ax
    mov  ah,[mesActual]
    cmp  [mesNacimiento],ah
    jl   finPrograma
    cmp  [mesNacimiento],ah
    jg   restarEdad
    mov  ah,[diaActual]
    cmp  [diaNacimiento],ah
    jle  finPrograma

restarEdad:
    dec  word[edad]

finPrograma:
    mov  rdi,msjResultado
    mov  rsi,apellido
    mov  rdx,nombre
    mov  rcx,[padron]
    mov  r8,[edad]
    sub  rax,rax
    call printf

    add  rsp,8
ret