#!/bin/bash
set -e

echo "[*] Setting up target environment..."

# Pad-instellingen
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEBAPP_DIR="$PROJECT_ROOT/webapp"
LIB_DIR="$WEBAPP_DIR/libs"

# 1. Maak libs-map aan
mkdir -p "$LIB_DIR"
cd "$LIB_DIR"

# 2. Download Jetty JARs
echo "[*] Downloading Jetty dependencies..."
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/9.4.44.v20210927/jetty-server-9.4.44.v20210927.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-servlet/9.4.44.v20210927/jetty-servlet-9.4.44.v20210927.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/9.4.44.v20210927/jetty-http-9.4.44.v20210927.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/9.4.44.v20210927/jetty-io-9.4.44.v20210927.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.4.44.v20210927/jetty-util-9.4.44.v20210927.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-security/9.4.44.v20210927/jetty-security-9.4.44.v20210927.jar

# 3. Download Log4j 2.14.1 (kwetsbaar)
echo "[*] Downloading Log4j 2.14.1..."
wget -nc https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.14.1/log4j-api-2.14.1.jar
wget -nc https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.14.1/log4j-core-2.14.1.jar

# 4. Download Servlet API
wget -nc https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar

# 5. Compileer Main.java
echo "[*] Compiling Main.java..."
cd "$WEBAPP_DIR"
javac -cp "libs/*" Main.java

# 6. Start de webapp
echo "[*] Starting vulnerable webapp on port 8080..."
java -cp ".:libs/*" -Dlog4j.configurationFile=log4j2.xml Main &
WEBAPP_PID=$!

echo "[✓] Webapp gestart (PID: $WEBAPP_PID)"
echo "    Open in browser: http://localhost:8080"
