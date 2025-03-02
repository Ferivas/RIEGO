'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
'*  SD_Archivos.bas                                                        *
'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
'*                                                                             *
'*  Variables, Subrutinas y Funciones                                          *
'* WATCHING SOLUCIONES TECNOLOGICAS                                            *
'* 25.06.2015                                                                  *
'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

$nocompile
$projecttime = 257


'*******************************************************************************
'Declaracion de subrutinas
'*******************************************************************************
Declare Sub Inivar()
Declare Sub Procser()
'RTC
Declare Sub Getdatetimeds3231()
Declare Sub Setdateds3231()
Declare Sub Settimeds3231()
Declare Sub Leer_rtc()
Declare Sub Defaultvalues()
Declare Sub Vercfg()
Declare Sub Leeidserial()
Declare Sub Inihorainicio()

'*******************************************************************************
'Declaracion de variables
'*******************************************************************************
Dim Tmpb As Byte , Tmpb2 As Byte , Tmpb3 As Byte , Tmpb4 As Byte
Dim J As Byte , K As Byte , K1 As Byte , N As Byte
Dim Tmpl As Long
Dim Tmpw As Word , Tmpw2 As Word

Dim Cmdtmp As String * 6
Dim Atsnd As String * 200
Dim Cmderr As Byte
Dim Tmpstr8 As String * 16
Dim Tmpstr52 As String * 52

Dim Cfgokeep As Eram Byte
Dim Cfgok As Byte
Dim Inivariables As Bit
Dim Idserial As String * 22

'RTC
Dim Dow As Byte
Dim Actclk As Bit
Dim Fechaed As String * 10
Dim Horaed As String * 10
Dim Horamin As Long
Dim Horamineep As Eram Long


'TEMPORIZADOR
Dim Ptrsec As Byte
Dim Enaprog As Byte                                         'hAB DE PROGRAMAS DE RIEGO
Dim Enaprogeep As Eram Byte
Dim Habdiasem(numprog) As Byte                              'Habilitación día de semana por prgrama
Dim Habdiasemeep(numprog) As Eram Byte
Dim Horariego(numhoras) As Long
Dim Horariegoeep(numhoras) As Eram Long
Dim Tiemporiego As Word
Dim Tiemporiegoeep As Eram Word
Dim Secriego(numsecriego) As Byte
Dim Secriegoeep(numsecriego) As Eram Byte
Dim Diasemana As Byte
Dim Diasemanaant As Byte
Dim Horainicio(numhorariego) As Long                        ' Horarios riego iniciales
Dim Timestr As String * 10
Dim Inisecuencia As Bit

'Variables TIMER0
Dim T0c As Byte
Dim Num_ventana As Byte
Dim Estado As Long
Dim Estado_led(nleds) As Byte
Dim Iluminar As Bit
Dim Newsec As Byte
Dim Kt0 As Byte
Dim Cntrseg As Byte

'timer1
Dim Lsyssec As Long
Dim Tmpltime As Long
Dim Tt2 As Byte

'Variables SERIAL0
Dim Ser_ini As Bit , Sernew As Bit
Dim Numpar As Byte
Dim Cmdsplit(34) As String * 20
Dim Serdata As String * 200 , Serrx As Byte , Serproc As String * 200



'*******************************************************************************
'* END public part                                                             *
'*******************************************************************************


Goto Loaded_arch

'*******************************************************************************
' INTERRUPCIONES
'*******************************************************************************

'*******************************************************************************
' Subrutina interrupcion de puerto serial 1
'*******************************************************************************
At_ser1:
   Serrx = Udr

   Select Case Serrx
      Case "$":
         Ser_ini = 1
         Serdata = ""

      Case 13:
         If Ser_ini = 1 Then
            Ser_ini = 0
            Serdata = Serdata + Chr(0)
            Serproc = Serdata
            Sernew = 1
         End If

      Case Is > 31
         If Ser_ini = 1 Then
            Serdata = Serdata + Chr(serrx)
         End If

   End Select

Return


Return

'*******************************************************************************



