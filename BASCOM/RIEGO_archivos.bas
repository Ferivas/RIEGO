'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
'*  SD_Archivos.bas                                                        *
'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
'*                                                                             *
'*  Variables, Subrutinas y Funciones                                          *
'* WATCHING SOLUCIONES TECNOLOGICAS                                            *
'* 25.06.2015                                                                  *
'* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

$nocompile
$projecttime = 650


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
Declare Sub Setreles()
Declare Sub Leered()
Declare Sub Gentrama()


'*******************************************************************************
'Declaracion de variables
'*******************************************************************************
Dim Tmpb As Byte , Tmpb2 As Byte , Tmpb3 As Byte , Tmpb4 As Byte
Dim J As Byte , K As Byte , K1 As Byte , N As Byte
Dim Tmpl As Long , Tmpl2 As Long
Dim Tmpw As Word , Tmpw2 As Word
Dim Tmpcrc32 As Long
Dim Tmpbit As Bit
Dim Modo As Bit
Dim Cntrdisp As Byte
Dim Tmpdisp As Byte

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

'TIMER2
Dim Tmpbit2 As Bit
'Dim T1tick As Byte
Dim T1tmp As Byte
Dim T1tmp0 As Byte
Dim Cntrtredmenos(ednum) As Word
Dim Cntrtredmas(ednum) As Word
Dim Evmenos As Byte                                         ' Almacena en un bit nuevo evento de mas a menos
Dim Evmas As Byte                                           ' Almacena en un bit nuevo evento de menos a mas
Dim Tmped As Byte
Dim Ct2 As Byte

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
'Variables ED
Dim Jed As Byte
Dim Tredmas(ednum) As Word
Dim Tredmaseep(ednum) As Eram Word
Dim Tredmenos(ednum) As Word
Dim Tredmenoseep(ednum) As Eram Word
Dim Edpol As Byte
Dim Edpoleep As Eram Byte
Dim Edname(ednum) As String * 6
Dim Ednameeep(ednum) As Eram String * 6
Dim Eddat As Byte
Dim Edsta(ednum) As Byte
Dim Edstaant(ednum) As Byte
Dim Edhab As Byte
Dim Edhabeep As Eram Byte
Dim Hora_buf(numbuf) As Long
Dim Ptrbuf As Byte
Dim Ptrtx As Byte
Dim Vin_buf(numbuf) As Single
Dim Vbat_buf(numbuf) As Single
Dim Tx_buf(numbuf) As Byte
Dim Ed_buf(numbuf) As Byte
Dim Edsta3ant As Byte

Dim Tonnebul As Word
Dim Tonnebuleep As Eram Word
Dim Toffnebul As Word
Dim Toffnebuleep As Eram Word
Dim Cntrnebulon As Word
Dim Cntrnebuloff As Word
Dim Ininebul As Bit
Dim Ininebulon As Bit
Dim Ininebuloff As Bit
Dim Ininebulonant As Bit
Dim Ininebuloffant As Bit
Dim Firstnebulon As Bit
'Variables SERIAL 1
Dim Rpi_ini As Bit , Rpinew As Bit
Dim Rpirx As Byte
Dim Rpidata As String * 140 , Rpiproc As String * 140

