# Jak spustit server?
Příkaz pro screen mydb: `python3 todb.py`
Příkaz pro screen server: `sudo python3 server.py`

## Jednotlivé příkazy
Ke spuštění použít příkaz `screen -s mydb` (příkaz k vytvoření nové instance screenu).
K odpojení od screenu `CTRL` + `A` + `D` (proces zadaný ve screenu pojede i přes odpojení od screenu).
Po odpojení se ke screenu lze znovu připojit pomocí příkazu `screen -r mydb` a pokračovat v práci.
Screen běží i po odpojení od ssh.