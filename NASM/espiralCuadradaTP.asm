global main
extern printf
extern puts
extern gets
extern sscanf
extern fopen
extern fread
extern fclose

section .data
    ;Mensajes de la descripción del programa
    descripcionPrograma             db "Se considera una espiral cuadrada que parte del origen de coordenadas y toca consecutivamente",10,"los puntos (1,0), (1,1), (0,1), (-1,1), (-1,0), (-1,-1), (0,-1), (1,-1), (2,-1), etc.. De esta manera todos los",10,"puntos de coordenadas enteras pertenecen a la espiral. Partiendo del punto inicial (0,0), dichos puntos",10,"son numerados en forma consecutiva con los enteros no negativos 0, 1, 2, 3, 4, ... etc..",0
    ;Mensajes de las opciones del programa
    opcion0                         db "Sea n un número entero no negativo elegir una de las siguientes opciones:",0
    opcion1                         db "  1) Determinar las coordenadas de un punto de la espiral considerada, numerado por n.",0
    opcion2                         db "  2) Determinar n, correspondiente a un punto de coordenadas enteras (X, Y).",10,"     Para n <= 100.",0
    opcion3                         db "  3) Dados 2 puntos, indicar la distancia entre ambos (cantidad de puntos que hay entre uno y otro",10,"     Ej: entre (1,1) y (-1,1) hay distancia 3).",0
    peticionOpcion                  db "Ingrese la opción deseada : ",0
    ;Mensajes de error
    msjErrorIngresoOpcion           db "La opción que ingresó es invalida.",0
    msjErrorIngresoEne              db "La n que ingresó es invalida.",0
    msjErrorIngresoPunto            db "Las coordenadas del punto que ingresó son invalidas.",0
    ;Formatos
    formatoOpcionYEne               db "%li",0
    formatoPunto                    db "%li %li",0
    ;Mensajes de la ejecución de la opcion 1
    peticionEne                     db "Ingrese n: ",0
    resultadoOpcion1                db "Las coordenadas correspondientes al n solicitado son: (X , Y) = (%li , %li)",10,0
    ;Mensajes de la ejecución de la opción 2
    peticionPunto                   db "Ingrese las coordenadas enteras de un punto (X Y): ",0
    resultadoOpcion2                db "El n correspondiente al punto de coordenadas enteras es: n = %li",10,0
    ;Mensajes de la ejecución de la opción 3
    peticionDosPuntos               db  "Indique el punto %li mediante su:",10,0
    opcion31                        db  "1) Par de coordenadas enteras.",0
    opcion32                        db  "2) n correspondiente.",0
    resultadoOpcion3                db  "La distancia entre los dos puntos indicados es: %li",10,0
    ;Datos
    eneIngresadaAC                  dq -1
    coordenadas             times 2 dq 0
    coordenadasIngresadasAC times 2 dq 9223372036854775807    ;El número que esta guardado en el caso de que no se pidan coordenadas es el es el valor máximo para un entero con signo de 64 bits. Fuente: de los deseos
    contador                        dq 1
    esIgual                         db "n"
    nmrPunto                        dq 1


section .bss
    entradaOpcionYEne      resb 25
    opcionIngresada        resq 1

    entradaPunto           resb 50

    eneIngresada1          resq 1
    coordenadasIngresadas1 resq 2

    ene                    resq 1

    plusRsp                resq 1

section .text
main:
    mov  rdi, descripcionPrograma
    call puts

    call pedirOpcion
    call ejecutarOpcion

    ret

errorIngresoOpcion:
    mov  rdi, msjErrorIngresoOpcion
    call puts

pedirOpcion:
    mov  rdi, opcion0
    call puts

    mov  rdi, opcion1
    call puts

    mov  rdi, opcion2
    call puts

    mov  rdi, opcion3
    call puts

    mov  rdi, peticionOpcion
    sub  rax, rax
    call printf

    mov  rdi, entradaOpcionYEne
    call gets

    call escanearOpcion