'Variables SERIAL0
Dim Ser_ini As Bit , Sernew As Bit
Dim Numpar As Byte
Dim Cmdsplit(34) As String * 20
Dim Serdata As String * 180 , Serrx As Byte , Serproc As String * 180



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

   If Ininebul = 1 Then
      If Ininebulon = 1 Then
         Incr Cntrnebulon
         Cntrnebulon = Cntrnebulon Mod Tonnebul
         If Cntrnebulon = 0 Then
            Set Ininebuloff
            Reset Ininebulon
         End If
      End If

      If Ininebuloff = 1 Then
         Incr Cntrnebuloff
         Cntrnebuloff = Cntrnebuloff Mod Toffnebul
         If Cntrnebuloff = 0 Then
            Set Ininebulon
            Reset Ininebuloff
         End If
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
'TIMER 2
'*******************************************************************************
Int_timer2:
   Timer2 = &H64                                            'Ints a 100 Hz si Prescale=1024
   Incr Ct2
   Ct2 = Ct2 Mod 10
   If Ct2 = 0 Then
      Tmpbit2 = Ed0 Xor Edpol.0
      Eddat.0 = Tmpbit2
      Tmpbit2 = Ed1 Xor Edpol.1
      Eddat.1 = Tmpbit2
      Tmpbit2 = Ed2 Xor Edpol.2
      Eddat.2 = Tmpbit2
      Tmpbit2 = Ed3 Xor Edpol.3
      Eddat.3 = Tmpbit2

      For T1tmp = 1 To Ednum
         T1tmp0 = T1tmp - 1
         Select Case Edsta(t1tmp)
            Case 0:                                         'Normal
               If Eddat.t1tmp0 = 0 Then
                  Edsta(t1tmp) = 2
               End If
            Case 1:                                         'Alarma
               If Eddat.t1tmp0 = 1 Then
                  Edsta(t1tmp) = 3
               End If
            Case 2:                                         'Prealarma
               If Eddat.t1tmp0 = 1 Then
                  Edsta(t1tmp) = 0
                  Cntrtredmenos(t1tmp) = 0
               Else
                  Incr Cntrtredmenos(t1tmp)
                  Cntrtredmenos(t1tmp) = Cntrtredmenos(t1tmp) Mod Tredmenos(t1tmp)
                  If Cntrtredmenos(t1tmp) = 0 Then
                     Edsta(t1tmp) = 1
                     Set Evmenos.t1tmp0
                  End If
               End If
            Case 3:                                         'Prenormal
               If Eddat.t1tmp0 = 0 Then
                  Edsta(t1tmp) = 1
                  Cntrtredmas(t1tmp) = 0
               Else
                  Incr Cntrtredmas(t1tmp)
                  Cntrtredmas(t1tmp) = Cntrtredmas(t1tmp) Mod Tredmas(t1tmp)
                  If Cntrtredmas(t1tmp) = 0 Then
                     Edsta(t1tmp) = 0
                     Set Evmas.t1tmp0
                  End If
               End If
         End Select
      Next
   End If

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

   Enabug = Enabugeep
   Print #1 , "ENABUG=" ; Enabug

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
         Tmpw = Tmpw * Numhorariego
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


   Cntrini = Cntrinieep
   Incr Cntrini
   Print #1 , "CNTRINI:" ; Cntrini
   Cntrinieep = Cntrini

   Outtemppol = Outtemppoleep
   Print #1 , "OUT POLaridad Reles Teporizados=" ; Bin(outtemppol)

   For Tmpb = 1 To Ednum
      Edname(tmpb) = Ednameeep(tmpb)
      Print #1 , "EDname " ; Tmpb ; "=" ; Edname(tmpb)
      Tredmas(tmpb) = Tredmaseep(tmpb)
      Print #1 , "T red + ED " ; Tmpb ; "=" ; Tredmas(tmpb) ; "x 0.1s"
      Tredmenos(tmpb) = Tredmenoseep(tmpb)
      Print #1 , "T red - ED " ; Tmpb ; "=" ; Tredmenos(tmpb) ; "x 0.1s"
      Edstaant(tmpb) = 5
   Next

   Edpol = Edpoleep
   Print #1 , "EDpol=" ; Bin(edpol)
   Edhab = Edhabeep
   Print #1 , "EDhab=" ; Bin(edhab)

   Tonnebul = Tonnebuleep
   Print #1 , "TON nebul=" ; Tonnebul
   Toffnebul = Toffnebuleep
   Print #1 , "TOFF nebul=" ; Toffnebul

   Edsta3ant = 99
End Sub

