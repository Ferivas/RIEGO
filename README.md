# RIEGO
Control de Riego para Jardín Hidropónico

## COMPONENTES DEL SISTEMA
### RELES PARA CONTROL DE ELECTROVALVULAS TEMPORIZADAS
Nominadas desde EV1 hasta EV6 se activan secuencialmente durante un tiempo de accionamiento configurable (minutos) y se permanecen apagadas por un tiempo de espara. Tambien es posible agrupar electroválvulas para el accionamiento simultáneo (Ejem: se accionan al mismo tiempo EV1+EV2+EV3 luego EV4+EV5+EV6)
### RELE PARA ENCENDIDO/APAGADO DE BOMBA DE RIEGO (P. Riego)
Se acciona simultáneamente durante los tiempos de accionamiento del ciclo de riego completo de las 6 electroválvulas, definido en el punto anterior.
### RELE PARA ENCENDIDO/APAGADO DE GENERADOR DE OZONO
Este relé puede operar en dos modos:
#### Modo automático
En este modo se acciona simultáneamente durante los tiempos de accionamiento del ciclo de riego completo de las 6 electroválvulas temporizadas
#### Modo manual
Se enciende/apaga con accionamiento desde un interruptor
### RELE PARA ENCENDIDO/APAGADO DE BOMBA DE NEBULIZACION 
Se tienen dos modos de operación:
#### Modo automático
Se acciona por un tiempo programabale en segundos , en fución de puntos de configuración de temperatura y humedad del ambiente.  Esta bomba se activa por intervalos de tiempo programables (t1: ON / t2: ESPERA) y debe repetir t1+t2 hasta q la entrada informe que la humedad a entrado en el rango aceptable)
#### Modo manual
A tráves de un pulsador se acciona por un tiempo programable en segundos
### RELE PARA ENCENDIDO/APAGADO DE BOMBA DE RECIRCULACION
#### Modo Automático
Recibe señales de un relé de nivel para el encendido y apagado
#### Modo manual
Se enciende/apaga al accionar un interruptor
### RELE PARA ENCENDIDO/APAGADO DE LUZ UV 
#### Modo Automático
Se acciona simultáneamente con la bomba de recirculación
#### Modo Manual
Se enciende/apaga al accionar un switch
### RELES ADICIONALES 
Se accionan durante tiempos programables (segundos) de manera independiente.
Su activación debe ser remota a través de la web.
### SENSOR DE HUMEDAD TEMPERATURA
Permite leer datos de humeda/temperatura ambiental
### ENTRADAS
* Contactos secos del Relé de nivel 
* Contactos secos de sensor de HUmedad Temperatura

## OPERACION MODO MANUAL
En el modo manual se activan los relés de las válvulas EV1, EV2, EV3, EV4, EV5, EV6.<br>
Los demás relés se desactivan a excepción de los relés auxiliares que mantienen su último estado.

## OPERACION MODO AUTOMATICO
El Sistema de Riego se puede programar con 4 programas de riego que permiten activar secuencialmente las electroválvulas temporizadas en secuencias que se pueden configurar para cada programa. Una secuencia incluye un tiempo de accionamiento durante el cual se activan los relés que se han configurado y luego un tiempo de espera en el cual se apagan todos los relés hasata ejecutar una nueva secuencia. Solo un programa puede estar activo a la vez.<br>
En cada programa de riego se pueden configurar 16 horas de inicio de un ciclo de riego. Una ciclo de riego activa secuencialmente las electroválvulas en grupos. Una ciclo de riego puede tener hasta 8 secuencias de activación. En cada secuencia de activación se pueden activar/desactivar uno o más electroválvulas temporizadas activando/desactivando bits en los registros de de activación de secuencias de una hora de inicio de un ciclo re riego.<br>
Por ejemplo se puede configurar un ciclo de riego para que se activen las electrovávulas individualmente y en secuencia si los bits de los registros de activación de las secuencia de la hora de inicio se configuran de la siguiente manera:
* SEC1 : 00000001
* SEC2 : 00000010
* SEC3 : 00000100
* SEC4 : 00001000
* SEC5 : 00010000
* SEC6 : 00100000
* SEC7 : 00000000
* SEC8 : 00000000

