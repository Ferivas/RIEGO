'Main.bas
'
'                 WATCHING Soluciones Tecnológicas
'                    Fernando Vásquez - 25.06.15
'
' Programa para almacenar los datos que se reciben por el puerto serial a una
' memoria SD
'

$version 0 , 1 , 322
$regfile = "m2560def.dat"
$crystal = 16000000
$hwstack = 128
$swstack = 128
$framesize = 128
$baud = 9600

$projecttime = 384


'Declaracion de constantes
Const Numprog = 4                                           'nUMERO DE PROGRAMAS
Const Numprog_masuno = Numprog + 1
Const Numhorariego = 16
Const Numhorariego_masuno = Numhorariego + 1                'Horas deriego por programa
Const Numhoras = Numprog * Numhorariego                     'Horas de riego para configurar
Const Numsec = 8
Const Numsec_masuno = Numsec + 1                            'Número de seceuncias por horario  de riego
Const Numsecriego = Numsec * Numhorariego * Numprog

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

Const Ednum = 4
Const Ednum_1 = Ednum - 1
Const Ednum_masuno = Ednum + 1
Const Numbuf = 8

Const Numrelaux = 3
Const Numrelaux_masuno = Numrelaux + 1



'Configuracion de entradas/salidas
Led1 Alias Portb.7
Config Led1 = Output


'VALVULAS TEMPORIZADAS
'Config Portc = Output

Ev1 Alias Portc.0
Config Ev1 = Output
Ev2 Alias Portc.1
Config Ev2 = Output
Ev3 Alias Portc.2
Config Ev3 = Output
Ev4 Alias Portc.3
Config Ev4 = Output
Ev5 Alias Portc.4
Config Ev5 = Output
Ev6 Alias Portc.5
Config Ev6 = Output

Evriego Alias Portc.6
Config Evriego = Output
Evozono Alias Portc.7
Config Evozono = Output
Evnebul Alias Portl.0
Config Evnebul = Output
Evrecirc Alias Portl.1
Config Evrecirc = Output
Evluzev Alias Portl.2
Config Evluzev = Output

Relaux1 Alias Portb.1
Config Relaux1 = Output
Relaux2 Alias Portb.2
Config Relaux2 = Output
Relaux3 Alias Portb.3
Config Relaux3 = Output

Dht_put Alias Portb.0 : Set Dht_put                         'Sensor pins
Dht_get Alias Pinb.0
Dht_io_set Alias Ddrb.0 : Set Dht_io_set

Esp32rst Alias Portd.7
Set Esp32rst
Config Esp32rst = Output

Ed0 Alias Pina.0
Ed1 Alias Pina.1
Ed2 Alias Pina.2
Ed3 Alias Pina.3

Config Ed0 = Input
Config Ed1 = Input
Config Ed2 = Input
Config Ed3 = Input

Set Porta.0
Set Porta.1
Set Porta.2
Set Porta.3


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

'Timer2
Config Timer2 = Timer , Prescale = 1024                     'Ints a 100Hz si Timer0=&H64
On Timer2 Int_timer2
Enable Timer2
Start Timer2

' Puerto serial 1
Open "com1:" For Binary As #1
On Urxc At_ser1
Enable Urxc

Config Com2 = 9600 , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8 , Clockpol = 0
Open "com2:" For Binary As #3
On Urxc1 At_ser2
Enable Urxc1

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
Estado_led = 4
Call Vercfg()
Call Inivar()
Estado_led = 3


Print #1 , "MEGARTC"
Cls
'Showpic 0 , 0 , Pic
'Wait 1
'Cls
Setfont Font8x8tt
Lcdat 1 , 1 , "**  RIEGO 2025 **"
Lcdat 3 , 1 , Version(1)
Lcdat 5 , 1 , Version(2)
Lcdat 7 , 1 , Version(3)

Print #1 , "Verifica CLK"
Estado_led = 3
Do
   Call Leer_rtc()
Loop Until Actclk = 1

Estado_led = 1

Print #1 , "Main"
Wait 1
Cls


