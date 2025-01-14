global main
extern printf

section .data
    esPositivo db "El número %li es %s",10,0
    positivo   db "positivo",0
    negativo   db "negativo",0
    numero     dq 1
section .text
main:
    mov  rdi,esPositivo
    mov  rsi,[numero]
    mov  rdx,positivo
    cmp  qword[numero],0
    jl   esNegativo
    call mostrarResultado
ret
esNegativo:
    mov rdx,negativo
mostrarResultado:
    sub rax,rax
    call printf
ret


