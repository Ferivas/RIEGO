'Main.bas
'
'                 WATCHING Soluciones Tecnológicas
'                    Fernando Vásquez - 25.06.15
'
' Programa para almacenar los datos que se reciben por el puerto serial a una
' memoria SD
'

$version 0 , 1 , 116
$regfile = "m2560def.dat"
$crystal = 16000000
$hwstack = 80
$swstack = 80
$framesize = 80
$baud = 9600

$projecttime = 115


'Declaracion de constantes
Const Numprog = 4                                           'nUMERO DE PROGRAMAS
Const Numprog_masuno = Numprog + 1
Const Numhorariego = 4
Const Numhorariego_masuno = Numhorariego + 1                'Horas deriego por programa
Const Numhoras = Numprog * Numhorariego                     'Horas de riego para configurar
Const Numsec = 8
Const Numsec_masuno = Numsec + 1                            'Número de seceuncias por horario  de riego
Const Numsecriego = Numsec * Numhorariego * Numprog


Const Nleds = 4
Const Nleds_masuno = Nleds + 1

Const Ds3231r = &B11010001                                  'DS3231 is very similar to DS1307 but it include a precise crystal
Const Ds3231w = &B11010000

Const Numtxaut = 4
Const Numtxaut_mas_uno = Numtxaut + 1

Const Numadc = 2
Const Numadc_masuno = Numadc + 1
Const Numsample = 8
Const Tsample = 1

'HT
Const Tsampleht = 5


'Configuracion de entradas/salidas
Led1 Alias Portc.0
Config Led1 = Output

Led2 Alias Portc.1
Config Led2 = Output
Led3 Alias Portc.2
Config Led3 = Output

Ledsta Alias Portb.7                                        'LED ROJO
Config Ledsta = Output


'Configuración de Interrupciones
'TIMER0
Config Timer0 = Timer , Prescale = 1024                     'Ints a 100Hz si Timer0=184
On Timer0 Int_timer0
Enable Timer0
Start Timer0

Config Timer1 = Timer , Prescale = 1024
On Timer1 Int_timer1
Enable Timer1
Start Timer1

' Puerto serial 1
Open "com1:" For Binary As #1
On Urxc At_ser1
Enable Urxc

Dim Dummy As Byte
Config Clock = User
Config Date = Dmy , Separator = /

$lib "i2c_twi.lbx"
Config Sda = Portd.1
Config Scl = Portd.0
Config I2cdelay = 5
Config Twi = 400000

'Dim Lcd_auto As Byte

'Lcd_auto = 1

$lib "glcdSSD1306-I2C.lib"
'$lib "glcdSSD1306-I2C-BUF.lib"
Config Graphlcd = Custom , Cols = 128 , Rows = 64 , Lcdname = "SSD1306"

Enable Interrupts


'*******************************************************************************
'* Archivos incluidos
'*******************************************************************************
$include "RIEGO_archivos.bas"



'Programa principal
Estado_led(4) = 4
Call Vercfg()
Call Inivar()
Estado_led(4) = 3


Print #1 , "MEGARTC"
Cls
Showpic 0 , 0 , Pic
Wait 1
Cls
Setfont Font8x8tt
Lcdat 1 , 1 , "**  MEGA 2020 **"
Lcdat 3 , 1 , Version(1)
Lcdat 5 , 1 , Version(2)
Lcdat 7 , 1 , Version(3)

Print #1 , "Verifica CLK"
Estado_led(4) = 3
Do
   Call Leer_rtc()
Loop Until Actclk = 1

Estado_led(4) = 1

Print #1 , "Main"
Wait 1
Cls


Do

   If Sernew = 1 Then                                       'DATOS SERIAL 1
      Reset Sernew
      Print #1 , "SER1=" ; Serproc
      Call Procser()
   End If

   If Newsec = 1 Then
      Reset Newsec
      Incr K1
      Tmpstr52 = Date$
      Tmpstr52 = Tmpstr52 + " " + Time$ + " "
      Lcdat 1 , 1 , Tmpstr52
      Diasemana = Dayofweek()
      If Diasemana <> Diasemanaant Then
         Diasemanaant = Diasemana
         Tmpstr52 = Lookupstr(diasemana , Tbl_semana)
         Print #1 , "Dia " ; Diasemana ; "," ; Tmpstr52
      End If
   End If

   If Inisecuencia = 1 Then
      Print #1 , "Ini Sec"
      Reset Inisecuencia
      Print #1 , "Fin Sec"
   End If

   If Inivariables = 1 Then
      Reset Inivariables
      Call Inivar()
   End If


Loop