# -*- coding: utf-8 -*-
import mysql.connector
import urllib.request, json
import time, datetime
from datetime import timedelta
from flask import Flask, jsonify
from flask_cors import CORS
import codecs	                                                  		                    #Import knihoven

mydb = mysql.connector.connect(
  host="localhost",
  user="****",
  password="****",
  database="****"
)                                                                                       #Udaje pro pripojeni k databazi

mydb.start_transaction(isolation_level='READ UNCOMMITTED')			                        #Zajisti moznost refreshovani hodnot

html = codecs.open("/home/ubuntu/index.html", "r", "utf-8").read()		                  #Import html souboru

while True:                                                                             #Nekonecna smycka
  app = Flask(__name__)
  app.config["JSONIFY_PRETTYPRINT_REGULAR"] = True				                              #Pretty print JSONu
  CORS(app)									                                                            #CORS osetreni

  @app.route('/')								                                                        #Homepage
  def index():
    return html									                                                        #Vraci HTML importovane ze souboru

  @app.route("/api", methods=["GET"])						                                        #Api z ESP8266
  def api():
    return jsonify({"humidity": 52,"temperature": 23.6})							              #Vraci JSON na adrese serveru /api

  @app.route("/chart-api", methods=["GET"])					                                    #Api grafu
  def chart_api():
    mycursor = mydb.cursor()						                                                #Kurzor databaze
    mycursor.execute("SELECT * FROM (SELECT * FROM teplomer ORDER BY id DESC LIMIT 13) t ORDER BY id ASC;")		  #Vyber z tabulky teplomer poslednich 13 zaznamu
    myresult = mycursor.fetchall()						                                          #Vykonej prikaz
    rowHeaders = ("id", "timestamp", "temperature", "humidity")		                      #Nazvy sloupcu z tabulky
    jsonData = []								                                                        #Pole hodnot
    for x in myresult:							                                                    #Pro kazdou hodnotu v poli...
      jsonData.append(dict(zip(rowHeaders, x)))				                                  #Vytvor JSON z pole
    return jsonify(jsonData)						                                                #Vrat JSON pomoci jsonify (i s hlavickou application/json)

  if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)						                                        #Spust server na portu 80