Do

   If Sernew = 1 Then                                       'DATOS SERIAL 1
      Reset Sernew
      Print #1 , "SER1=" ; Serproc
      Call Procser()
   End If

   If Rpinew = 1 Then
      Reset Rpinew
      Print#1 , "RPItx>" ; Rpiproc
      Call Procrpi()
   End If

   Call Leered()
   Ptrtx = Ptrtx Mod Numbuf
   Incr Ptrtx

   If Tx_buf(ptrtx) = 1 Then
      Print #1 , "Ptrtx=" ; Ptrtx
      Tx_buf(ptrtx) = 0
      Call Gentrama()
      Set Iniauto.2
   End If

   If Newsec = 1 Then
      Reset Newsec
      Incr K1
      Call Data2disp()
      Tmpstr52 = Date$
      Tmpstr52 = Tmpstr52 + " " + Time$ + " "
      Lcdat 1 , 1 , Tmpstr52
      Diasemana = Dayofweek()
      If Diasemana <> Diasemanaant Then
         Diasemanaant = Diasemana
         Tmpstr52 = Lookupstr(diasemana , Tbl_semana)
         Print #1 , "Dia " ; Diasemana ; "," ; Tmpstr52
         Habdiaria = Habdiasemtmp.diasemana
         Print #1 , "HabDiaria=" ; Habdiaria
      End If
      Call Verackesp32()
   End If

   If Tx_buf(ptrtx) = 1 Then
      Print #1 , "Ptrtx=" ; Ptrtx
      Tx_buf(ptrtx) = 0
      Call Gentrama()
      Set Iniauto.2
   End If

   If Iniauto.0 = 1 Then
      Reset Iniauto.0
      Print #1 , "TXAUT1"
      Call Txauto(1)

   End If

   If Iniauto.1 = 1 Then
      Reset Iniauto.1
      Print #1 , "TXAUT2"
      Call Txauto(2)

   End If

   If Iniauto.2 = 1 Then
      Reset Iniauto.2
      Print #1 , "TXAUT3"
      Call Txauto(3)

   End If

   If Iniauto.3 = 1 Then
      Reset Iniauto.3
      Print #1 , "TXAUT4"
   End If

   If Iniactclk = 1 Then
      Reset Iniactclk
      Print #1 , "ACT CLK"
      Atsnd = "GETNTP,1,2,3"
      Tmpw = Len(atsnd)
      Tmpcrc32 = Crc32(atsnd , Tmpw)
      Atsnd = Atsnd + "&" + Hex(tmpcrc32)                   '+ Chr(10)
      Print #1 , "%" ; Atsnd
      Print #3 , "%" ; Atsnd
   End If

   If Iniack = 1 Then                                       'ACK MDC
      Reset Iniack
      Atsnd = "ACK,1,2,3"
      Tmpw = Len(atsnd)
      Tmpcrc32 = Crc32(atsnd , Tmpw)
      Atsnd = Atsnd + "&" + Hex(tmpcrc32) + Chr(10)
      Print #1 , "$" ; Atsnd
      Print #3 , "$" ; Atsnd
      Call Txrpi()
   End If

   If Sndnumprg = 1 Then
      Reset Sndnumprg
      Atsnd = "LEEPRG," + Str(enaprog) + ",3,4"
      Tmpw = Len(atsnd)
      Tmpcrc32 = Crc32(atsnd , Tmpw)
      Atsnd = Atsnd + "&" + Hex(tmpcrc32)                   '+ Chr(10)
      Print #1 , "%" ; Atsnd
      Print #3 , "%" ; Atsnd
   End If


   If Inivariables = 1 Then
      Reset Inivariables
      Call Inivar()
   End If

   If Inisampleht = 1 Then
      Reset Inisampleht
      Call Get_humidity()
      If Enabug.3 = 1 Then
         Print #1 , "H=" ; Humidity ; " , T=" ; Temperature
      End If
   End If

   If Iniriegooff <> Iniriegooffant Then
      Iniriegooffant = Iniriegooff
      If Iniriegooff = 1 Then
         Print #1 , "INI espera en OFF " ; Time$
      Else
         Print #1 , "FIN espera en OFF " ; Time$
      End If

   End If

   If Edsta(3) = 1 Then                                     'Modo Automático
      If Edsta(3) <> Edsta3ant Then
         Edsta3ant = Edsta(3)
         Print #1 , "Edsta(3)=" ; Edsta(3)
         Print #1 , "AUTO"
         Call Resetreles()
         Set Modo
      End If

      If Edsta(1) = 0 Then                                  'Prueba nivel para recirculación
         Set Evrecirc
         Set Evluzev
      End If

      If Edsta(1) = 1 Then
         Reset Evrecirc
         Reset Evluzev

      End If

      If Edsta(2) = 0 Then
         Reset Evnebul
         Reset Ininebul
         Reset Ininebulon
         Reset Ininebuloff
         Reset Firstnebulon
      End If

      If Edsta(2) = 1 Then
         Set Ininebul
         If Firstnebulon = 0 Then
            Set Ininebulon
            'Print #1 , "Ininebulon=1"
            Set Firstnebulon
         End If
      End If

      If Ininebulon = 1 Then
         Set Evnebul
      End If

      If Ininebulonant <> Ininebulon Then
         Ininebulonant = Ininebulon
         Print #1 , "Ininebulon=" ; Ininebulon
         Set Iniauto.2
      End If

      If Ininebuloff = 1 Then
         Reset Evnebul
      End If

      If Ininebuloffant <> Ininebuloff Then
         Ininebuloffant = Ininebuloff
         Print #1 , "IninebuloFF=" ; Ininebuloff
         Set Iniauto.2
      End If

      If Habdiaria = 1 Then
         If Iniciclo = 1 Then
            If Iniciclo <> Inicicloant Then
               Inicicloant = Iniciclo
               Print #1 , "Ini Ciclo de Riego " ; Ptrciclo
               Set Inisecuencia
               Set Newsecuencia
               Ptrsecuencia = 0
               'Set Evriego
               'Set Evozono
            End If

            If Newsecuencia = 1 Then
               Reset Newsecuencia
               Print #1 , "SEC=" ; Ptrsecuencia ; "," ; Time$
               Call Outreles(enaprog , Ptrciclo , Ptrsecuencia)
               Set Iniauto.0
               Incr Ptrsecuencia
               Ptrsecuencia = Ptrsecuencia Mod Numsec
               If Ptrsecuencia > 6 Then
                  Reset Evriego
                  Reset Evozono
               End If
               'Ptrsecuencia = Ptrsecuencia Mod 6
               If Ptrsecuencia = 0 Then
                  Reset Iniciclo
                  Inicicloant = Iniciclo
                  Print #1 , "FIN Ciclo"
                  Call Resetreles()
                  Reset Evriego
                  Reset Evozono
                  Reset Inisecuencia
                  Cntrticks = 0
               End If
            End If
         End If
      End If
   Else
      If Edsta(3) <> Edsta3ant Then
         Edsta3ant = Edsta(3)
         Print #1 , "Edsta(3)=" ; Edsta(3)
         Print #1 , "MANUAL"
         Call Setreles()
         Set Iniauto.0
         Reset Modo
         Reset Evriego
         Reset Evozono
         Reset Evnebul
         Reset Evrecirc
         Reset Evluzev
      End If
   End If


Loop