Sub Inihorainicio()
   J = Enaprog
   Print #1 , "Prog " ; J
   Habdiasemtmp = Habdiasem(j)
   Print #1 , "HabDiaSemana=" ; Bin(habdiasemtmp)
   For K = 1 To Numhorariego
      Tmpw = J - 1
      Tmpw = Tmpw * Numhorariego
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

Sub Setreles()
   Set Ev1
   Set Ev2
   Set Ev3
   Set Ev4
   Set Ev5
   Set Ev6

End Sub

Sub Data2disp()
   Tmpstr52 = Date$
   Tmpstr52 = Tmpstr52 + " " + Time$ + " "
   Lcdat 1 , 1 , Tmpstr52

   Tmpstr52 = "M=" + Str(edsta(3))                          '+ ", RH=" + Str(edsta(2)) + ", RN=" + Str(edsta(1)) + "  "
   Tmpbit = Ed1 Xor Edpol.1
   Tmpstr52 = Tmpstr52 + ", RH=" + Str(tmpbit)
   Tmpbit = Ed0 Xor Edpol.0
   Tmpstr52 = Tmpstr52 + ", RN=" + Str(tmpbit) + "  "
   Lcdat 3 , 1 , Tmpstr52

   Tmpstr52 = "H=" + Humidity + " T=" + Temperature + "  "  '",RN=" + Str(edsta(1)) + ",RH=" + Str(edsta(2)) + ",M=" + Str(edsta(3)) + "  "
   Lcdat 5 , 1 , Tmpstr52

   Incr Tmpdisp
   If Tmpdisp.0 = 1 Then
      Incr Cntrdisp
      Tmpstr52 = ""
      Cntrdisp = Cntrdisp Mod 17
      If Cntrdisp = 0 Then
         Tmpstr52 = "P" + Str(enaprog) + ", L" + Str(habdiasemtmp.0) + "M" + Str(habdiasemtmp.1) + "M" + Str(habdiasemtmp.2)
         Tmpstr52 = Tmpstr52 + "J" + Str(habdiasemtmp.3) + "V" + Str(habdiasemtmp.4) + "S" + Str(habdiasemtmp.5) + "D" + Str(habdiasemtmp.6) + " "
      Else
         Tmpl = Horainicio(cntrdisp)
         Tmpstr52 = "HR" + Str(cntrdisp) + "=" + Time(tmpl) + "     "
      End If
      Lcdat 7 , 1 , Tmpstr52
   End If

End Sub

