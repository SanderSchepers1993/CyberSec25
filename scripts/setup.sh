#!/bin/bash

set -e

echo "Installing Java..."
sudo apt update
sudo apt install -y default-jdk wget

echo "[*] Preparing webapp environment"
cd "$(dirname "$0")/../webapp"

echo "[*] Creating libs/ folder..."
mkdir -p libs
cd libs

# Jetty dependencies
echo "Downloading Jetty JARs..."
wget -q https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/9.4.44.v20210927/jetty-server-9.4.44.v20210927.jar
wget -q https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-servlet/9.4.44.v20210927/jetty-servlet-9.4.44.v20210927.jar
wget -q https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/9.4.44.v20210927/jetty-http-9.4.44.v20210927.jar
wget -q https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/9.4.44.v20210927/jetty-io-9.4.44.v20210927.jar
wget -q https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.4.44.v20210927/jetty-util-9.4.44.v20210927.jar
wget -q https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-security/9.4.44.v20210927/jetty-security-9.4.44.v20210927.jar

# Log4j dependencies
echo "Downloading Log4j JARs..."
wget -q https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.14.1/log4j-api-2.14.1.jar
wget -q https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.14.1/log4j-core-2.14.1.jar

# Servlet API
echo "Downloading Servlet API JAR..."
wget -q https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar

cd ..

echo "Compiling Main.java..."
javac -cp "libs/*" Main.java

echo "[*] Starting vulnerable web app..."
java -cp ".:libs/*" -Dlog4j.configurationFile=log4j2.xml Main
echo "Starting vulnerable web app..."
echo "Visit http://localhost:8080 to test."
java -cp ".:libs/*" -Dlog4j.configurationFile=log4j2.xml Main
