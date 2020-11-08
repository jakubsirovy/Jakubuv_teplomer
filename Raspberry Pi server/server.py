# -*- coding: utf-8 -*-
import mysql.connector
import urllib.request, json
import time, datetime
from datetime import timedelta
from flask import Flask, jsonify
from flask_cors import CORS
import codecs	                                                  		  #Import knihoven

mydb = mysql.connector.connect(
  host="****",
  user="****",
  password="****",
  database="****"
)                                                                                 #Udaje pro pripojeni k databazi

mydb.start_transaction(isolation_level='READ UNCOMMITTED')			  #Zajisti moznost refreshovani hodnot

html = codecs.open("/home/ubuntu/index.html", "r", "utf-8").read()		  #Import html souboru

while True:                                                                       #Nekonecna smycka
  app = Flask(__name__)
  app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True				  #Pretty print JSONu
  CORS(app)									  #CORS osetreni

  @app.route('/')								  #Homepage
  def index():
    return html									  #Vraci HTML importovane ze souboru

  @app.route('/api', methods=['GET'])						  #Api z ESP8266
  def api():
    try:
      with urllib.request.urlopen('http://192.168.88.247/api') as url:      	  #Deklarace URL adresy + zjisteni, zda je server online - okud je server online, vykona se cast kodu po "except"
        data = json.loads(url.read())                                             #Kopie JSONu
        return jsonify(data)							  #Vraci JSON na adrese serveru /api

    except:
      return None								  #Pokud nic neprijde z ESP8266, tak se nic nevrati na /api

  @app.route('/graph_api', methods=['GET'])					  #Api grafu
  def graph_api():
    try:
      with urllib.request.urlopen('http://192.168.88.247/api'):			  #Pokud je server online, vykona se cast kodu po "except"
        mycursor = mydb.cursor()						  #Kurzor databaze
        mycursor.execute("SELECT * FROM (SELECT * FROM Teplomer ORDER BY Id DESC LIMIT 10) t ORDER BY Id ASC;")		#Vyber z tabulky teplomer poslednich 10 zaznamu
        myresult = mycursor.fetchall()						  #Vykonej prikaz
        rowHeaders = ("id", "timestamp", "temperature", "pressure")		  #Nazvy sloupcu
        jsonData = []								  #Pole hodnot
        for x in myresult:							  #Pro kazdou hodnotu v poli...
          jsonData.append(dict(zip(rowHeaders, x)))				  #Vytvor JSON z pole
        return jsonify(jsonData)						  #Vrat JSON pomoci jsonify (i s hlavickou application/json)

    except:
      return None								  #Pokud je sever offline, nic nevracej

  if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)						  #Spust server na portu 80