validarOpcion:
    cmp  rax, 1
    jl   errorIngresoOpcion

    cmp  qword[opcionIngresada], 1
    jl   errorIngresoOpcion

    cmp  qword[opcionIngresada], 3
    jg   errorIngresoOpcion

    ret

escanearOpcion:
    mov  rdi, entradaOpcionYEne
    mov  rsi, formatoOpcionYEne
    mov  rdx, opcionIngresada
    call checkAlign
    sub  rsp, [plusRsp]
    call sscanf
    add  rsp, [plusRsp]

    ret

ejecutarOpcion:
    cmp  qword[opcionIngresada],1
    je   llamarOpcion1

    cmp  qword[opcionIngresada],2
    je   llamarOpcion2

    cmp  qword[opcionIngresada],3
    je   llamarOpcion3

llamarOpcion1:
    call ejecutarOpcion1
    ret

llamarOpcion2:
    call ejecutarOpcion2
    ret

llamarOpcion3:
    call ejecutarOpcion3
    ret

ejecutarOpcion1:
    call pedirEne
    call calcularPunto

    mov  rdi, resultadoOpcion1
    mov  rsi, qword[coordenadas]
    mov  rdx, qword[coordenadas+8]
    sub  rax, rax
    call printf
    
    ret

errorIngresoEne:
    mov  rdi, msjErrorIngresoEne
    call puts

pedirEne:
    mov  rdi, peticionEne
    sub  rax, rax
    call printf

    mov  rdi, entradaOpcionYEne
    call gets

escanearEne:
    mov  rdi, entradaOpcionYEne
    mov  rsi, formatoOpcionYEne
    mov  rdx, eneIngresadaAC
    call checkAlign
    sub  rsp, [plusRsp]
    call sscanf
    add  rsp, [plusRsp]

validarEne:
    cmp  rax, 1
    jl   errorIngresoEne

    cmp  qword[eneIngresadaAC], 0
    jl   errorIngresoEne

    ret

calcularPunto:

comprobarIgualCero:
    mov  rdx, 1
    mov  rax, 0
    
    mov  qword[coordenadas], 0
    mov  qword[coordenadas+8], 0

    call comprobarIgualdad
    cmp  byte[esIgual],"s"
    je   finCalculo

operarCoordenadas:
    mov  rcx, qword[contador]

operarEnX:
    add  qword[coordenadas], rdx
    inc  rax
    call comprobarIgualdad
    cmp  byte[esIgual],"s"
    je   finCalculo
    loop operarEnX
    mov  rcx, qword[contador]

operarEnY:
    add  qword[coordenadas+8], rdx
    inc  rax
    call comprobarIgualdad
    cmp  byte[esIgual],"s"
    je   finCalculo
    loop operarEnY

prepararIteracion:
    inc  qword[contador]
    not  rdx
    inc  rdx
    jmp  operarCoordenadas

finCalculo:
    mov  byte[esIgual],"n"
    mov  qword[contador],1
    ret

comprobarIgualdad:
    cmp  rax, qword[eneIngresadaAC]
    je   cumpleIgualdad
    mov  rbx, qword[coordenadas]
    cmp  rbx, qword[coordenadasIngresadasAC]
    je   xIgual
    ret

xIgual:
    mov  rbx, qword[coordenadas+8]
    cmp  rbx, qword[coordenadasIngresadasAC+8]
    je   cumpleIgualdad
    ret

cumpleIgualdad:
    mov  byte[esIgual], "s"
    ret

ejecutarOpcion2:
    call pedirPunto
    call calcularPunto

    mov  rdi, resultadoOpcion2
    mov  rsi, rax
    sub  rax, rax
    call printf

    ret

errorIngresoPunto:
    mov  rdi, msjErrorIngresoPunto
    call puts

pedirPunto:
    mov  rdi, peticionPunto
    sub  rax, rax
    call printf

    mov  rdi, entradaPunto
    call gets