Sub Defaultvalues()
   Enaprogeep = 1                                           'Programa Actual 1
   Tiemporiegoeep = 20
   Tmpb2 = 0
   For Tmpb = 1 To Numprog
      Habdiasemeep(tmpb) = &B01111111
      Tmpstr52 = "06:00:00"
      Tmpl = Secofday(tmpstr52)
      Print #1 , "PROG " ; Tmpb ; " Tmpl=" ; Tmpl
      For Tmpb3 = 1 To Numhorariego
         Incr Tmpb2
         Horariego(tmpb2) = Tmpl
         Print#1 , "HR" ; Tmpb2 ; "=" ; Time(tmpl)
         Tmpl = Tmpl + 3600
      Next
   Next

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

   For J = 1 To Ednum
      Tmpstr52 = "ED" + Str(j)
      Ednameeep(j) = Tmpstr52
      Tredmaseep(j) = 10
      Tredmenoseep(j) = 10
      'Tmpstr52 = Lookupstr(j , Tbl_repmas)
      'Txtrepmaseep(j) = Tmpstr52
      'Tmpstr52 = Lookupstr(j , Tbl_repmenos)
      'Txtrepmenoseep(j) = Tmpstr52
   Next
   Edpoleep = &B00001111
   Edhabeep = &B00001111

   Tonnebuleep = 60
   Toffnebuleep = 30
   Tactclkeep = 3600
   Tackeep = 60

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
                     Tmpw = Tmpw * Numhorariego
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
                     Tmpw = Tmpw * Numhorariego
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
               Tmpw = Val(cmdsplit(2))
               If Tmpw > 0 Then
                  Cmderr = 0
                  Tiemporiego = Tmpw
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

         Case "SETTON"
            If Numpar = 2 Then
               Tmpw = Val(cmdsplit(2))
               If Tmpw > 0 Then
                  Cmderr = 0
                  Tonnebul = Tmpw
                  Atsnd = "Se configuro TON nebul=" + Str(tonnebul)
                  Tonnebuleep = Tonnebul
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEETON"
            Cmderr = 0
            Atsnd = "TON nebul=" + Str(tonnebul)

         Case "SETTOF"
            If Numpar = 2 Then
               Tmpw = Val(cmdsplit(2))
               If Tmpw > 0 Then
                  Cmderr = 0
                  Toffnebul = Tmpw
                  Atsnd = "Se configuro TOFF nebul=" + Str(toffnebul)
                  Toffnebuleep = Toffnebul
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEETOF"
            Cmderr = 0
            Atsnd = "TOFF nebul=" + Str(toffnebul)



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
               Cmderr = 0
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

         Case "ESTADO"
            Cmderr = 0
            Atsnd = "WATCHING INFORMA. "                    'ED1="

            For Tmpb = 1 To Ednum
               J = Tmpb - 1
               If Edhab.j = 1 Then
                  Tmpbit = Pina.j Xor Edpol.j
                  Atsnd = Atsnd + Edname(tmpb) + "=" + Str(tmpbit) + ","
               End If
            Next

         Case "SETHAB"
            If Numpar = 4 Then
               Tmpb2 = Val(cmdsplit(2))
               Select Case Tmpb2
                  Case 1:                                   'ED
                     Tmpb = Val(cmdsplit(3))
                     If Tmpb > 0 And Tmpb < Ednum_masuno Then
                        Cmderr = 0
                        Tmpb3 = Tmpb - 1
                        Tmpb2 = Val(cmdsplit(4))
                        If Tmpb2 = 0 Then
                           Reset Edhab.tmpb3
                        Else
                           Set Edhab.tmpb3
                        End If
                        Edhabeep = Edhab
                        Atsnd = "Se configuro HAB ED" + Str(tmpb) + "=" + Str(edhab.tmpb3)
                     Else
                        Cmderr = 5
                     End If

                  Case Else:
                     Cmderr = 0
                     Atsnd = " Hab entrada no implementado"
               End Select
            Else
               Cmderr = 4
            End If

         Case "LEEHAB"
            Select Case Numpar
               Case 1:
                  Cmderr = 0
                  Atsnd = "Hab ED=" + Bin(edhab)
               Case 2:
                  Tmpb2 = Val(cmdsplit(2))
                  Select Case Tmpb2
                     Case 1:                                'ED
                        Cmderr = 0
                        Atsnd = "Hab ED=" + Bin(edhab)
                     Case Else:
                        Cmderr = 0
                        Atsnd = "Tipo entrada no val"

                  End Select

               Case 3:
                  Tmpb2 = Val(cmdsplit(2))
                  Select Case Tmpb2:
                     Case 1:                                'ED
                        Tmpb = Val(cmdsplit(3))
                        If Tmpb > 0 And Tmpb < Ednum_masuno Then
                           Cmderr = 0
                           Tmpb3 = Tmpb - 1
                           Cmderr = 0
                           Atsnd = "HAB ED" + Str(tmpb) + "=" + Str(edhab.tmpb3)
                        Else
                           Cmderr = 5
                        End If
                     Case Else:
                        Cmderr = 0
                        Atsnd = "Hab entrada no valido"


                  End Select
               Case Else
                  Cmderr = 4
            End Select


         Case "SETPOL"
            If Numpar = 3 Then
               Tmpb = Val(cmdsplit(2))
               If Tmpb > 0 And Tmpb < Ednum_masuno Then
                  Cmderr = 0
                  Tmpb3 = Tmpb - 1
                  Tmpb2 = Val(cmdsplit(3))
                  If Tmpb2 = 0 Then
                     Reset Edpol.tmpb3
                  Else
                     Set Edpol.tmpb3
                  End If
                  Edpoleep = Edpol
                  Atsnd = "Se configuro POL ED" + Str(tmpb) + "=" + Str(edpol.tmpb3)
               Else
                  Cmderr = 5
               End If
            Else
               Cmderr = 4
            End If

         Case "LEEPOL"
            Select Case Numpar
               Case 1:
                  Cmderr = 0
                  Atsnd = "POL ED=" + Bin(edpol)
               Case 2:
                  Tmpb = Val(cmdsplit(2))
                  If Tmpb > 0 And Tmpb < Ednum_masuno Then
                     Tmpb3 = Tmpb - 1
                     Cmderr = 0
                     Atsnd = "POL ED" + Str(tmpb) + "=" + Str(edpol.tmpb3)
                  Else
                     Cmderr = 5
                  End If
               Case Else
                  Cmderr = 4
            End Select

         Case "SETPAR"
            If Numpar = 5 Then
               Tmpb = Val(cmdsplit(2))
               Tmpb2 = Val(cmdsplit(3))
               Tmpb3 = Val(cmdsplit(4))

               Select Case Tmpb
                  Case 1:                                   ' ED
                     If Tmpb2 > 0 And Tmpb2 < Ednum_masuno Then
                        Select Case Tmpb3
                           Case 1:                          'Nombre
                              Edname(tmpb2) = Cmdsplit(5)
                              Ednameeep(tmpb2) = Edname(tmpb2)
                              Cmderr = 0
                              Atsnd = "Se config nombre ED" + Str(tmpb2) + "=" + Edname(tmpb2)

                           Case 2:                          ' Polaridad
                              Tmpb4 = Val(cmdsplit(5))
                              If Tmpb4 < 2 Then
                                 J = Tmpb2 - 1
                                 If Tmpb4 = 0 Then
                                    Reset Edpol.j
                                 Else
                                    Set Edpol.j
                                 End If
                                 Edpoleep = Edpol
                                 Cmderr = 0
                                 Atsnd = "EDpol" + Str(tmpb2) + "=" + Str(edpol.j)
                              Else
                                 Cmderr = 0
                                 Atsnd = "Valor de polaridad no valido"
                              End If

                           Case 3:                          ' Tactivacion +
                              Tredmas(tmpb2) = Val(cmdsplit(5))
                              Tredmaseep(tmpb2) = Tredmas(tmpb2)
                              Cmderr = 0
                              Atsnd = "Se config Tactivacion + ED" + Str(tmpb2) + "=" + Str(tredmas(tmpb2)) + "x100 ms"

                           Case 4:                          'T activacion -
                              Tredmenos(tmpb2) = Val(cmdsplit(5))
                              Tredmenoseep(tmpb2) = Tredmenos(tmpb2)
                              Cmderr = 0
                              Atsnd = "Se config Tactivacion - ED" + Str(tmpb2) + "=" + Str(tredmenos(tmpb2)) + "x100 ms"


                           Case Else
                              Cmderr = 0
                              Atsnd = "Parametro ED no valido"

                        End Select
                     Else
                        Cmderr = 0
                        Atsnd = "Num ED no valido"
                     End If

                  Case 3:                                   'MODBUS
                     Cmderr = 0
                     Atsnd = "MODBUS no implementado en esta version"

                  Case Else:
                     Cmderr = 0
                     Atsnd = "Tipo de entrada incorrecto"

               End Select

            Else
               Cmderr = 4
            End If

         Case "LEEPAR"
            If Numpar = 3 Then
               Tmpb = Val(cmdsplit(2))
               Tmpb2 = Val(cmdsplit(3))
               Select Case Tmpb
                  Case 1:
                     Cmderr = 0                             'ED
                     If Tmpb2 > 0 And Tmpb2 < Ednum_masuno Then
                        J = Tmpb2 - 1
                        Atsnd = "ED" + Str(tmpb2) + ";Nombre=" + Edname(tmpb2) + ";POL=" + Str(edpol.j) + ";Tact+=" + Str(tredmas(tmpb2)) + "x100ms ;Tact-=" + Str(tredmenos(tmpb2)) + "x100ms"
                     Else
                        Cmderr = 0
                        Atsnd = "Num ED no valido"
                     End If

                  Case 3:                                   'MODBUS
                     Cmderr = 0
                     Atsnd = "MODBUS no implementado en esta version"
               End Select
            Else
               Cmderr = 4
            End If

         Case "SETAUX"
            Tmpb = Val(cmdsplit(2))
            If Tmpb > 0 And Tmpb < Numrelaux_masuno Then
               Tmpb2 = Val(cmdsplit(3))
               If Tmpb2 < 2 Then
                  If Tmpb2 = 0 Then
                     Reset Portb.tmpb
                  Else
                     Set Portb.tmpb
                  End If

               Else
                  Cmderr = 5
               End If
               Atsnd = "Se config Rel Aux " + Str(tmpb) + "=" + Str(tmpb2)
            Else
               Cmderr = 4
            End If

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
               Set Iniactclk
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

      If Iniactclk = 1 Then
         Reset Iniactclk
         Print #1 , "ACT CLK"
         Atsnd = "GETNTP,1,2,3"
         Tmpw = Len(atsnd)
         Tmpcrc32 = Crc32(atsnd , Tmpw)
         Atsnd = Atsnd + "&" + Hex(tmpcrc32)                '+ Chr(10)
         Print #1 , "%" ; Atsnd
         Print #3 , "%" ; Atsnd
      End If

      If Rpinew = 1 Then
         Reset Rpinew
         Print#1 , "RPItx>" ; Rpiproc
         Call Procrpi()
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
   Atsnd = Atsnd + "," + Str(ev5) + "," + Str(ev6) + "," + "," + Str(modo)
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
   Atsnd = Atsnd + "," + Str(enaprog) + "," + Str(tiemporiego) + "," + Str(tonnebul) + "," + Str(toffnebul)
   Tmpw = Len(atsnd)
   Tmpcrc32 = Crc32(atsnd , Tmpw)
   Atsnd = Atsnd + "&" + Hex(tmpcrc32) + Chr(10)
   Print #1 , "$" ; Atsnd
   Print #3 , "$" ; Atsnd
   Call Txrpi()

