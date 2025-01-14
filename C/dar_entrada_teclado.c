#include "dar_entrada_teclado.h"
#include <stdio.h>

extern int dar_entrada_teclado(char *entrada_teclado, int longitud){
    fgets(entrada_teclado, longitud, stdin);
    return 0;
}