El bit menos significativo (bit0) corresponde a la electroválvula temporizada 1 , el bit 1 corresponde a la electroválvula temporizada 2 y así sucesivamente.<br>
Esto permite escoger muchas combinaciones para configurar activaciones de grupo de electroválvulas según los requerimientos que se necesiten. Por ejemplo si se necesita que una secuencia de riego active las electrovávulas en grupos de dos los registros de secuencia se pueden configurar de la siguiente manera<br>
* SEC1 : 00000011
* SEC2 : 00001100
* SEC3 : 00110000
* SEC4 : 00000000
* SEC5 : 00000000
* SEC6 : 00000000
* SEC7 : 00000000
* SEC8 : 00000000

En resumen se tienen 4 Programas de Riego, que se ejecutan diariamente si están habilitados. Cada programa permite configurar 16 horarios de riego y en cada hoarario es posible establecer hasta 8 secuencias de riego para las electoválvulas.

<img width="800" alt="Registros Riego" src="https://github.com/Ferivas/RIEGO/blob/main/DOCS/Registros_Riego.jpg">

### SELECCION DE PROGRAMA DE RIEGO
Para seleccionar el programa de riego se utiliza el comando <br>
*SETPRG,NumPrograma*<br>
En donde Numprograma puede variar de 0 a 4 para escoger el programa requerido. Si se escoge 0 de deshabilitan todos los programaas de riego. Por ejemplo si se envía el comando<br>
*SETPRG,2*<br>
se habilita el programa de riego número 2.

### CONFIGURACION DE HORA DE INICIO DE UN PROGRAMA DE RIEGO
Para seleccionar la hora de inicio de un programa de riego es necesario utilizar el siguiente comando:<br>
*SETHRI,NumPrograma,NumHoraInicio;HoraInicio*<br>
en donde:
* NumPrograma corresponde al número de programa de riego (varía entr 1 y 4)
* NumHoraInicio corresponde al horario de inicio de un ciclo de riego (varía entre 1 y 16)
* Hora Inicio corresponde a la hora que se requiere configurar(hora, minuto, segundo)

Por ejemplo si se necesita configurar el ciclo de riego 2 del programa de riego número 1 a las 08h30 es necesario utilizar el siguiente comando:<br>
*SETHRI,1,2,08:30:00*

### CONFIGURACION DE SECUENCIA DE RIEGO
Para cada hora de inicio de un ciclo de riego se pueden configurar hasta 8 secuencias de riego que activan/desactivan las electroválvulas temporizadas.
El comando para activar una secuencia individual es le siguiente:<br>
*SETSEC,NumPrograma,NumHoraInicio,NumSecuencia,HGFEDCBA*<br>
En donde:
* NumPrograma corresponde al número de programa de riego (varía entr 1 y 4)
* NumHoraInicio corresponde al horario de inicio de un ciclo de riego (varía entre 1 y 16)
* NumSecuencia indica el número de secuencia que se va a configurar
* HGFEDCBA  corresponden a los bits del registro de configuración de secuencia que pueden ser 1 o 0
Por ejemplo si es necesario activar las electroválvulas temporizadas 1 y 3 de la secuencia 2 del hoarario de inicio de ciclo de riego 4 del Número de Programa 3, el comando que se debe enviar es el siguiente: <br>
*SETSEC,3,4,2,00000101* <br>

### CONFIGURACION DE TIEMPO DE ACCIONAMIENTO
El tiempo de accionamiento de una secuencia en un ciclo de riego se configura con el comando <br>
*SETTRI,TiempoAccionamiento* <br>
En donde el Tiempo de Accionamiento están en segundos y puede variar entre 1 y 65535 segundos. Por ejemplo para accionar un tiempo de 5 minutos es necesario configurar el tiempo a 5*60segundos=300 con el siguiente comando:<br>
*SETTRI,300*