End Sub

Sub Tx3()
   Fechaed = Date$
   Horaed = Time$
   Atsnd = "D" + "," + Fechaed + "," + Horaed + "," + Idserial + "-3"
   Atsnd = Atsnd + "," + Str(evriego) + "," + Str(evozono) + "," + Str(evnebul) + "," + Str(evrecirc)
   Atsnd = Atsnd + "," + Str(evluzev) + "," + "," + "," +
   Tmpw = Len(atsnd)
   Tmpcrc32 = Crc32(atsnd , Tmpw)
   Atsnd = Atsnd + "&" + Hex(tmpcrc32) + Chr(10)
   Print #1 , "$" ; Atsnd
   Print #3 , "$" ; Atsnd
   Call Txrpi()
End Sub

Sub Tx4()

End Sub

Sub Gentrama()
   Tmpl = Hora_buf(ptrtx)
   Fechaed = Date(tmpl)
   Horaed = Time(tmpl)
   Atsnd = "D," + Fechaed + "," + Horaed + "," + Idserial + "-5"
   If Edhab.0 = 1 Then
      Tmpbit = Ed_buf(ptrtx).0
      Atsnd = Atsnd + "," + Str(tmpbit)
   Else
      Atsnd = Atsnd + ","
   End If
   If Edhab.1 = 1 Then
      Tmpbit = Ed_buf(ptrtx).1
      Atsnd = Atsnd + "," + Str(tmpbit)
   Else
      Atsnd = Atsnd + ","
   End If
   If Edhab.2 = 1 Then
      Tmpbit = Ed_buf(ptrtx).2
      Atsnd = Atsnd + "," + Str(tmpbit)
   Else
      Atsnd = Atsnd + ","
   End If
   If Edhab.3 = 1 Then
      Tmpbit = Ed_buf(ptrtx).3
      Atsnd = Atsnd + "," + Str(tmpbit)
   Else
      Atsnd = Atsnd + ","
   End If                                                   '+ Str(tmpbit)
   Atsnd = Atsnd + "," + ","
   Atsnd = Atsnd + ",,"

   Tmpw = Len(atsnd)
   Tmpcrc32 = Crc32(atsnd , Tmpw)
   Atsnd = Atsnd + "&" + Hex(tmpcrc32)                      ' + Chr(10)
   Print #1 , "$" ; Atsnd
   Print #3 , "$" ; Atsnd
   Call Txrpi()
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
'Subrutina para leer ED
'*******************************************************************************
Sub Leered()
   For Jed = 1 To Ednum
      If Edstaant(jed) <> Edsta(jed) Then
         Print #1 , "ED" ; Jed ; " de " ; Edstaant(jed) ; " a " ; Edsta(jed)
         Edstaant(jed) = Edsta(jed)
      End If
   Next

   For Tmped = 0 To Ednum_1
      Jed = Tmped + 1
      If Edhab.tmped = 1 Then
         Tmpbit = Pina.tmped Xor Edpol.tmped
         If Evmas.tmped = 1 Then
            Reset Evmas.tmped
            Tmpl = Syssec()
            Horaed = Time$
            Fechaed = Date$
            Hora_buf(ptrbuf) = Tmpl
            Print #1 , "Nuevo evento Mas en ED" ; Jed ; ";" ; Fechaed ; ";" ; Horaed
            If Iniprocbat = 1 Then
