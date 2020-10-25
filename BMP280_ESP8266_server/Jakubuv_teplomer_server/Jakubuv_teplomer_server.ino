#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP280.h>
#include <ArduinoJson.h>

#define SEALEVELPRESSURE_HPA (1013.25)    //tlak ve vysce 0 mnm

long thisTime;
long hour = 3600000;
long minute = 60000;
long second = 1000;

Adafruit_BMP280 bmp;                      //delkarace promenne pro knihovnu

float temperature, pressure;              //deklarace promennych a jejich datoveho typu
float tk = 4.9;                           //teplotni konstanta pro korekci teploty

const char* ssid = "RickyNet";            //zde zadejte SSID vasi wifi site
const char* password = "********";        //zde zadejte vase heslo k wifi

ESP8266WebServer server(80);              //zapnuti serveru na portu 80 
 
void setup() {
  Serial.begin(9600);                     //seriova komunikace - rychlost 9600 baudu
  delay(100);                             //pockej 100 ms
  
  bmp.begin(0x76);                        //I2C adresa senzoru teploty BMP280

  Serial.println("");
  Serial.println((String)"Připojování k WiFi síti "+ssid);

  WiFi.softAPdisconnect(true);            //nezapne AP mod, nevytvori vlastni wifi
  WiFi.begin(ssid, password);             //pripoji se k vasi lokalni wifi siti

  //zkontroluje, zdali je pripojen k wifi
  while (WiFi.status() != WL_CONNECTED) {
  delay(1000);
  Serial.print(".");
  }
  Serial.println("");
  Serial.println((String)"Připojeno k síti "+ssid+"!");
  Serial.print("Lokální IP adresa teploměru: ");  Serial.println(WiFi.localIP());

  server.on("/", handle_OnConnect);         //kdyz server obdrzi pozadavek HTTP na ceste root (/), spusti funkci handle_OnConnect
  server.on("/api", handle_json);           //cesta /json
  server.onNotFound(handle_NotFound);       //co se ma provest, kdyz uzivatel vyhleda neznamou adresu

  server.begin();
  Serial.println("HTTP server běží");

}
void loop() {
  if(millis() < 14400000){                   //reset po dvou hodinach
  server.handleClient();
  Serial.println((String)"Temp: "+temperature+" °C, Pressure: "+pressure+" hPa");
  thisTime = millis();
  int hours = thisTime / hour;                       //the remainder from days division (in milliseconds) divided by hours, this gives the full hours
  int minutes = (thisTime % hour) / minute ;         //and so on...
  int seconds = ((thisTime % hour) % minute) / second;
  Serial.println((String)"Time: "+hours+":"+minutes+":"+seconds);
  delay(1000);
  }
  else
  ESP.reset();                              //prikaz pro reset
}

void handle_json() {
  temperature = bmp.readTemperature() - tk;
  pressure = bmp.readPressure() / 100.0F;
  
  String jsonData;
  DynamicJsonDocument doc(256);
  doc["temperature"] = temperature;
  doc["pressure"] = pressure;
  serializeJsonPretty(doc, jsonData);
  server.sendHeader("Access-Control-Max-Age", "10000");
  server.sendHeader("Access-Control-Allow-Methods", "POST,GET,OPTIONS");
  server.sendHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.send(200, "application/json", jsonData);
  }

void handle_OnConnect() {
  server.send(200, "text/html", SendHTML());
}

void handle_NotFound(){
  server.send(404, "text/plain", "404 error");
}

