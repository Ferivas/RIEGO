import time
import network
import _thread
#from umqtt.simple import MQTTClient
from tb_device_mqtt import TBDeviceMqttClient
import machine
import wifimgr
from machine import UART
from machine import Pin
import ntptime
import json
import urequests as requests
import ubinascii


#Constantes
FILECNTR="cntrs.txt"
TOPCNTRWIFI=121
ntptime.host = "pool.ntp.org"
FORMATO1="%d/%m/%y,%H:%M:%S"
FILECONFIG="txtb.json"
KEYSAPI="keysapi.txt"

#Pines
ledwifi=Pin(12,Pin.OUT)
ledwifi.value(0)
led=Pin(2,Pin.OUT)
led.value(1)

print("Conectando a WiFi")
try:
    profiles = wifimgr.read_profiles()
    print(profiles)
except:
    print("Sin profiles todavia")

wlan = wifimgr.get_connection()

if wlan is None:
    print("Could not initialize the network connection.")
    while True:
        pass  # you shall not pass :D


print("Buscando conf inicial")
try:
    with open(FILECONFIG,'r') as f:
        varconfig=json.load(f)
    print("Var file encontrado")
except:
    print("Inicializando conf inicial")
    varconfig={"runpi":False,"archivo":"DevicesTB.csv","mqttsrv":"thingsboard.cloud","token":"TOKEN",
               "urlbase":"thingsboard.cloud"}
    print("Guardando Var file")
    with open(FILECONFIG,'w') as f:
        json.dump(varconfig,f) 



archivo=varconfig.get("archivo")
print("Lee Archivo configuracion Thingsboard")
with open(archivo, "r",encoding='utf-8') as listaib:
    listaibt=listaib.readlines()
    listaibt=listaibt[1:] 

print(listaibt)

URL=varconfig.get("urlbase")
print("URLbase=",URL)
THINGSBOARD_HOST = varconfig.get("mqttsrv")  # Cambia si usas tu propio servidor
ACCESS_TOKEN = varconfig.get("token")

ledwifi.value(1)
# Main Code goes here
wifi_sta = network.WLAN(network.STA_IF)

# Configuración ThingsBoard


# Configuración GPIOs
led = machine.Pin(2, machine.Pin.OUT)

def getntptime():
     print("Hora inicial:", time.localtime()) 
     ntptime.settime () # set the RTC's time using ntptime
     tval=ntptime.time()
     tval=tval-18000
     #tfloat=float(tval)
     tclk = time.localtime (tval)
     print(tclk)
     anio=str(tclk[0])
     if tclk[1]>9:
         mes=str(tclk[1])
     else:
         mes="0"+str(tclk[1])
     if tclk[2]>9:
         dia=str(tclk[2])
     else:
         dia="0"+str(tclk[2])
     if tclk[3]>9:
         hora=str(tclk[3])
     else:
         hora="0"+str(tclk[3])
     if tclk[4]>9:
         minu=str(tclk[4])
     else:
         minu="0"+str(tclk[4])
     if tclk[5]>9:
         seg=str(tclk[5])
     else:
         seg="0"+str(tclk[5])
         
     cmdclk=dia+mes+anio[2:]+hora+minu+seg
     print(cmdclk)
     salida='%SETMBD;SETCLK,'+cmdclk+'\r\n'
     #salida='%SETDAA;SETCLK,'+cmdclk
     print(salida)
     ser.write(salida)


# Callback para manejar RPCs de ThingsBoard
def rpc_callback(request_id, request_body):
    global newrpc
    global rqid
    global rqbody 
    global params
    newrpc=True
    rqid=request_id
    rqbody=request_body
    params=False

    print(f"RPC recibido: {request_body}")
    print("ri>",request_id,";",type(request_id))
    print("rb>",request_body,";",type(request_body))

    # if request_body['method'] == 'setValue':  # RPC desde el dashboard de TB
    #     params = request_body.get('params', False)  # Obtener True/False
    #     led.value(1 if params else 0)
    #     print("LED ENCENDIDO" if params else "LED APAGADO")

        # Responder a ThingsBoard
        #client.send_rpc_call(request_id, {"status": "ok", "led": params},rpc_callback)