escanearPunto:
    mov  rax, coordenadasIngresadasAC
    add  rax, 8
    mov  rdi, entradaPunto
    mov  rsi, formatoPunto
    mov  rdx, coordenadasIngresadasAC
    mov  rcx, rax
    call checkAlign
    sub  rsp, [plusRsp]
    call sscanf
    add  rsp, [plusRsp]

validarPunto:
    cmp  rax, 2
    jl   errorIngresoPunto

    ret

ejecutarOpcion3:
    call pedirDosPuntos
    call calcularDistancia

    mov  rdi, resultadoOpcion3
    mov  rsi, rax
    sub  rax, rax
    call printf

    ret

llamarPeticionCoord:
    call pedirPunto
    cmp  qword[nmrPunto], 1
    je   almacenarCoordYEne

    ret

llamarPeticionEne:
    call pedirEne
    cmp  qword[nmrPunto], 1
    je   almacenarCoordYEne
    
    ret

almacenarCoordYEne:
    mov  rax, qword[eneIngresadaAC]
    mov  qword[eneIngresada1], rax

    mov  rax, qword[coordenadasIngresadasAC]
    mov  qword[coordenadasIngresadas1], rax

    mov  rax, qword[coordenadasIngresadasAC+8]
    mov  qword[coordenadasIngresadas1+8], rax

    mov  qword[eneIngresadaAC], -1
    mov  rax, 9223372036854775807
    mov  qword[coordenadasIngresadasAC], rax
    mov  qword[coordenadasIngresadasAC+8], rax

    inc  qword[nmrPunto]

pedirDosPuntos:
    call pedirOpcion3

    cmp  qword[opcionIngresada], 1
    je   llamarPeticionCoord

    cmp  qword[opcionIngresada], 2
    je   llamarPeticionEne

errorIngresoOpcion3:
    mov  rdi, msjErrorIngresoOpcion
    call puts

pedirOpcion3:
    mov  rdi, peticionDosPuntos
    mov  rsi, qword[nmrPunto]
    sub  rax, rax
    call printf

    mov  rdi, opcion31
    call puts

    mov  rdi, opcion32
    call puts

    mov  rdi, peticionOpcion
    sub  rax, rax
    call printf

    mov  rdi, entradaOpcionYEne
    call gets

    call escanearOpcion

validarOpcion3:
    cmp  rax, 1
    jl   errorIngresoOpcion3

    cmp  qword[opcionIngresada], 1
    jl   errorIngresoOpcion3

    cmp  qword[opcionIngresada], 2
    jg   errorIngresoOpcion3

    ret

calcularDistancia:
    call calcularPunto
    
    mov  qword[ene], rax

    mov  rax, qword[eneIngresada1]
    mov  qword[eneIngresadaAC], rax

    mov  rax, qword[coordenadasIngresadas1]
    mov  qword[coordenadasIngresadasAC], rax

    mov  rax, qword[coordenadasIngresadas1+8]
    mov  qword[coordenadasIngresadasAC+8], rax

    call calcularPunto

    sub  rax, qword[ene]

    cmp  rax, 0
    jge  sumarUno

    not  rax
    inc  rax

sumarUno:
    inc  rax
    
    ret

;----------------------------------------
;----------------------------------------
; ****	checkAlign ****
;----------------------------------------
;----------------------------------------
checkAlign:
	push rax
	push rbx
;    push rcx
	push rdx
	push rdi

	mov   qword[plusRsp],0
	mov		rdx,0

	mov		rax,rsp		
	add     rax,8		;para sumar lo q restó la CALL 
	add		rax,32	;para sumar lo que restaron las PUSH
	
	mov		rbx,16
	idiv	rbx			;rdx:rax / 16   resto queda en RDX

	cmp     rdx,0		;Resto = 0?
	je		finCheckAlign
;mov rdi,msj
;call puts
	mov   qword[plusRsp],8
finCheckAlign:
	pop rdi
	pop rdx
;    pop rcx
	pop rbx
	pop rax
	ret