'*******************************************************************************
' TIMER0
'*******************************************************************************
Int_timer0:
   Timer0 = &H64                                            'Ints a  100.16Hz
   Incr T0c
   T0c = T0c Mod 8
   If T0c = 0 Then
      Num_ventana = Num_ventana Mod 32
      For Kt0 = 1 To Nleds
         Estado = Lookup(estado_led(k) , Tabla_estado)
         Iluminar = Estado.num_ventana
         'Toggle Iluminar
         Select Case Kt0
            Case 1:
               Led1 = Iluminar
            Case 2:
               Led2 = Iluminar
            Case 3:
               Led3 = Iluminar
            Case 4:
               Ledsta = Iluminar
         End Select
      Next
      Incr Num_ventana
   End If
Return

Int_timer1:
   Timer1 = &HC2F7
   Set Newsec
   Lsyssec = Syssec(time$ , Date$)
   Incr Lsyssec
   Time$ = Time(lsyssec)
   Date$ = Date(lsyssec)
   Timestr = Time$
   Tmpltime = Secofday(timestr)
   For Tt2 = 1 To Numhorariego
      If Tmpltime = Horainicio(tt2) Then
         Set Inisecuencia
         'Ptrcomida = Tt2
      End If
   Next

Return


Getdatetime:
Return

Setdate:
Return

Settime:
Return



'*******************************************************************************
' SUBRUTINAS
'*******************************************************************************

'*******************************************************************************
' Inicialización de variables
'*******************************************************************************
Sub Inivar()
   Reset Led1
   Print #1 , "************ LORA-BOMBA ************"
   Print #1 , Version(1)
   Print #1 , Version(2)
   Print #1 , Version(3)

   Estado_led(1) = 0
   Estado_led(2) = 0
   Estado_led(3) = 0
   Estado_led(4) = 1

   Horamin = Horamineep
   Print #1 , "Ultima ACT CLK " ; Date(horamin) ; "," ; Time(horamin)

   For Tmpb = 1 To Numprog
      Habdiasem(tmpb) = Habdiasemeep(tmpb)
      Print #1 , "Hab Dias Semana " ; Tmpb ; "=" ; Bin(habdiasem(tmpb))
   Next

   Print #1 , "Horarios"
   For J = 1 To Numprog
      Print #1 , "Prog " ; J
      For K = 1 To Numhorariego
         Tmpw = J - 1
         Tmpw = Tmpw * 4
         Tmpw = Tmpw + K
         Tmpl = Horariegoeep(tmpw)
         Horariego(tmpw) = Tmpl
         Print #1 , "Hora " ; K ; "=" ; Time(tmpl) ; ",  " ; Tmpw
      Next
   Next

   Print #1 , "Secuencias"

   For J = 1 To Numprog
      Print #1 , "Prog " ; J
      For K = 1 To Numhorariego
         Print #1 , "Horario " ; K
         Tmpw = J - 1
         Tmpw = Tmpw * 32
         Tmpw2 = K - 1
         Tmpw2 = Tmpw2 * 8
         Tmpw = Tmpw + Tmpw2
         For N = 1 To Numsec
            Ptrsec = Tmpw + N
            Secriego(ptrsec) = Secriegoeep(ptrsec)
            Print #1 , "SEC " ; N ; "=" ; Bin(secriego(ptrsec)) ; ", " ; Ptrsec
         Next
      Next
   Next


'   For Tmpb = 1 To Numsecriego
'      Secriego(tmpb) = Secriegoeep(tmpb)
'      Print #1 , "SEC RIEGO" ; Tmpb ; "=" ; Bin(secriego(tmpb))
'   Next

   Tiemporiego = Tiemporiegoeep
   Print #1 , "Tiemporiego=" ; Tiemporiego

   Call Leeidserial()
   Print#1 , "IDser<" ; Idserial ; ">"
   Diasemanaant = 99

   Enaprog = Enaprogeep
   Print #1 , "Prog Actual=" ; Enaprog

   If Enaprog > 0 Then
      If Enaprog < Numprog_masuno Then
         Call Inihorainicio()
      Else
         Enaprog = 0
         Print #1 , "Config Invalida"
      End If

   Else
      Print #1 , "Prog Deshabilitados"
   End If