# Hilo para manejar mensajes MQTT sin bloquear el programa principal
#error_hilo  = False
cntr_errhilo=0
def mqtt_listener():
    global cntr_errhilo 
    while True:
        try:
            client.wait_for_msg()
            time.sleep(0.1)  # Pequeña pausa para evitar consumir demasiados recursos
            #raise ValueError("¡Error en el hilo!") 
        except Exception as e:
  #          error_hilo = e
             time.sleep(1)
             cntr_errhilo=cntr_errhilo+1
             print("Err listener>",e,",",cntr_errhilo)
             if cntr_errhilo==120:
                 print("Reset ESP32")
                 machine.reset()
                 

cntrmdc=0
flagseg=False
#cntrini=0
#cntrcmdtb=0

#****************************************************************
#   Pines y configuracion
#****************************************************************
#led=Pin(22,Pin.OUT)

ser = UART(2,tx=17,rx=16,timeout=1)
timer = machine.Timer(1) 

# Funciones
def sndposttb(token,url,msgbuffer):
    postok=False
    urlb="https://"+url+"/api/v1/"+token+"/telemetry"
    print(urlb)
    request_headers = {"Content-Type":"application/json"}
    print(msgbuffer)
    try:
        response = requests.post(urlb,headers=request_headers,json=msgbuffer)
        print(response.status_code)
        result=response.json
        print(result)
        postok=True
        if response.status_code == 200:
            print('TX IOT OK')
        else:
            print("Error code %s" % response.status_code)
        response.close()
    except:
        print("Err")
        postok=False
    return postok

def fecha_a_unix(fecha_str, formato=FORMATO1):
    # Extraer los valores de la fecha manualmente
    año = int("20"+fecha_str[6:8])
    mes = int(fecha_str[3:5])
    dia = int(fecha_str[0:2])
    hora = int(fecha_str[9:11])
    minuto = int(fecha_str[12:14])
    segundo = int(fecha_str[15:17])

    # Convertir a timestamp usando time.mktime()
    timestamp = time.mktime((año, mes, dia, hora, minuto, segundo, 0, 0, 0))
    timestamp=timestamp+946684800+18000
    timestamp=round(timestamp*1000)
    return timestamp        
    
   
def write_cntr(cntrini,cntrcmd,filename):
    with open(filename, "w") as f:
        salida=cntrini+','+cntrcmd
        f.write(salida)
        f.close()
        
def read_cntr(filename):
    with open(filename) as f:
        llaves=f.readlines()
        cntrs=llaves[0].split(',')
        return cntrs
    
def readkeys():
    with open(KEYSAPI) as f:
        lines = f.readlines()
    keysiot = {}
    for line in lines:
        idserial, apikeyiot = line.strip("\n").split(";")
        keysiot[idserial] = apikeyiot
    return keysiot


def writekeys(keysiot):
    lines = []
    for idserial, apikeyiot in keysiot.items():
        lines.append("%s;%s\n" % (idserial, apikeyiot))
    with open(KEYSAPI, "w") as f:
        f.write(''.join(lines))    


#****************************************************************
#INTERRUPCIONES
#****************************************************************
timerflag=False
cntrt=0

stawifi=True
#flagseg=False
def handleInterrupt(timer):
  global cntrdmseg
  global tled
  global timerflag
  global cntrt
  global flagseg
  cntrt=cntrt+1
  if cntrt==0:
    timerflag=True
  tled=tled+1
  tled=tled%16
  cntrdmseg=cntrdmseg+1
  cntrdmseg=cntrdmseg%10
  if cntrdmseg==0:
      flagseg=True
  if stawifi:
      if tled <1:
        led.value(1)
      else:
        led.value(0)
  else:
      led.value(0)
      
      
#****************************************************************
#   PROGRAMA MAIN
#****************************************************************
print("MDC DITEC-TB 2025")
idserial=ubinascii.hexlify(machine.unique_id()).decode()
print(idserial)
led.value(1)

try:
    listakeys = readkeys()
except OSError:
    listakeys = {}
print("Llaves IOT")
print(listakeys)

try:
  cntrs=read_cntr(FILECNTR)
  print('CNTRS',cntrs)
  cntrini=int(cntrs[0])
  cntrini=cntrini+1
  cntrcmdtb=int(cntrs[1])
  print("cntrini=",cntrini)
  print("cntrcmdtb=",cntrcmdtb)
  write_cntr(str(cntrini),str(cntrcmdtb),FILECNTR)
except:
  write_cntr("0","0",FILECNTR)
  print('Sin configurar cntrs')
  cntrini=0
  cntrcmdtb=0 

