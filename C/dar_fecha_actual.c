#include "dar_fecha_actual.h"
#include <stdio.h>
#include <time.h>

int dar_fecha_actual(char *fecha_actual) {
    time_t tiempo = time(0);
    struct tm *tlocal = localtime(&tiempo);
    strftime(fecha_actual,11,"%d/%m/%Y",tlocal);
    return 0;
}