End Sub

Sub Inihorainicio()
   J = Enaprog
   Print #1 , "Prog " ; J
   For K = 1 To Numhorariego
      Tmpw = J - 1
      Tmpw = Tmpw * 4
      Tmpw = Tmpw + K
      Tmpl = Horariego(tmpw)
      Horainicio(k) = Tmpl
      Print #1 , "Hora inicio " ; K ; "=" ; Time(tmpl) ; ",  " ; Tmpw
   Next

End Sub




Sub Defaultvalues()
   Enaprogeep = 1                                           'Programa Actual 1
   Tiemporiegoeep = 20
   For Tmpb = 1 To Numprog
      Habdiasemeep(tmpb) = &B01111111
   Next

   Tmpstr52 = "06:00:00"
   Horariego(1) = Secofday(tmpstr52)
   Tmpstr52 = "07:00:00"
   Horariego(2) = Secofday(tmpstr52)
   Tmpstr52 = "08:00:00"
   Horariego(3) = Secofday(tmpstr52)
   Tmpstr52 = "09:00:00"
   Horariego(4) = Secofday(tmpstr52)
   Tmpstr52 = "10:00:00"
   Horariego(5) = Secofday(tmpstr52)
   Tmpstr52 = "11:00:00"
   Horariego(6) = Secofday(tmpstr52)
   Tmpstr52 = "12:00:00"
   Horariego(7) = Secofday(tmpstr52)
   Tmpstr52 = "13:00:00"
   Horariego(8) = Secofday(tmpstr52)
   Tmpstr52 = "13:30:00"
   Horariego(9) = Secofday(tmpstr52)
   Tmpstr52 = "14:30:00"
   Horariego(10) = Secofday(tmpstr52)
   Tmpstr52 = "15:30:00"
   Horariego(11) = Secofday(tmpstr52)
   Tmpstr52 = "16:30:00"
   Horariego(12) = Secofday(tmpstr52)
   Tmpstr52 = "17:30:00"
   Horariego(13) = Secofday(tmpstr52)
   Tmpstr52 = "18:30:00"
   Horariego(14) = Secofday(tmpstr52)
   Tmpstr52 = "19:30:00"
   Horariego(15) = Secofday(tmpstr52)
   Tmpstr52 = "20:30:00"
   Horariego(16) = Secofday(tmpstr52)

   For K = 1 To Numhoras
      Horariegoeep(k) = Horariego(k)
   Next

   For J = 1 To Numprog
      Print #1 , "Prog " ; J
      For K = 1 To Numhorariego
         Print #1 , "Horario " ; K
         Tmpw = J - 1
         Tmpw = Tmpw * 32
         Tmpw2 = K - 1
         Tmpw2 = Tmpw2 * 8
         Tmpw = Tmpw + Tmpw2
         For N = 1 To Numsec
            Ptrsec = Tmpw + N
            Tmpb = Lookup(n , Tbl_secdefault)
            Secriego(ptrsec) = Tmpb
            Secriegoeep(ptrsec) = Tmpb
            Print #1 , "SEC " ; N ; "=" ; Bin(secriego(ptrsec)) ; ", " ; Ptrsec
         Next
      Next
   Next


End Sub


Sub Vercfg()
   Print #1 , "Verificar Config. Inicial"
   Cfgok = Cfgokeep
   Tmpb2 = 0
   'Estado_led = 12
   Do
      If Sernew = 1 Then                                    'DATOS SERIAL 1
         Reset Sernew
         Print #1 , "SER1=" ; Serproc
         Call Procser()
      End If
      If Newsec = 1 Then
         Reset Newsec
         Incr Tmpb
         Incr Tmpb2
         Tmpb = Tmpb Mod 10
         If Tmpb = 0 Then
            Print #1 , "Ingrese valores de configuracion"
         End If
      End If
   Loop Until Cfgok = 1                                     'Cfgok = 1
   Print #1 , "CONFIG. INICIAL OK"
   'Estado_led = 1

End Sub