try:
    profiles = wifimgr.read_profiles()
    print(profiles)
except:
    print("Sin profiles")

ser.init(9600, bits=8, parity=None, stop=1,timeout=1)
timer = machine.Timer(1) 
tled=0
cntrdmseg=0
timer.init(period=100, mode=machine.Timer.PERIODIC, callback=handleInterrupt)

txresp=False
arx=""
cntrwifi=0
print("NTP")
try:
    getntptime()
except:
    print("Err NTP")

     

# Conectar a ThingsBoard y manejar RPCs
global client

try:    
    # Iniciar conexión MQTT
    print("Conexion Thingsboards")
    client = TBDeviceMqttClient(THINGSBOARD_HOST, access_token=ACCESS_TOKEN)
    client.connect()
except:
    print("Err conexion TB")    

# Suscribirse a RPCs
client.set_server_side_rpc_request_handler(rpc_callback)

# Iniciar el hilo para escuchar mensajes MQTT en segundo plano
_thread.start_new_thread(mqtt_listener, ())

# Bucle principal para otras tareas
cntr=0
newrpc=False
rqid=""
rqbody={}
tramaant=""
while True:
  try:
    arxb=ser.readline()
  except:
    arxb=None
  if arxb!=None:
    try:
      arx=str(arxb.decode("ascii"))
    except:
      arxb=None
    if len(arx)>0:
      if arx[0]=='$':
        print(arx)
        #salida="$OK"
        arx1=arx[1:]
        lista=arx1.split('&')
        if len(lista)==2:
          print(lista[1])
          datob=str.encode(lista[0])
          crccalc=ubinascii.crc32(datob)
          print("CRCcal=",crccalc)    
          crcval='0x'+lista[1]
          try:
            crcdec=int(crcval,0)
          except:
            crcdec=0
          print("CRCrx=",crcdec)
          if crccalc==crcdec:
            print('CRC OK')
            salida='%OK\r\n'
            ser.write(salida)
            trama=lista[0].split(',')
            campos=["","","","","","","",""]
            if len(trama)==12:
                if lista[0]!=tramaant:
                    tramaant=lista[0]
                    valfeed=trama[4:]
                    fecha=trama[1]
                    hora=trama[2]
                    print("Trama IBT,",trama[0])
                    for iddata in listaibt: #1,81000001A3F8F401,677,FXKAIV0I2TTIVNLZ,TANQUERO,Juan Cevallos,1,,
                        daaid=iddata.split(",")
                        idtrama=trama[3]
                        if daaid[1]==idtrama:
                            apikey=daaid[2]
                            #print("Token>",apikey)
                            fields=daaid[4:12]
                            print(fields)
                            payload={}
                            fechatb=fecha+','+hora
                            print(fechatb)
                            unix_time = fecha_a_unix(fechatb)
                            valdata={}
                            n=0
                            #print("D1")
                            if trama[0]!="D":
                                for fval in fields:
                                    #print(n)
                                    if fval!="" and valfeed[n]!="" and valfeed[n]!="ERR1":
                                        #print("fval>",fval,", val>",valfeed[n])
                                        try:
                                            valdata[fval]=float(valfeed[n])
                                        except:
                                            print("Err formato")
                                    n=n+1
                            else:
                                for fval in fields:
                                    #print(n)
                                    if fval!="" and valfeed[n]!="":
                                        #print("fval>",fval,", val>",valfeed[n])
                                        if valfeed[n]=="0":
                                            valdata[fval]=False
                                        elif valfeed[n]=="1":
                                            valdata[fval]=True
                                        else:
                                            print("No data dig val")
                                    n=n+1
                                
                            #print("Valdata",valdata)    
                            payload={"ts":unix_time, "values":valdata}
                            print(payload)
                            #postok=sndposttb(apikey,URL,payload)
                            try:
                                print("TX TB")
                                client.send_telemetry(payload)
                                print("fin tx tb")
                                salida='%OKW\r\n'
                                ser.write(salida)
                            except:
                                salida='%ERRW\r\n'
                                ser.write(salida)
                            print(salida)
                                
                            # if postok:
                            #   salida='%OKW\r\n'
                            #   ser.write(salida)
                            # else:
                            #   salida='%ERRW\r\n'
                            #   ser.write(salida)                        
                else:
                    print("No proc trama igual")
            else:
                print("Trama no valida")
          else:
            print('CRC ERROR')
            salida='%ERR\r\n'
            ser.write(salida)          
        else:
          print('SIN CRC')
      else:
        #salida='%ERR\r\n'
        #ser.write(salida)

        print('Sin $')
        if arx[0]=='%':
          arx1=arx[1:]
          lista=arx1.split(',')
          if len(lista)==4:
              cmdmain=lista[0].upper()
              if cmdmain=='SETKEY':
                print("Act lista llaves>",lista[1],",",lista[2])
                #addkeys(lista[1],lista[2],KEYSAPI)
                listakeys[lista[1]] = lista[2]
                writekeys(listakeys)
                print(listakeys)
                salida='%'+cmdmain+","+lista[1]+","+lista[2]+'\r\n'
                print(salida)
                ser.write(salida)
              if cmdmain=='LEEKEY':
                print("Lee lista llaves")
                listakeys = readkeys()
                print(listakeys)
                llavecita=listakeys.get(lista[1])
                if llavecita==None:
                    llavecita="None"
                salida='%'+cmdmain+","+lista[1]+","+llavecita+'\r\n'
                print(salida)
                ser.write(salida)
              if cmdmain=='LEEMDC':
                print("MDC MAC>",idserial)
                salida='%'+"MAC"+","+idserial+","+"ESP32"+'\r\n'
                print(salida)
                ser.write(salida)
              if cmdmain=='RESPTB':
                print("TBr>",lista[1],lista[2])
                valresp=[idserial, str(cntrini),str(cntrcmdtb),lista[1],lista[2],"","",""]
                print(valresp)
                txresp=True
                #sndlog(APIKEYLOG,valfeed)
              if cmdmain=='SETRED':
                  print("Set RED>",lista[1],",",lista[2])
                  profiles[lista[1]] = lista[2]
                  print(profiles)
                  wifimgr.write_profiles(profiles)
                  salida='%SETRED,'+lista[1]+","+lista[2]+'\r\n'
                  print(salida)
                  ser.write(salida)
              if cmdmain=='LEERED':
                 llavecita=profiles.get(lista[1])
                 if llavecita==None:
                    llavecita="None"
                 salida='%'+cmdmain+","+lista[1]+","+llavecita+'\r\n'
                 print(salida)
                 ser.write(salida)
              if cmdmain=='LEEPRG':
                  print("Recibo Nm estado prog",lista[1])
                 
                 
              if cmdmain=='GETNTP':
                  try:
                      getntptime()
                  except:
                      salida='%ERR,'+"NTP"+',D\r\n'
                      #salida='%ERR,'+"NTP"+',D'
                      print(salida)
                      ser.write(salida)                      

  


  if newrpc:
      newrpc=False
      print("Nuevo RPC")
      print("Rid:",rqid,", Rbody=",rqbody)
      if rqbody['method'] == 'setPrg':
          progval=rqbody['params']
          print("Nuevo Prog>",progval)
          salida="%SETMBD;SETPRG,"+str(progval)+"\r\n"
          print(salida)
          ser.write(salida)
      if rqbody['method'] == 'getPrg':
          salida="%SETMBD;LEEPRG"+"\r\n"
          print(salida)
          ser.write(salida)
      if rqbody['method'] == 'setCmd':
          cmdata=rqbody['params']
          cmd=cmdata.get("CMD")
          salida="%SETMBD;"+cmd+"\r\n"
          print(salida)
          ser.write(salida)          
          

  if flagseg:
    flagseg=False
    cntrmdc=cntrmdc+1
    tfx=cntrmdc%3600
    if tfx==0:
        print('Int',cntrmdc)
        
  if newrpc:
    newrpc=False
    print("New RPC")
    print("RQid>",rqid)
    print("RQbody>",rqbody)
    #client.send_rpc_call(rqid, {"status": "ok", "led": params},rpc_callback)

  # if error_hilo:
  #   print(f"El hilo falló con el error: {error_hilo}")       
  #   error_hilo=False

  if not wifi_sta.isconnected(): 
      stawifi=False
      if flagseg:
          cntrwifi=cntrwifi+1
          ft=cntrwifi%2
          if ft==0:
              print("CNTRwifi=",cntrwifi)
          if cntrwifi==TOPCNTRWIFI:
              print("Busca Red")
              wlan = wifimgr.get_connection()
              if wlan is None:
                print("Could not initialize the network connection.")
                while True:
                    pass  # you shall not pass :D              
          flagseg=False
          

# Ejecutar el script

