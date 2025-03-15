# RIEGO
Control de Riego para Jardín Hidropónico

## COMPONENTES DEL SISTEMA
## RELES PARA CONTROL DE ELECTROVALVULAS TEMPORIZADAS
Nominadas desde EV1 hasta EV6 se activan secuencialmente durante un tiempo de accionamiento configurable (minutos). Tambien es posible agrupar electroválvulas para el accionamiento simultáneo (Ejem: se accionan al mismo tiempo EV1+EV2+EV3 luego EV4+EV5+EV6)
## RELE PARA ENCENDIDO/APAGADO DE BOMBA DE RIEGO (P. Riego)
Se acciona simultáneamente durante los tiempos de accionamiento del ciclo de riego completo de las 6 electroválvulas, definido en el punto anterior.
## RELE PARA ENCENDIDO/APAGADO DE GENERADOR DE OZONO
Este relé puede operar en dos modos:
### Modo automático
En este modo se acciona simultáneamente durante los tiempos de accionamiento del ciclo de riego completo de las 6 electroválvulas temporizadas
### Modo manual
Se enciende/apaga con accionamiento desde un interruptor
## RELE PARA ENCENDIDO/APAGADO DE BOMBA DE NEBULIZACION 
Se tienen dos modos de operación:
### Modo automático
Se acciona por un tiempo programabale en segundos , en fución de puntos de configuración de temperatura y humedad del ambiente.  Esta bomba se activa por intervalos de tiempo programables (t1: ON / t2: ESPERA) y debe repetir t1+t2 hasta q la entrada informe que la humedad a entrado en el rango aceptable)
### Modo manual
A tráves de un pulsador se acciona por un tiempo programable en segundos
## RELE PARA ENCENDIDO/APAGADO DE BOMBA DE RECIRCULACION
### Modo Automático
Recibe señales de un relé de nivel para el encendido y apagado
### Modo manual
Se enciende/apaga al accionar un interruptor
## RELE PARA ENCENDIDO/APAGADO DE LUZ UV 
### Modo Automático
Se acciona simultáneamente con la bomba de recirculación
### Modo Manual
Se enciende/apaga al accionar un switch
## RELES ADICIONALES 
Se accionan durante tiempos programables (segundos) de manera independiente.
Su activación debe ser remota a través de la web.
## SENSOR DE HUMEDAD TEMPERATURA
Permite leer datos de humeda/temperatura ambiental
## ENTRADAS
* Conatactos secos del Relé de nivel 
* Contactos secos de sensor de HUmedad Temperatura
* 