'*******************************************************************************
' LEE ID SERIAL DEL CHIP
'*******************************************************************************

 Sub Leeidserial()
   Tmpb = 0
   Tmpb2 = 0
   Do
      Idserial = ""
      For Tmpb = 14 To 23
         Idserial = Idserial + Hex(readsig(tmpb))
      Next
      Atsnd = Idserial
      Idserial = ""
      For Tmpb = 14 To 23
         Idserial = Idserial + Hex(readsig(tmpb))
      Next
      If Idserial = Atsnd Then
         Tmpb = 1
      End If
      Incr Tmpb2
      If Tmpb = 0 Then
         Waitms 500
         Print #1 , "Try " ; Tmpb2
      End If
   Loop Until Tmpb = 1 Or Tmpb2 = 10

 End Sub

'*******************************************************************************
' Procesamiento de comandos
'*******************************************************************************
Sub Procser()
   Print #1 , "$" ; Serproc
   Tmpstr52 = Mid(serproc , 1 , 6)
   Numpar = Split(serproc , Cmdsplit(1) , ",")
'   If Numpar > 0 Then
'      For Tmpb = 1 To Numpar
'         Print #1 , Tmpb ; ":" ; Cmdsplit(tmpb)
'      Next
'   End If

   If Len(cmdsplit(1)) = 6 Then
      Cmdtmp = Cmdsplit(1)
      Cmdtmp = Ucase(cmdtmp)
      Cmderr = 255
      Select Case Cmdtmp
         Case "LEEVFW"
            Cmderr = 0
            Atsnd = "Version FW: Fecha <"
            Tmpstr52 = Version(1)
            Atsnd = Atsnd + Tmpstr52 + ">, Archivo <"
            Tmpstr52 = Version(3)
            Atsnd = Atsnd + Tmpstr52 + ">"

         Case "RSTVAR"
            Cmderr = 0
            Atsnd = "Se configuran variables a valores por defecto"
            Set Inivariables
            Cfgok = 1
            Cfgokeep = Cfgok
            Call Defaultvalues()

         Case "LEERID"
            Cmderr = 0
            Call Leeidserial()
            Atsnd = "ID ser <" + Idserial + ">"

         Case "SETLED"
            If Numpar = 3 Then
               Tmpb = Val(cmdsplit(2))
               If Tmpb > 0 And Tmpb < Nleds_masuno Then
                  Tmpb2 = Val(cmdsplit(3))
                  If Tmpb2 < 17 Then
                     Cmderr = 0
                     Atsnd = "Se configura led" + Str(tmpb) + "=" + Str(tmpb2)
                     Estado_led(tmpb) = Tmpb2
                  Else
                     Cmderr = 6
                  End If
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If


        Case "SETCLK"
            If Numpar = 2 Then
               If Len(cmdsplit(2)) = 12 Then
                  Cmderr = 0
                  Tmpstr52 = Mid(cmdsplit(2) , 7 , 2) + ":" + Mid(cmdsplit(2) , 9 , 2) + ":" + Mid(cmdsplit(2) , 11 , 2)
                  Print #1 , Tmpstr52
                  Time$ = Tmpstr52
                  Print #1 , "T>" ; Time$
                  Tmpstr52 = Mid(cmdsplit(2) , 1 , 2) + "/" + Mid(cmdsplit(2) , 3 , 2) + "/" + Mid(cmdsplit(2) , 5 , 2)
                  Print #1 , Tmpstr52
                  Date$ = Tmpstr52
                  Print #1 , "D>" ; Date$
                  Atsnd = "WATCHING INFORMA. Se configuro reloj en " + Date$ + " a " + Time$
                  Dow = Dayofweek()
                  Call Setdateds3231()
                  Call Settimeds3231()
                  Call Getdatetimeds3231()
                  Horamin = Syssec()
                  Horamineep = Horamin
                  Set Actclk
               Else
                  Cmderr = 6
               End If
            Else
               Cmderr = 4
            End If

         Case "LEERTC"
            Cmderr = 0
            Atsnd = "Lee RTC"
            'Call Getdatetimeds3231()

         Case "SISCLK"
            Cmderr = 0
            Tmpstr52 = Time$
            Atsnd = "Hora actual=" + Tmpstr52 + ", Fecha actual="
            Tmpstr52 = Date$
            Atsnd = Atsnd + Tmpstr52

         Case "LEECLK"
            Cmderr = 0
            Tmpstr52 = Time(horamin)
            Atsnd = "Ultima ACT CLK a =" + Tmpstr52 + ", del "
            Tmpstr52 = Date(horamin)
            Atsnd = Atsnd + Tmpstr52

         Case "SETHRI"                                      ' Configura hora de inicio
            If Numpar = 4 Then
               Tmpb2 = Val(cmdsplit(2))
               If Tmpb2 > 0 And Tmpb2 < Numprog_masuno Then
                  Tmpb = Val(cmdsplit(3))
                  If Tmpb > 0 And Tmpb < Numhorariego_masuno Then
                     Cmderr = 0
                     Tmpstr52 = Cmdsplit(4)
                     'Tmpl = Secofday(tmpstr52)
                     Tmpw = Tmpb2 - 1
                     Tmpw = Tmpw * 4
                     Tmpw = Tmpw + Tmpb
                     Print #1 , "PTR Hri=" ; Tmpw
                     Horariego(tmpw) = Secofday(tmpstr52)
                     Horariegoeep(tmpw) = Horariego(tmpw)
                     Tmpstr52 = Time(horariego(tmpw))
                     Atsnd = "Config Hriego" + Str(tmpb) + " a " + Tmpstr52 + " en PROG " + Str(tmpb2)
                     Call Inihorainicio()
                  Else
                     Cmderr = 6
                  End If
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEEHRI"
            If Numpar = 3 Then
               Tmpb2 = Val(cmdsplit(2))
               If Tmpb2 > 0 And Tmpb2 < Numprog_masuno Then
                  Tmpb = Val(cmdsplit(3))
                  If Tmpb > 0 And Tmpb < Numhorariego_masuno Then
                     Cmderr = 0
                     Tmpw = Tmpb2 - 1
                     Tmpw = Tmpw * 4
                     Tmpw = Tmpw + Tmpb
                     Print #1 , "PTR Hri=" ; Tmpw
                     Tmpstr52 = Time(horariego(tmpw))
                     Atsnd = "Hriego" + Str(tmpb) + " =" + Tmpstr52 + " en PROG " + Str(tmpb2)
                  Else
                     Cmderr = 6
                  End If
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "SETTRI"
            If Numpar = 2 Then
               Tmpb = Val(cmdsplit(2))
               If Tmpb > 0 Then
                  Cmderr = 0
                  Tiemporiego = Tmpb
                  Atsnd = "Se configuro Triego=" + Str(tiemporiego)
                  Tiemporiegoeep = Tiemporiego
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEETRI"
            Cmderr = 0
            Atsnd = "Triego=" + Str(tiemporiego)

         Case "SETSEC"
            If Numpar = 5 Then
               Tmpb2 = Val(cmdsplit(2))                     'Numero de programa
               If Tmpb2 > 0 And Tmpb2 < Numprog_masuno Then
                  Tmpb3 = Val(cmdsplit(3))                  'Horario
                  If Tmpb3 > 0 And Tmpb3 < Numhorariego_masuno Then
                     Tmpb = Val(cmdsplit(4))
                     If Tmpb > 0 And Tmpb < Numsec_masuno Then
                        Tmpw = Tmpb2 - 1
                        Tmpw = Tmpw * 32
                        Tmpw2 = Tmpb3 - 1
                        Tmpw2 = Tmpw2 * 8
                        Tmpw = Tmpw + Tmpw2
                        Tmpw = Tmpw + Tmpb
                        Print #1 , "PTR SEC=" ; Tmpw
                        Tmpb4 = Binval(cmdsplit(5))
                        Secriego(tmpw) = Tmpb4
                        Secriegoeep(tmpw) = Tmpb4
                        Cmderr = 0
                        Atsnd = "Se config SEC " + Str(tmpb) + " de Horario " + Str(tmpb3) + " de Prog " + Str(tmpb2) + "=" + Bin(secriego(tmpw))
                     Else
                        Cmderr = 7
                     End If
                  Else
                     Cmderr = 6
                  End If
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEESEC"
            If Numpar = 4 Then
               Tmpb2 = Val(cmdsplit(2))                     'Numero de programa
               If Tmpb2 > 0 And Tmpb2 < Numprog_masuno Then
                  Tmpb3 = Val(cmdsplit(3))                  'Horario
                  If Tmpb3 > 0 And Tmpb3 < Numhorariego_masuno Then
                     Tmpb = Val(cmdsplit(4))
                     If Tmpb > 0 And Tmpb < Numsec_masuno Then
                        Cmderr = 0
                        Tmpw = Tmpb2 - 1
                        Tmpw = Tmpw * 32
                        Tmpw2 = Tmpb3 - 1
                        Tmpw2 = Tmpw2 * 8
                        Tmpw = Tmpw + Tmpw2
                        Tmpw = Tmpw + Tmpb
                        Print #1 , "PTR LEE SEC=" ; Tmpw
                        Atsnd = "SEC " + Str(tmpb) + " de Horario " + Str(tmpb3) + " de Prog " + Str(tmpb2) + "=" + Bin(secriego(tmpw))
                     Else
                        Cmderr = 7
                     End If
                  Else
                     Cmderr = 6
                  End If
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "SETPRG"
            If Numpar = 2 Then
               Tmpb2 = Val(cmdsplit(2))                     'Numero de programa
               If Tmpb2 > 0 And Tmpb2 < Numprog_masuno Then
                  Cmderr = 0
                  Enaprog = Val(cmdsplit(2))
                  Enaprogeep = Enaprog
                  Atsnd = "Se config Programa Actual a " + Str(enaprog)
                  Call Inihorainicio()
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEEPRG"
            Cmderr = 0
            Atsnd = "Prog Actual=" + Str(enaprog)


         Case Else
            Cmderr = 1

      End Select

   Else
        Cmderr = 2
   End If

   If Cmderr > 0 Then
      Atsnd = Lookupstr(cmderr , Tbl_err)
   End If

   Print #1 , Atsnd

