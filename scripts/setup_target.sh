#!/bin/bash

set -e

USER_HOME="/home/vboxuser"
PROJECT_ROOT="$USER_HOME/CyberSec25"
WEBAPP_DIR="$PROJECT_ROOT/webapp"
LIB_DIR="$WEBAPP_DIR/libs"

echo "[*] Installing dependencies..."
sudo apt update
sudo apt install -y wget unzip curl

echo "[*] Downloading Eclipse Temurin JDK 8u302..."
cd ~
wget -q --show-progress https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u232-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u232b09.tar.gz

echo "[*] Extracting JDK..."
tar -xzf OpenJDK8U-jdk_x64_linux_hotspot_8u232b09.tar.gz
sudo mkdir -p /opt/java
sudo mv jdk8u232-b09 /opt/java/java8u232

echo "[*] Configuring java and javac alternatives..."
sudo update-alternatives --install /usr/bin/java java /opt/java/java8u232/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /opt/java/java8u232/bin/javac 1
sudo update-alternatives --set java /opt/java/java8u232/bin/java
sudo update-alternatives --set javac /opt/java/java8u232/bin/javac

echo "[*] Java version set to:"
java -version

# Maak libs directory
echo "[*] Creating libs directory..."
mkdir -p "$LIB_DIR"
cd "$LIB_DIR"

# Jetty libraries
echo "[*] Downloading Jetty dependencies..."
JETTY_VER="9.4.44.v20210927"
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/$JETTY_VER/jetty-server-$JETTY_VER.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-servlet/$JETTY_VER/jetty-servlet-$JETTY_VER.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/$JETTY_VER/jetty-http-$JETTY_VER.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/$JETTY_VER/jetty-io-$JETTY_VER.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/$JETTY_VER/jetty-util-$JETTY_VER.jar
wget -nc https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-security/$JETTY_VER/jetty-security-$JETTY_VER.jar

# Log4j
echo "[*] Downloading Log4j 2.14.1..."
LOG4J_VER="2.14.1"
wget -nc https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/$LOG4J_VER/log4j-api-$LOG4J_VER.jar
wget -nc https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/$LOG4J_VER/log4j-core-$LOG4J_VER.jar

# Servlet API
echo "[*] Downloading javax.servlet-api..."
wget -nc https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar

# Compile Main.java
echo "[*] Compiling Main.java..."
cd "$WEBAPP_DIR"
javac -cp "libs/*" Main.java

# Start webapp
echo "[*] Starting vulnerable webapp on port 8080..."
java -Dcom.sun.jndi.ldap.object.trustURLCodebase=true \
     -cp "libs/*:." \
     -Dlog4j.configurationFile=log4j2.xml \
     Main &
WEBAPP_PID=$!
echo "[✔] Webapp gestart (PID: $WEBAPP_PID)"
echo "    Open in browser: http://localhost:8080"