String SendHTML(){
  String html ="<html> <head> <meta charset='UTF-8'> <title>Jakubův teploměr</title> <meta name='viewport' content='width=device-width, initial-scale=1.0'> <link href='https://fonts.googleapis.com/css?family=Open+Sans:300,400,600' rel='stylesheet'> <script> async function get() { let url = 'http://109.183.224.100:2222/api'; let obj = await (await fetch(url)).json(); return obj; } var jsonData; function parsedata() { (async () => { jsonData = await get(); var jsonObj = JSON.parse(JSON.stringify(jsonData)); document.getElementById('temperature').innerHTML = jsonObj.temperature.toFixed(1); document.getElementById('pressure').innerHTML = jsonObj.pressure.toFixed(0); })() } setTimeout(parsedata, 0); setInterval(parsedata, 5000); </script> <style> html {font-family: 'Open Sans', sans-serif;display: block;margin: 0px auto;text-align: center;color: #444444;} body {margin: 0px;} h1 {margin: 50px auto 30px;} .data {margin: 20px;padding: 10px;background-color: rgb(240, 240, 240);border-radius: 20px;} .text {font-weight: 600;font-size: 19px;} .reading {font-weight: 300;font-size: 50px;} .temperature {color: #5479f3;} .pressure {color: #8b67ec;} .superscript {font-size: 20px;font-weight: 400;vertical-align: super;} .celsius {left: 130px;} .hPa {left: 160px;} .container {display: table;margin: 0 auto;} .icon {width: 65px; height: 54px;} #svg_2 {margin-top: 7px;} .inline {display: inline;} .wrapper {display: flex;} .info {padding: 0 40px 0 10px;float: left;} .value {padding: 0 10px 0 5px;float: right;} </style> </head> <body> <h1>Jakubův pokojový teploměr</h1> <div class='container'> <div class='data temperature wrapper'> <div class='info'> <div class='icon'> <svg enable-background='new 0 0 19.438 54.003' height=54.003px id=svg_1 version=1.1 viewBox='0 0 19.438 54.003' width=19.438px x=0px xml:space=preserve xmlns=http://www.w3.org/2000/svg xmlns:xlink=http://www.w3.org/1999/xlink y=0px> <g><path d='M11.976,8.82v-2h4.084V6.063C16.06,2.715,13.345,0,9.996,0H9.313C5.965,0,3.252,2.715,3.252,6.063v30.982C1.261,38.825,0,41.403,0,44.286c0,5.367,4.351,9.718,9.719,9.718c5.368,0,9.719-4.351,9.719-9.718c0-2.943-1.312-5.574-3.378-7.355V18.436h-3.914v-2h3.914v-2.808h-4.084v-2h4.084V8.82H11.976z M15.302,44.833c0,3.083-2.5,5.583-5.583,5.583s-5.583-2.5-5.583-5.583c0-2.279,1.368-4.236,3.326-5.104V24.257C7.462,23.01,8.472,22,9.719,22s2.257,1.01,2.257,2.257V39.73C13.934,40.597,15.302,42.554,15.302,44.833z' fill=#5479f3 /></g> </svg> </div> <div class='text temperature'>Teplota</div> </div> <div class='value'> <div class='reading'> <span><p id='temperature' class='inline'>-</p><p class='superscript celsius inline'> &deg;C</p></span> </div> </div> </div> <div class='data pressure wrapper'> <div class='info'> <div class='icon'> <svg enable-background='new 0 0 40.542 40.541' height=40.541px id=svg_2 version=1.1 viewBox='0 0 40.542 40.541' width=40.542px x=0px xml:space=preserve xmlns=http://www.w3.org/2000/svg xmlns:xlink=http://www.w3.org/1999/xlink y=0px> <g><path d='M34.313,20.271c0-0.552,0.447-1,1-1h5.178c-0.236-4.841-2.163-9.228-5.214-12.593l-3.425,3.424c-0.195,0.195-0.451,0.293-0.707,0.293s-0.512-0.098-0.707-0.293c-0.391-0.391-0.391-1.023,0-1.414l3.425-3.424c-3.375-3.059-7.776-4.987-12.634-5.215c0.015,0.067,0.041,0.13,0.041,0.202v4.687c0,0.552-0.447,1-1,1s-1-0.448-1-1V0.25c0-0.071,0.026-0.134,0.041-0.202C14.39,0.279,9.936,2.256,6.544,5.385l3.576,3.577c0.391,0.391,0.391,1.024,0,1.414c-0.195,0.195-0.451,0.293-0.707,0.293s-0.512-0.098-0.707-0.293L5.142,6.812c-2.98,3.348-4.858,7.682-5.092,12.459h4.804c0.552,0,1,0.448,1,1s-0.448,1-1,1H0.05c0.525,10.728,9.362,19.271,20.22,19.271c10.857,0,19.696-8.543,20.22-19.271h-5.178C34.76,21.271,34.313,20.823,34.313,20.271z M23.084,22.037c-0.559,1.561-2.274,2.372-3.833,1.814c-1.561-0.557-2.373-2.272-1.815-3.833c0.372-1.041,1.263-1.737,2.277-1.928L25.2,7.202L22.497,19.05C23.196,19.843,23.464,20.973,23.084,22.037z' fill=#8b67ec /></g> </svg> </div> <div class='text pressure'>Tlak</div> </div> <div class='value'> <div class='reading'> <span><p id='pressure' class='inline'>-</p><p class='superscript hPa inline'> hPa</p></span> </div> </div> </div> </div> </body> </html>";
  return html;
}