End Sub

Sub Leer_rtc()
   Tmpb = 0
   Reset Actclk
   Do
      If Newsec = 1 Then
         Reset Newsec
         Incr Tmpb
         Print #1 , "Leo RTC " ; Tmpb
         Call Getdatetimeds3231()
         If Err = 0 Then
            Print #1 , "RTC H=" ; Time$ ; ",F=" ; Date$
            Tmpl = Syssec()
            If Tmpl > Horamin Then
               Set Actclk
            Else
               Print #1 , "Hora actual < Horamin, actualice el CLK"
            End If
         Else
            I2cinit
         End If
      End If

      If Sernew = 1 Then                                    'DATOS SERIAL 1
         Reset Sernew
         Print #1 , "SER1=" ; Serproc
         Call Procser()
      End If


   Loop Until Tmpb = 10 Or Actclk = 1
End Sub

'*****************************************************************************
'---------routines I2C for  RTC DS3231----------------------------------------

'*****************************************************************************
Sub Getdatetimeds3231()
  I2cstart                                                  ' Generate start code
  If Err = 0 Then
     I2cwbyte Ds3231w                                       ' send address
     I2cwbyte 0                                             ' start address in 1307
     I2cstart                                               ' Generate start code
     If Err = 0 Then
        I2cwbyte Ds3231r                                    ' send address
        I2crbyte _sec , Ack
        I2crbyte _min , Ack                                 ' MINUTES
        I2crbyte _hour , Ack                                ' Hours
        I2crbyte Dow , Ack                                  ' Day of Week
        I2crbyte _day , Ack                                 ' Day of Month
        I2crbyte _month , Ack                               ' Month of Year
        I2crbyte _year , Nack                               ' Year
        I2cstop
        If Err <> 0 Then
         'Call Error(15)
         Print #1 , "Err getdatetime"
        'End If
        Else
           _sec = Makedec(_sec) : _min = Makedec(_min) : _hour = Makedec(_hour)
           _day = Makedec(_day) : _month = Makedec(_month) : _year = Makedec(_year)
        End If
     Else
      Print #1 , "No se encontro DS3231 en Getdatetime 2"
     End If
  Else
   Print #1 , "No se encontro DS3231 en Getdatetime 1"
  End If
