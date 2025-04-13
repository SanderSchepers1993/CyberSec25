# Project structure:
- Dockerfile
- log4shell-webapp/
  - src/
    - Main.java
    - web/
      - index.html
      
# Log4Shell Vulnerable Web Form Demo

This is a minimal Java web application that demonstrates the CVE-2021-44228 (Log4Shell) vulnerability using a web form and Log4j 2.14.1.  
It is meant for **educational and testing purposes only** in isolated environments.

# Warning
**Do not run this on public networks or production systems. This app is vulnerable to remote code execution (RCE).**

## Quick Start

### Requirements

- Docker installed
- Docker-cli installed

### Run in 3 steps

```bash
# 1. Clone the repository
git clone https://github.com/SanderSchepers1993/CyberSec25.git
cd CyberSec25

# 2. Build the Docker image
docker build -t log4shell-webform .

# 3. Run the container
docker run -p 8080:8080 log4shell-webform
