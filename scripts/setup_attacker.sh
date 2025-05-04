#!/bin/bash
set -e

echo "[*] Fixing attacker setup for LDAP exploit..."

# Pad naar de jar
LDAP_JAR="../webapp/libs/unboundid-ldapsdk-4.0.14.jar"
LDAP_JAR_URL="https://repo1.maven.org/maven2/com/unboundid/unboundid-ldapsdk/4.0.14/unboundid-ldapsdk-4.0.14.jar"

# 1. Maak libs-map aan indien nodig
if [ ! -d "../webapp/libs" ]; then
    echo "[*] Creating libs directory..."
    mkdir -p ../webapp/libs
fi

# 2. Download JAR als die ontbreekt
if [ ! -f "$LDAP_JAR" ]; then
    echo "[*] Downloading UnboundID LDAP SDK..."
    wget -O "$LDAP_JAR" "$LDAP_JAR_URL" || {
        echo "[-] Download failed. Check your network connection."
        exit 1
    }
else
    echo "[*] JAR already present: $LDAP_JAR"
fi

# 3. Compileer LDAPServer.java
echo "[*] Compiling LDAPServer.java..."
javac -cp ".:$LDAP_JAR" LDAPServer.java || {
    echo "[-] Compilation failed. Check for syntax errors or missing files."
    exit 1
}

echo "[+] Compilation successful. You can now run the LDAP server:"
echo "    java -cp \".:$LDAP_JAR\" LDAPServer"