End Sub
'-----------------------
Sub Setdateds3231()
  I2cstart                                                  ' Generate start code
  If Err = 0 Then
     _day = Makebcd(_day) : _month = Makebcd(_month) : _year = Makebcd(_year)
     I2cwbyte Ds3231w                                       ' send address
     I2cwbyte 3                                             ' starting address in 1307
     I2cwbyte Dow
     I2cwbyte _day                                          ' Send Data to day
     I2cwbyte _month                                        ' Month
     I2cwbyte _year                                         ' Year
     I2cstop
     If Err <> 0 Then
      'call Error(15)
      Print #1 , "Err setdatetime"
     End If
  Else
   Print #1 , "No se encontro DS3231 en Setdate"
  End If
End Sub
'-----------------------
Sub Settimeds3231()
  I2cstart                                                  ' Generate start code
  If Err = 0 Then
     _sec = Makebcd(_sec) : _min = Makebcd(_min) : _hour = Makebcd(_hour)
     I2cwbyte Ds3231w                                       ' send address
     I2cwbyte 0                                             ' starting address in 1307
     I2cwbyte _sec                                          ' Send Data to SECONDS
     I2cwbyte _min                                          ' MINUTES
     I2cwbyte _hour                                         ' Hours
     I2cstop
     If Err <> 0 Then
     ' call Error(15)
      Print #1 , "Err settime"
     End If
  Else
   Print #1 , "No se encontro DS3231 en Settime"
  End If
 End Sub
 '----------------------