'               Gwsproc = Gwsproc + "," + Fusing(vinval , "#.##")
               Vin_buf(ptrbuf) = Vinval
               Vbat_buf(ptrbuf) = Vbatval
            End If
            Tmpbit = Ed0 Xor Edpol.0
            Ed_buf(ptrbuf).0 = Tmpbit
            Tmpbit = Ed1 Xor Edpol.1
            Ed_buf(ptrbuf).1 = Tmpbit
            Tmpbit = Ed2 Xor Edpol.2
            Ed_buf(ptrbuf).2 = Tmpbit
            Tmpbit = Ed3 Xor Edpol.3
            Ed_buf(ptrbuf).3 = Tmpbit
            Tx_buf(ptrbuf) = 1
            Ptrbuf = Ptrbuf Mod Numbuf
            Incr Ptrbuf
            Print #1 , "PTRBUF+=" ; Ptrbuf
         End If
         If Evmenos.tmped = 1 Then
            Reset Evmenos.tmped
            Tmpl = Syssec()
            Hora_buf(ptrbuf) = Tmpl
            Horaed = Time$
            Fechaed = Date$
            Print #1 , "Nuevo evento Menos en ED" ; Jed ; ";" ; Fechaed ; ";" ; Horaed
            If Iniprocbat = 1 Then
'               Gwsproc = Gwsproc + "," + Fusing(vinval , "#.##")
               Vin_buf(ptrbuf) = Vinval
               Vbat_buf(ptrbuf) = Vbatval
            End If
            Tmpbit = Ed0 Xor Edpol.0
            Ed_buf(ptrbuf).0 = Tmpbit
            Tmpbit = Ed1 Xor Edpol.1
            Ed_buf(ptrbuf).1 = Tmpbit
            Tmpbit = Ed2 Xor Edpol.2
            Ed_buf(ptrbuf).2 = Tmpbit
            Tmpbit = Ed3 Xor Edpol.3
            Ed_buf(ptrbuf).3 = Tmpbit
            Tx_buf(ptrbuf) = 1
            Ptrbuf = Ptrbuf Mod Numbuf
            Incr Ptrbuf
            Print #1 , "PTRBUF-=" ; Ptrbuf
         End If
      End If
   Next

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