### CONFIGURACION DE TIEMPO DE ESPERA EN SECUENCIA
El tiempo de espera de una secuencia en un ciclo de riego se configura con el comando <br>
*SETTRO,TiempoEspera* <br>
En donde el Tiempo de Espera están en segundos y puede variar entre 1 y 65535 segundos. Por ejemplo para accionar un tiempo de 15 minutos es necesario configurar el tiempo a 15*60segundos=900 con el siguiente comando:<br>
*SETTRO,900*

### CONFIGURACION VIA PUERTO SERIAL
Los parámetros de operación del sistema de riego se pueden configurar utilizando un terminal serial configurado a 9600 bps (8,N,1). Todos los comandos se envían con un caracter $ de inicio y CR+LF al  final.

## HARDWARE
El circuito de control de riego se armo en un tablero de control que incluye:
* Mainboard de Control Principal
* Módulo de Comunicaciones
* Módulo de Relés
* Cableado desde/hacia las electroválvulas
* Interruptores

El control de las electroválvulas se realizó según el siguiente esquema <br>
<img width="600" alt="Esquema Conexiones" src="https://github.com/Ferivas/RIEGO/blob/main/DOCS/ControlReles.jpg">

Este circuito se montó en un tablero de control cuyo interior se muestra en la figura siguiente: <br>
<img width="600" alt="Interior Tablero" src="https://github.com/Ferivas/RIEGO/blob/main/DOCS/TableroControl_Interior.jpg">

El exterior del circuito de control es le siguiente:<br>
<img width="600" alt="Exterior Tablero" src="https://github.com/Ferivas/RIEGO/blob/main/DOCS/TableroControl_Exterior.jpg">

## CONEXIONES TARJETA MAINBOARD

Los elementos de la tajeta Mainboard se coenctan como se muestra en la figura siguiente:

<img width="600" alt="Mainboard" src="https://github.com/Ferivas/RIEGO/blob/main/DOCS/Mainboardconexi%C3%B3n.jpg">

La fuente para el módulo de relés se conecta como se muestra a continuación:

<img width="600" alt="Fuente Relé" src="https://github.com/Ferivas/RIEGO/blob/main/DOCS/Conexi%C3%B3nFuenteRel%C3%A9s.jpg">

Las entradas digitales se coenctan con la bornera de 5 pines.

<img width="600" alt="Entradas" src="https://github.com/Ferivas/RIEGO/blob/main/DOCS/Conexi%C3%B3n_ED.jpg">

## ESTADO POR DEFECTO DE LAS ENTRADAS DIGITALES
Para las entradas digitales se considera lo siguiente.
### Relé de Nivel de la Bomba de Circulación 
* Contactos cerrados implica que hay agua en le tanque y se puede activar la bomna de recirculación.<br>
* Contactos abiertos indican que no hay agua en el tanque y se apaga la bomba de recirculación
### Relé de Alarma de Humedad
* Contactos cerrados implica que lo niveles de humedad son correctos y no se activa la bomba de nebulización<br>
* Contactos abiertos indican que la humeda no es la adecuada y que debe encenderse periodicamente la bomba de nebulización (Secuencias de Ton y Toff)
### Interruptor de Modo de de operación
* Contactos cerrados indican operación en modo manual para mantenimiento<br>
* Contactos abiertos indican operación en modo automático

## CONFIGURACION DE LA RED WIFI
Si el módulo de comunicaciones no encuentra una red que tenga guardada se convierte en un punto de acceso WiFi, al cual puede el usuario conectarse.<br>
Esta red es *RIEGO2025* y la contraseña para acceder a la misma es *riego2025* <br>

Una vez conectado a esta red (se recomienda desconectar el móvil de la red de datos LTE de la operadora móvil), es necesario que le usuario ingrese a la dirección

192.168.4.1

en el navegador móvil. En esta página se puede ver las redes WiFI disponibles. Se selecciona la que se requiera y se ingresa la contraseña. 











