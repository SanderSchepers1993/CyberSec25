#!/bin/bash
set -e

echo "[*] Installing Java and Python3..."
sudo apt update
sudo apt install -y default-jdk python3 wget

echo "[*] Preparing LDAP exploit environment..."

# Download LDAP dependency
mkdir -p webapp/libs
LDAP_JAR="webapp/libs/unboundid-ldapsdk-4.0.14.jar"
if [ ! -f "$LDAP_JAR" ]; then
    wget -q -O "$LDAP_JAR" https://repo1.maven.org/maven2/com/unboundid/unboundid-ldapsdk/4.0.14/unboundid-ldapsdk-4.0.14.jar
fi

# Compile exploit class
cd ..
cd exploit
javac Exploit.java
cd ..

# Start HTTP server
cd exploit
echo "[*] Starting HTTP server on port 8000..."
python3 -m http.server 8000 &
cd ..

# Compile and start LDAP server
cd ldap
javac -cp ".:../webapp/libs/unboundid-ldapsdk-4.0.14.jar" LDAPServer.java
echo "[*] Starting LDAP server on port 1389..."
java -cp ".:../webapp/libs/*:../webapp/libs/unboundid-ldapsdk-4.0.14.jar" LDAPServer
