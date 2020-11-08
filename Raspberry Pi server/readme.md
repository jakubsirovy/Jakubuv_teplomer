# Raspberry Pi server
Na Raspberry Pi běží SQL server a dva python programy.

## Jak spustit server?
Příkaz pro screen mydb: `python3 todb.py`  
Příkaz pro screen server: `sudo python3 server.py`

### Jednotlivé příkazy
Ke spuštění použít příkaz `screen -s mydb` (příkaz k vytvoření nové instance screenu).  
K odpojení od screenu `CTRL` + `A` + `D` (proces zadaný ve screenu pojede i přes odpojení od screenu).  
Po odpojení se ke screenu lze znovu připojit pomocí příkazu `screen -r mydb` a pokračovat v práci.  
Screen běží i po odpojení od ssh.

## todb.py
Todb.py je program, který zajišťuje nahrávání dat z teploměru na SQL server. Stará se o kopírování API teploměru na adresu serveru`/api`. Tato akce probíhá každou hodinu. Kromě toho data uloží na SQL server, kde záznam vydrží 12 hodin (v tabulce zůstává 13 záznamů).

## server.py
Tento program má za úkol upload API aktuální teploty `/api` a API grafu `/chart_api`. Mimo toho se stará o hosting hlavního HTML souboru.