'*******************************************************************************
'TABLA DE DATOS
'*******************************************************************************

Tbl_err:
Data "OK"                                                   '0
Data "Comando no reconocido"                                '1
Data "Longitud comando no valida"                           '2
Data "Numero de usuario no valido"                          '3
Data "Numero de parametros invalido"                        '4
Data "Error longitud parametro 1"                           '5
Data "Error longitud parametro 2"                           '6
Data "Parametro no valido"                                  '7
Data "ERROR8"                                               '8
Data "ERROR SD. Intente de nuevo"                           '9

Tabla_estado:
Data &B00000000000000000000000000000000&                    'Estado 0
Data &B00000000000000000000000000000011&                    'Estado 1
Data &B00000000000000000000000000110011&                    'Estado 2
Data &B00000000000000000000001100110011&                    'Estado 3
Data &B00000000000000000011001100110011&                    'Estado 4
Data &B00000000000000110011001100110011&                    'Estado 5
Data &B00000000000011001100000000110011&                    'Estado 6
Data &B00001111111111110000111111111111&                    'Estado 7
Data &B01010101010101010101010101010101&                    'Estado 8
Data &B00110011001100110011001100110011&                    'Estado 9
Data &B11111111111111111111111111111111&                    'Estado 10
Data &B11111111111111000000000000001100&                    'Estado 11
Data &B11111111111111000000000011001100&                    'Estado 12
Data &B11111111111111000000110011001100&                    'Estado 13
Data &B11111111111111001100110011001100&                    'Estado 14
Data &B11111111111111000000000000001100&                    'Estado 15
Data &B11111111111111111111111111110000&                    'Estado 16


Tbl_secdefault:
Data &B00000000                                             'Dummy
Data &B00000001
Data &B00000010
Data &B00000100
Data &B00001000
Data &B00010000
Data &B00100000
Data &B01000000
Data &B10000000

Tbl_semana:
Data "Lunes"
Data "Martes"
Data "Miercoles"
Data "Jueves"
Data "Viernes"
Data "Sabado"
Data "Domingo"
Data "No val"



Pic:
$bgf "WATCHING.bgf"

$include "font8x8TT.font"
$include "Font12x16.font"

Loaded_arch: