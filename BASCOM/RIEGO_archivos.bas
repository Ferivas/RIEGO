'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
'*  SD_Archivos.bas                                                        *
'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
'*                                                                             *
'*  Variables, Subrutinas y Funciones                                          *
'* WATCHING SOLUCIONES TECNOLOGICAS                                            *
'* 25.06.2015                                                                  *
'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

$nocompile
$projecttime = 461


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
Declare Sub Get_humidity()
Declare Sub Txrpi
Declare Sub Txauto(byval Numtx As Byte)
Declare Sub Tx0()
Declare Sub Tx1()
Declare Sub Tx2()
Declare Sub Tx3()
Declare Sub Tx4()
Declare Sub Procrpi()
Declare Sub Verackesp32()
Declare Sub Outreles(byval Numprograma As Byte , Byval Numciclo As Byte , Byval Numsecuencia As Byte)
Declare Sub Data2disp()
Declare Sub Resetreles()


'*******************************************************************************
'Declaracion de variables
'*******************************************************************************
Dim Tmpb As Byte , Tmpb2 As Byte , Tmpb3 As Byte , Tmpb4 As Byte
Dim J As Byte , K As Byte , K1 As Byte , N As Byte
Dim Tmpl As Long , Tmpl2 As Long
Dim Tmpw As Word , Tmpw2 As Word
Dim Tmpcrc32 As Long

Dim Trytx As Byte
Dim Txok As Bit

Dim Jt0 As Byte , Jt1 As Byte

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
Dim Habdiasemtmp As Byte
Dim Horariego(numhoras) As Long
Dim Horariegoeep(numhoras) As Eram Long
Dim Tiemporiego As Word
Dim Cntrticks As Word
Dim Tiemporiegoeep As Eram Word
Dim Secriego(numsecriego) As Byte
Dim Secriegoeep(numsecriego) As Eram Byte
Dim Diasemana As Byte
Dim Diasemanaant As Byte
Dim Habdiaria As Bit
Dim Horainicio(numhorariego) As Long                        ' Horarios riego iniciales
Dim Timestr As String * 10
Dim Inisecuencia As Bit
Dim Newsecuencia As Bit
Dim Iniciclo As Bit , Inicicloant As Bit
Dim Ptrciclo As Byte
Dim Ptrsecuencia As Byte , Ptrsecuenciaant As Byte
'Variables para transmisiones automáticas
Dim Autoval(numtxaut) As Long , Autovaleep(numtxaut) As Eram Long
Dim Offset(numtxaut) As Long , Offseteep(numtxaut) As Eram Long
Dim Tmpvaltb As String * 32
Dim Sndnumprg As Bit

'ADC
Dim Adcn As Byte , Adct As Byte
Dim Cntrsmpl As Byte
Dim Cntradc As Byte
Dim Tmpwadc As Word
Dim Adccntri(numadc) As Single
Dim Iniadc As Bit
Dim Adc_data(numadc) As Single
Dim Kadc(numadc) As Single
Dim Kadceep(numadc) As Eram Single
Dim Smplrdy As Bit
Dim Vbatval As Single
Dim Vinval As Single
Dim Iniprocbat As Bit


Dim Tactclk As Long
Dim Iniactclk As Bit
Dim Tactclkeep As Eram Long

'SENSOR HT
Dim Data_dht(5) As Byte , Temperature As String * 10 , Humidity As String * 10 , Dht_type As Byte
Dim Errorrh As Byte , Errorht As Byte
Dim Inisampleht As Bit
Dim Cntrht As Byte
Dim Humedadstr As String * 8
Dim Tempstr As String * 8
Dim Humedadstrant As String * 8
Dim Tempstrant As String * 8
Dim Cntrerrht As Byte
Dim Cntrerrtemp As Byte
Dim Tout2 As Bit
Dim Init2 As Bit
Dim Tcntr2 As Word

'Variables TIMER0
Dim T0c As Byte
Dim Num_ventana As Byte
Dim Estado As Long
Dim Estado_led As Byte
Dim Iluminar As Bit
Dim Newsec As Byte
Dim Kt0 As Byte
Dim Cntrseg As Byte
Dim T0cntr As Word
Dim T0tout As Bit , T0ini As Bit
Dim T0rate As Word

'timer1
Dim Lsyssec As Long
Dim Tmpltime As Long
Dim Tt2 As Byte
Dim Tmplisr As Long
Dim Iniauto As Byte

Dim Tack As Byte
Dim Iniack As Bit
Dim Tackeep As Eram Byte

Dim Enabug As Byte
Dim Enabugeep As Eram Byte

Dim Cntrini As Word
Dim Cntrinieep As Eram Word

Dim Cntresp32rst As Word
Dim Cntresp32rsteep As Eram Word
Dim Cntrackesp32 As Word
Dim Cntrrstmdm As Byte
'Dim Cntrrstmdmant As Byte
Dim Outtemppol As Byte
Dim Outtemppoleep As Eram Byte

'Variables SERIAL 1
Dim Rpi_ini As Bit , Rpinew As Bit
Dim Rpirx As Byte
Dim Rpidata As String * 140 , Rpiproc As String * 140

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

'*******************************************************************************
' Subrutina interrupcion de puerto serial 3
'*******************************************************************************

At_ser2:
   Rpirx = Udr1
   Select Case Rpirx
      Case "%"
         Set Rpi_ini
         Rpidata = ""

      Case 13:
         If Rpi_ini = 1 Then
            Rpi_ini = 0
            Rpidata = Rpidata + Chr(0)
            Rpiproc = Rpidata
            If Rpiproc = "OK" Then Set Txok
            Set Rpinew
         End If

      Case Is > 31
         If Rpi_ini = 1 Then
            Rpidata = Rpidata + Chr(rpirx)
           If Len(rpidata) > 140 Then
               Rpidata = ""
            End If

         End If

   End Select

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
      Estado = Lookup(estado_led , Tabla_estado)
      Iluminar = Estado.num_ventana
      Led1 = Iluminar
      Incr Num_ventana
   End If

   If Init2 = 1 Then
      Incr Tcntr2
      Tcntr2 = Tcntr2 Mod 505
      If Tcntr2 = 0 Then
         Set Tout2
      End If
   End If

   If T0ini = 1 Then
      Incr T0cntr
      If T0cntr = T0rate Then
         Set T0tout
      End If
   Else
      T0cntr = 0
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
         Set Iniciclo
         Ptrciclo = Tt2
      End If
   Next

   Tmplisr = Lsyssec Mod Tactclk
   If Tmplisr = 0 Then
      Set Iniactclk
   End If

   Tmplisr = Lsyssec Mod Tack
   If Tmplisr = 0 Then
      Set Iniack
   End If


   For Jt1 = 1 To Numtxaut
      Tmplisr = Lsyssec + Offset(jt1)
      Tmplisr = Tmplisr Mod Autoval(jt1)
      Jt0 = Jt1 - 1
      If Tmplisr = 0 Then Set Iniauto.jt0
   Next

   Incr Cntradc
   Cntradc = Cntradc Mod Tsample
   If Cntradc = 0 Then
      Set Iniadc
   End If

   Incr Cntrht
   Cntrht = Cntrht Mod Tsampleht
   If Cntrht = 0 Then
      Set Inisampleht
   End If

   If Inisecuencia = 1 Then
      Incr Cntrticks
      Cntrticks = Cntrticks Mod Tiemporiego
      If Cntrticks = 0 Then
         Set Newsecuencia
      End If

   End If

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
   Print #1 , "************ RIEGO ************"
   Print #1 , Version(1)
   Print #1 , Version(2)
   Print #1 , Version(3)

   Horamin = Horamineep
   Print #1 , "Ultima ACT CLK " ; Date(horamin) ; "," ; Time(horamin)
   Tactclk = Tactclkeep
   Print #1 , "Tiempo Consulta CLK a MDC=" ; Tactclk


   Tack = Tackeep
   Print #1 , "Tiempo Consulta ACK=" ; Tack

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
         If Enabug.0 = 1 Then
            Print #1 , "Hora " ; K ; "=" ; Time(tmpl) ; ",  " ; Tmpw
         End If
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
            If Enabug.0 = 1 Then
               Print #1 , "SEC " ; N ; "=" ; Bin(secriego(ptrsec)) ; ", " ; Ptrsec
            End If
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

   For Tmpb = 1 To Numtxaut
      Autoval(tmpb) = Autovaleep(tmpb)
      Offset(tmpb) = Offseteep(tmpb)
      Print #1 , "Aut" ; Tmpb ; "=" ; Autoval(tmpb) ; ", OFF" ; Tmpb ; "=" ; Offset(tmpb)
   Next
   Enabug = Enabugeep
   Print #1 , "ENABUG=" ; Enabug

   Cntrini = Cntrinieep
   Incr Cntrini
   Print #1 , "CNTRINI:" ; Cntrini
   Cntrinieep = Cntrini

   Outtemppol = Outtemppoleep
   Print #1 , "OUT POLaridad Reles Teporizados=" ; Bin(outtemppol)

End Sub

Sub Inihorainicio()
   J = Enaprog
   Print #1 , "Prog " ; J
   Habdiasemtmp = Habdiasem(j)
   Print #1 , "HabDiaSemana=" ; Bin(habdiasemtmp)
   For K = 1 To Numhorariego
      Tmpw = J - 1
      Tmpw = Tmpw * 4
      Tmpw = Tmpw + K
      Tmpl = Horariego(tmpw)
      Horainicio(k) = Tmpl
      Print #1 , "Hora inicio " ; K ; "=" ; Time(tmpl) ; ",  " ; Tmpw
   Next

End Sub


Sub Outreles(byval Numprograma As Byte , Byval Numciclo As Byte , Byval Numsecuencia As Byte)
   Local Ptrw As Word , Ptrw2 As Word , Tmpout As Byte
   Ptrw = Numprograma - 1
   Ptrw = Ptrw * 32
   Ptrw2 = Numciclo - 1
   Ptrw2 = Ptrw2 * 8
   Ptrw = Ptrw + Ptrw2
   Ptrw = Ptrw + Numsecuencia
   Ptrw = Ptrw + 1
   Tmpout = Secriego(ptrw)
   Print #1 , "SEC" ; Numsecuencia ; "=" ; Bin(tmpout) ; "," ; Ptrw
   Ev1 = Tmpout.0
   Ev2 = Tmpout.1
   Ev3 = Tmpout.2
   Ev4 = Tmpout.3
   Ev5 = Tmpout.4
   Ev6 = Tmpout.5

End Sub

Sub Resetreles()
   Reset Ev1
   Reset Ev2
   Reset Ev3
   Reset Ev4
   Reset Ev5
   Reset Ev6

End Sub

Sub Data2disp()
   Tmpstr52 = Date$
   Tmpstr52 = Tmpstr52 + " " + Time$ + " "
   Lcdat 1 , 1 , Tmpstr52
   Tmpstr52 = "P" + Str(enaprog) + ", L" + Str(habdiasemtmp.0) + "M" + Str(habdiasemtmp.1) + "M" + Str(habdiasemtmp.2)
   Tmpstr52 = Tmpstr52 + "J" + Str(habdiasemtmp.3) + "V" + Str(habdiasemtmp.4) + "S" + Str(habdiasemtmp.5) + "D" + Str(habdiasemtmp.6) + " "
   Lcdat 3 , 1 , Tmpstr52
   Tmpl = Horainicio(1)
   Tmpstr52 = Time(tmpl) + " "
   Tmpl = Horainicio(2)
   Tmpstr52 = Tmpstr52 + Time(tmpl) + " "
   Lcdat 5 , 1 , Tmpstr52
   Tmpl = Horainicio(3)
   Tmpstr52 = Time(tmpl) + " "
   Tmpl = Horainicio(4)
   Tmpstr52 = Tmpstr52 + Time(tmpl) + " "
   Lcdat 7 , 1 , Tmpstr52

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
   Enabugeep = 0

   Tmpb = 0
   For J = 1 To Numtxaut
      Autoval(j) = 300
      Autovaleep(j) = Autoval(j)
      Offset(j) = Tmpb
      Offseteep(j) = Offset(j)
      Tmpb = Tmpb + 60
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
            If Numpar = 2 Then
               Tmpb = Val(cmdsplit(2))
               If Tmpb < 17 Then
                  Cmderr = 0
                  Atsnd = "Se configura setled a " + Str(tmpb)
                  Estado_led = Tmpb
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
                  Set Iniauto.1
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEEPRG"
            Cmderr = 0
            Atsnd = "Prog Actual=" + Str(enaprog)
            Set Sndnumprg


         Case "SETSEM"
            If Numpar = 3 Then
               Tmpb2 = Val(cmdsplit(2))                     'Numero de programa
               If Tmpb2 > 0 And Tmpb2 < Numprog_masuno Then
                  Cmderr = 0
                  Habdiasem(tmpb2) = Binval(cmdsplit(3))
                  Habdiasemeep(tmpb2) = Habdiasem(tmpb2)
                  Atsnd = "Se config Hab Semana de Prog" + Str(enaprog) + " a " + Bin(habdiasem(tmpb2))
                  Call Inihorainicio()
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEESEM"
            If Numpar = 2 Then
               If Tmpb2 > 0 And Tmpb2 < Numprog_masuno Then
                  Cmderr = 0
                  Atsnd = "Hab Semana de Prog" + Str(enaprog) + " = " + Bin(habdiasem(tmpb2))
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "SETAUT"
            If Numpar = 3 Then
               J = Val(cmdsplit(2))
               If J > 0 And J < Numtxaut_mas_uno Then
                 'Snstr = Cmdsplit(3)
                 Tmpl2 = Val(cmdsplit(3))
                 Autoval(j) = Tmpl2
                 Autovaleep(j) = Tmpl2
                 Cmderr = 0
                 'Print #1 , "$" ; J ; "," ; Autoval(j)
                 'Print #1 , "$OK"
                 Atsnd = "Se configuro tx AUT " + Str(j) + ":" + Str(autoval(j))
                 Tmpvaltb = Str(autoval(j))
               Else
                  Cmderr = 3
               End If
            Else
               Cmderr = 4
            End If

         Case "SETOFF"
            If Numpar = 3 Then
               J = Val(cmdsplit(2))
               If J > 0 And J < Numtxaut_mas_uno Then
                 'Snstr = Cmdsplit(3)
                 Tmpl2 = Val(cmdsplit(3))
                 Offset(j) = Tmpl2
                 Offseteep(j) = Tmpl2
                 Cmderr = 0
                 'Print #1 , "$" ; J ; "," ; Offset(j)
                 'Print #1 , "$OK"
                 Atsnd = "Se configuro tx AUT " + Str(j) + ":" + Str(offset(j))
                 Tmpvaltb = Str(offset(j))
               Else
                  Cmderr = 3
               End If
            Else
               Cmderr = 4
            End If

         Case "LEEAUT"                                      'Habilitaciones de Usuario
            If Numpar = 2 Then
               J = Val(cmdsplit(2))
               If J > 0 And J < Numtxaut_mas_uno Then
                  'Snstr = Cmdsplit(3)
                  Atsnd = "Tx Aut " + Str(j) + ":" + Str(autoval(j))
                  Cmderr = 0
                  Print #1 , "$" ; J ; "," ; Autoval(j)
                  Print #1 , "$OK"
                  Tmpvaltb = Str(autoval(j))
               Else
                  Cmderr = 3
               End If
            Else
               Cmderr = 4
            End If

         Case "LEEOFF"                                      'Habilitaciones de Usuario
            If Numpar = 2 Then
               J = Val(cmdsplit(2))
               If J > 0 And J < Numtxaut_mas_uno Then
                 'Snstr = Cmdsplit(3)
                  Atsnd = "Offset Aut " + Str(j) + ":" + Str(offset(j))
                  Cmderr = 0
                  Print #1 , "$" ; J ; "," ; Offset(j)
                  Print #1 , "$OK"
                  Tmpvaltb = Str(offset(j))
               Else
                  Cmderr = 3
               End If
            Else
               Cmderr = 4
            End If


         Case "SETNEW"
            If Numpar = 2 Then
               J = Val(cmdsplit(2))
               If J > 0 And J < Numtxaut_mas_uno Then
                  Cmderr = 0
                  Tmpb = J - 1
                  Set Iniauto.tmpb
                  Atsnd = "Se activo Tx. AUT " + Str(j) + "," + Bin(iniauto)
                  Tmpvaltb = Bin(iniauto)
               Else
                  Cmderr = 3
               End If

            Else
               Cmderr = 4
            End If

         Case "SETTAC"
            If Numpar = 2 Then
               Tactclk = Val(cmdsplit(2))
               Tactclkeep = Tactclk
               Atsnd = "Se configuro Tact CLK=" + Str(tactclk)
               Tmpvaltb = Str(tactclk)
            Else
               Cmderr = 4
            End If

         Case "LEETAC"
            Cmderr = 0
            Atsnd = "Tact CLK=" + Str(tactclk)
            Tmpvaltb = Str(tactclk)

         Case "ACTCLK"
            Cmderr = 0
            Set Iniactclk
            Atsnd = "ACT CLK"

         Case "SETACK"
            If Numpar = 2 Then
               Cmderr = 0
               Tack = Val(cmdsplit(2))
               Tackeep = Tack
               Atsnd = "Se configuro Tak=" + Str(tack)
               Tmpvaltb = Str(tack)
            Else
               Cmderr = 4
            End If

         Case "LEEACK"
            Cmderr = 0
            Atsnd = "Tack=" + Str(tack)
            Tmpvaltb = Str(tack)

         Case "INIACK"
            Cmderr = 0
            Set Iniack
            Atsnd = "Nuevo ACK"

         Case "SETBUG"
            If Numpar = 2 Then
               Cmderr = 0
               Enabug = Val(cmdsplit(2))
               Enabugeep = Enabug
               Atsnd = "Se configuro ENABUG=" + Str(enabug)
            Else
               Cmderr = 4
            End If

         Case "LEEBUG"
            Cmderr = 0
            Atsnd = "ENABUG=" + Str(enabug)

         Case "SETINI"
            If Numpar = 2 Then
               Cntrini = Val(cmdsplit(2))
               Cntrinieep = Cntrini
               Cmderr = 0
               Atsnd = "Se configuro Contador Inicios: " + Str(cntrini)
               Tmpvaltb = Str(cntrini)
               Set Iniauto.1
            Else
               Cmderr = 4
            End If

         Case "LEEINI"
            If Numpar = 1 Then
               Cmderr = 0
               Atsnd = "Contador inicios <" + Str(cntrini) + ">"
               Tmpvaltb = Str(cntrini)
            Else
               Cmderr = 4
            End If


         Case "SETESP"
            If Numpar = 2 Then
               Tmpb = Val(cmdsplit(2))
               If Tmpb < 2 Then
                  Cmderr = 0
                  If Tmpb = 0 Then
                     Reset Esp32rst
                  Else
                     Set Esp32rst
                  End If
                  Atsnd = "RSTESP32=" + Str(esp32rst)
                  'Tmpvaltb = Str(esp32rst)
               Else
                  Cmderr = 3
               End If
            Else
               Cmderr = 4
            End If


         Case "SETCES"
            If Numpar = 2 Then
               Cmderr = 0
               Cntrackesp32 = Val(cmdsplit(2))
               Atsnd = "Se conf. Cntrackesp32=" + Str(cntrackesp32)
               'Tmpvaltb = Str(cntrackesp32)
            Else
               Cmderr = 4
            End If


         Case "SETCRE"                                      'Contador RST ESP32
            If Numpar = 2 Then
               Cmderr = 0
               Cntresp32rst = Val(cmdsplit(2))
               Cntresp32rsteep = Cntresp32rst
               Atsnd = "Se conf. CNTR_ESP32_RST=" + Str(cntresp32rst)
               'Tmpvaltb = Str(cntrackesp32)
               'Set Iniauto.1
            Else
               Cmderr = 4
            End If

         Case "LEECRE"
            Cmderr = 0
            Atsnd = "CNTR_ESP32_RST=" + Str(cntresp32rst) + ", CNTRack=" + Str(cntrackesp32) + ", CNTRrstmdm=" + Str(cntrrstmdm)
            'Tmpvaltb = Str(cntrackesp32)

         Case "SETCRM"                                      'Utilizado para simular
            Cmderr = 0
            Cntrrstmdm = Val(cmdsplit(2))
            Atsnd = "Se CNTRrstmdm=" + Str(cntrrstmdm)


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


'===============================================================================
'=============================== DHT11/DHT22 ===================================
Sub Get_humidity()
   Local Number_dht As Byte , Byte_dht As Byte , Dht_single As Single
   'Local Errorrh As Byte

   Set Dht_io_set                                           'bus is output
   Reset Dht_put : Waitms 1                                 'bus=0
   Set Dht_put : Waitus 40                                  'bus=1
   Reset Dht_io_set : Waitus 40                             'bus is input
   If Dht_get = 1 Then                                      'not DHT22?
      Set Dht_io_set                                        'bus is output
      Reset Dht_put : Waitms 20                             'bus=0
      Set Dht_put : Waitus 40                               'bus=1
      Reset Dht_io_set : Waitus 40                          'bus is input
      If Dht_get = 1 Then
         Temperature = ""
         Humidity = ""                                      'DHT11 not response!!!
         Errorrh = 1
         Exit Sub
      End If
      Waitus 80
      If Dht_get = 0 Then
         Temperature = ""
         Humidity = ""                                      'DHT11 not response!!!
         Errorrh = 1
         Exit Sub
      Else
         Dht_type = 11                                      'really DHT11
      End If
   Else
      Waitus 80
      If Dht_get = 0 Then
         Temperature = ""
         Humidity = ""                                      'DHT22 not response!!!
         Errorrh = 1
         Exit Sub
      Else
         Dht_type = 22                                      'really DHT22
      End If
   End If

   'Bitwait Dht_get , Reset                                  'wait for transmission
   Tcntr2 = 0
   Tout2 = 0
   Set Init2
   While Dht_get = 1 And Tout2 = 0
   Wend

   If Tout2 = 0 Then
      Errorrh = 0
      For Number_dht = 1 To 5
         For Byte_dht = 7 To 0 Step -1
            'Bitwait Dht_get , Set
            Tcntr2 = 0
            Tout2 = 0
            Set Init2
            While Dht_get = 0 And Tout2 = 0
            Wend
            If Tout2 = 0 Then
               Waitus 35
               If Dht_get = 1 Then
                  Data_dht(number_dht).byte_dht = 1
                  'Bitwait Dht_get , Reset
                  Tcntr2 = 0
                  Tout2 = 0
                  Set Init2
                  While Dht_get = 1 And Tout2 = 0
                  Wend
                  If Tout2 = 1 Then
                     If Enabug.3 = 1 Then
                        Print #1 , "ERR 3"
                     End If
                     Reset Init2
                     Errorrh = 4
                     Exit For
                  End If
               Else
                  Data_dht(number_dht).byte_dht = 0
               End If
            Else
               If Enabug.3 = 1 Then
                  Print #1 , "ERR 2"
               End If
               Reset Init2
               Errorrh = 3
               Exit For
            End If
         Next
         If Errorrh > 0 Then
            Exit For
         End If
      Next
      If Errorrh = 0 Then
         Set Dht_io_set : Set Dht_put
         If Dht_type = 22 Then                              'CRC check
            Byte_dht = Data_dht(1) + Data_dht(2)
            Byte_dht = Byte_dht + Data_dht(3)
            Byte_dht = Byte_dht + Data_dht(4)
         Else
            Byte_dht = Data_dht(1) + Data_dht(3)
         End If

         If Byte_dht <> Data_dht(5) Then
            Temperature = "ERR1"
            Humidity = "ERR1"                               'CRC error!!!
            Errorrh = 6
         Else
            If Dht_type = 22 Then
               Dht_single = Data_dht(1) * 256
               Dht_single = Dht_single + Data_dht(2)
               Dht_single = Dht_single / 10
               Humidity = Fusing(dht_single , "#.#")        ' + "%"
               If Data_dht(3).7 = 1 Then
                  Data_dht(3).7 = 0
                  Temperature = "-"
               Else
                  Temperature = ""
               End If
               Dht_single = Data_dht(3) * 256
               Dht_single = Dht_single + Data_dht(4)
               Dht_single = Dht_single / 10
               Temperature = Temperature + Fusing(dht_single , "#.#")       ' + "C"
            Else
               Temperature = Str(data_dht(3))               ' + " C"
               Humidity = Str(data_dht(1))                  ' + " %"
            End If
         End If
      Else
            Temperature = ""
            Humidity = ""                                   'CRC error!!!
            Errorrh = 5
      End If
   Else
      If Enabug.3 = 1 Then
         Print #1 , "ERR 1"
      End If
      Reset Init2
      Temperature = ""
      Humidity = ""
      Errorrh = 2
   End If
