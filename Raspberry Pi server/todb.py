import mysql.connector
import urllib.request, json
import time, datetime                                                             #Import knihoven

mydb = mysql.connector.connect(
  host="localhost",
  user="****",
  password="****",
  database="****"
)                                                                                 #Udaje pro pripojeni k databazi

while True:                                                                       #Nekonecna smycka
  if datetime.datetime.now().minute == 0:                                         #Vykonej kazdou hodinu
    req = urllib.request.Request('http://192.168.88.247/api')                     #Zjisti, zdali je server online. Pokud neni, skoci na except (radek 25)
    try: 
      with urllib.request.urlopen('http://192.168.88.247/api') as url:            #Deklarace URL adresy
        data = json.loads(url.read().decode())                                    #Dekodovani JSONu
        tmp = data['temperature']                                                 #Promenna pro teplotu
        pre = data['pressure']                                                    #Promenna pro tlak

        mycursor = mydb.cursor()                                                  #Deklarace promenne
        mycursor.execute("INSERT INTO teplomer (timestamp, temperature, pressure) VALUES (UNIX_TIMESTAMP(), %s, %s);", (tmp, pre))   #SQL dotaz, ktery vklada na SQL server data
        mydb.commit()                                                             #Vykonani                                                             
        mycursor.execute("SELECT max(Id) FROM Teplomer;")			                    #Vyber posledni id z tabulky teplomer
        myresult = mycursor.fetchall()						                                #Proved prikaz
        for x in myresult:							                                          #Pro kazdou hodnotu v poli...
          if x[0]>12:								                                              #Pokud je pocet zaznamu z SQL vetsi nez 10, proved odsazenou cast kodu
            mycursor = mydb.cursor()						                                  #Kurzor databaze
            mycursor.execute("DELETE FROM teplomer WHERE id=(SELECT maxo FROM (SELECT MAX(id)-13 AS maxo FROM teplomer) AS tmp);")	  #Vymaz z tabulky teplomer posledni zaznam (nejstarsi), aby v tabulce zbylo 12 zaznamu
            mydb.commit()							                                            #Proved
        print(mycursor.rowcount, 'Zaznam uspesne vlozen. ' + str(datetime.datetime.now().hour) + ':' + str(datetime.datetime.now().minute))	#Hlaska o uspesnem vlozeni dat

    except urllib.error.URLError as e:                                            #Tato cast kodu se vykona, pokud je server offline
      print(e.reason)                                                             #Vypis chyby

  time.sleep(60)                                                                  #Pockej 60 sekund, aby se na SQL server nanahrava jedna vec 2x za minutu