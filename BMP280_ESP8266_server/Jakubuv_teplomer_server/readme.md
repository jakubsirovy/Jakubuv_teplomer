# ESP8266
Toto zařízení je malý wifi mikrokontroler, velikostně přibližně jako Arduino nano. Od Arduina se liší tím, že přímo na desce obsahuje wifi čip.
Toto zařízení v mém projektu slouží ke sběru dat. Čtyřmi vodiči je k němu připojený senzor teploty BMP280, který zaznamenává teplotu a tlak.
ESP8266 z tohoto senzoru sbírá data a vytváří z nich pole hodnot, které je následně převáděno na JSON. Na ESP8266 běží webový server (API), na které se uploaduje tento JSON.