End Sub

Sub Txrpi()
   Trytx = 0
   Reset Txok
   Do
      Incr Trytx
      Print #1 , "Espera RPI " ; Trytx
      T0rate = 100
      T0cntr = 0
      Set T0ini
      Reset T0tout
      Do
         If Rpinew = 1 Then
            Reset Rpinew
            Print#1 , "RPItx>" ; Rpiproc
            Call Procrpi()
         End If
         If Sernew = 1 Then
            Reset Sernew
            Print #1 , "SER1=" ; Serproc
            Call Procser()
         End If
      Loop Until Txok = 1 Or T0tout = 1
      Reset T0ini
      If Txok = 0 Then
         Print #1 , "$" ; Atsnd
         Print #3 , "$" ; Atsnd
      End If
   Loop Until Txok = 1 Or Trytx = 3

   Reset T0ini
   Reset Txok

End Sub

'*******************************************************************************
' Procesamiento de datos del RPi
'*******************************************************************************
Sub Procrpi()
   'Cntrackesp32 = 0
   'Cntrrstmdm = 0
   Numpar = Split(rpiproc , Cmdsplit(1) , ";")
   If Numpar > 0 Then
      Cmdtmp = Cmdsplit(1)
   Else
      Cmdtmp = Rpiproc
   End If
   '   Cmdtmp = "nocmd"
   'Else
      'Cmdtmp = Cmdsplit(1)

  ' End If
   Select Case Cmdtmp
      Case "OK"
         Set Txok
         Cntrackesp32 = 0

      Case "ERR"
         Reset Txok
         Cntrackesp32 = 0

      Case "OKW"
         Cntrrstmdm = 0

      Case "ERRW"
         Incr Cntrrstmdm

      Case "SETMBD"
         Cntrackesp32 = 0
         Set Sernew
         'Set Resptb
         Serproc = Cmdsplit(2)
         Print #1 , "NEW MDC CMD"

      Case Else
         Print #1 , "No cmd val"

   End Select

