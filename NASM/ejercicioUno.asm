;Escribir un programa que imprima por pantalla "Organización del Computador".
global main
extern puts

section .data
    nombreMateria db "Organización del Computador",0

section .text
main:
    mov rdi,nombreMateria
    call puts