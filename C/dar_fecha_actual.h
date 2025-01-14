//Para obtener la fecha y hora actual de acuerdo con el tiempo local en C necesitaremos tres funciones, time, localtime y strftime. La primera, time, recibirá como parámetro un puntero nulo (es decir, NULL o 0) y devolverá el tiempo actual en una variable de tipo "time_t".
//A continuación averiguaremos el tiempo local con la función localtime que recibe por parámetro un puntero a una variable time_t. Esta función devuelve un puntero hacia una estructura de tipo tm, que es la que utilizaremos en strftime.
//Por último, la función strftime formatea una estructura de tipo tm a un formato legible por cualquier persona. El primer parámetro es una cadena, el segundo la longitud de esta cadena, el tercero la cadena de formateo y por último la estructura que contiene el tiempo que queremos formatear. En la siguiente tabla puedes ver los códigos de formateo de fechas con strftime.

// %a	Es reemplazado por la abreviatura del nombre del día de la semana de la localidad
// %A	Es reemplazado por el nombre completo del día de la semana de la localidad
// %b	Es reemplazado por la abreviatura del nombre del mes de la localidad
// %B	Es reemplazado por el nombre completo del mes de la localidad
// %c	Es reemplazado por la fecha apropiada y la representación de la hora de la localidad
// %d	Es reemplazado por el día del mes como un número decimal (01-31)
// %H	Es reemplazado por la hora (reloj de 24 horas) como un número decimal (00-23)
// %I	Es reemplazado por la hora (reloj de 12 horas) como un número decimal (01-12)
// %j	Es reemplazado por el día del año como un número decimal (001-366)
// %m	Es reemplazado por el mes como un número decimal (01-12)
// %M	Es reemplazado por el minuto como un número decimal (00-59)
// %p	Es reemplazado por el equivalente de la localidad de las designaciones de AM/PM asociadas con un reloj de 12 horas
// %S	Es reemplazado por el segundo como un número decimal (00-61)
// %U	Es reemplazado por el número de la semana del año (el primer Domingo como el primer día de la semana 1) como un número decimal (00-53)
// %w	Es reemplazado por el día de la semana como un número decimal (0-6), donde Domingo es 0
// %W	Es reemplazado por el número de la semana del año (el primer Lunes como el primer día de la semana 1) como un número decimal (00-53)
// %x	Es reemplazado por la representación apropiada de la fecha de la localidad
// %X	Es reemplazado por la representación apropiada de la hora de la localidad
// %y	Es reemplazado por el año sin siglo como un número decimal (00-99)
// %Y	Es reemplazado por el año con siglo como un número decimal
// %Z	Es reemplazado por el nombre o la abreviatura del huso horario, o por ningunos caracteres si ningún huso horario es determinable
// %%	Es reemplazado por %
int dar_fecha_actual(char *fecha_actual);