End Sub

'*******************************************************************************
'TX PERIODICA DE DATOS
'*******************************************************************************
Sub Txauto(byval Numtx As Byte)
   Print #1 , "TXAUT" ; Numtx ; ";" ; Time$ ; "," ; Date$
   Select Case Numtx
      Case 1:                                               'TXAUT1
         Call Tx1()
      Case 2:
         Call Tx2()
      Case 3:
         Call Tx3()
      Case 4:
         Call Tx4()
      Case Else:
         Print #1 , "No proc Numtx"
   End Select
End Sub

Sub Tx1()
   Fechaed = Date$
   Horaed = Time$
   Atsnd = "D" + "," + Fechaed + "," + Horaed + "," + Idserial + "-1"
   Atsnd = Atsnd + "," + Str(ev1) + "," + Str(ev2) + "," + Str(ev3) + "," + Str(ev4)
   Atsnd = Atsnd + "," + Str(ev5) + "," + Str(ev6) + ",,"
   Tmpw = Len(atsnd)
   Tmpcrc32 = Crc32(atsnd , Tmpw)
   Atsnd = Atsnd + "&" + Hex(tmpcrc32) + Chr(10)
   Print #1 , "$" ; Atsnd
   Print #3 , "$" ; Atsnd
   Call Txrpi()


End Sub

Sub Tx2()
   Fechaed = Date$
   Horaed = Time$
   Atsnd = "2" + "," + Fechaed + "," + Horaed + "," + Idserial + "-2"
   Atsnd = Atsnd + "," + Humidity + "," + Temperature + "," + Str(cntrini) + "," + Str(cntresp32rst)
   Atsnd = Atsnd + "," + Str(enaprog) + "," + "," + ","
   Tmpw = Len(atsnd)
   Tmpcrc32 = Crc32(atsnd , Tmpw)
   Atsnd = Atsnd + "&" + Hex(tmpcrc32) + Chr(10)
   Print #1 , "$" ; Atsnd
   Print #3 , "$" ; Atsnd
   Call Txrpi()

End Sub

Sub Tx3()

End Sub

Sub Tx4()

End Sub

'*******************************************************************************
Sub Verackesp32()
   Incr Cntrackesp32
   Cntrackesp32 = Cntrackesp32 Mod 600
   'Tmpw = Cntrackesp32 Mod 10
   'If Tmpw = 0 Then
   '   Print #1 , "CNTRACK=" ; Cntrackesp32
   'End If
   If Cntrackesp32 = 0 Then
      Print #1 , "RST esp32"
      Incr Cntresp32rst
      Cntresp32rsteep = Cntresp32rst
      Print #1 , "CNTRrst=" ; Cntresp32rst
      'Print #1 , "********** DEBUG *****************************"
      Reset Esp32rst
      Print #1 , "RSTESP=0"
      Wait 1
      Set Esp32rst
      Print #1 , "RSTESP=1"
   End If
End Sub


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