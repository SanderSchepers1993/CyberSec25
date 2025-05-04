#!/bin/bash
set -e

echo "[*] Fixing attacker setup for LDAP exploit..."

# Bepaal paden
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/..")"
LDAP_DIR="$PROJECT_ROOT/ldap"
LIB_DIR="$PROJECT_ROOT/webapp/libs"
LDAP_JAR="$LIB_DIR/unboundid-ldapsdk-4.0.14.jar"
LDAP_JAR_URL="https://repo1.maven.org/maven2/com/unboundid/unboundid-ldapsdk/4.0.14/unboundid-ldapsdk-4.0.14.jar"

# 1. libs-map aanmaken
if [ ! -d "$LIB_DIR" ]; then
    echo "[*] Creating libs directory..."
    mkdir -p "$LIB_DIR"
fi

# 2. JAR downloaden indien nodig
if [ ! -f "$LDAP_JAR" ]; then
    echo "[*] Downloading UnboundID LDAP SDK..."
    wget -O "$LDAP_JAR" "$LDAP_JAR_URL" || {
        echo "[-] Download failed. Check your network connection."
        exit 1
    }
else
    echo "[*] JAR already present: $LDAP_JAR"
fi

# 3. Compilatie
echo "[*] Compiling LDAPServer.java..."
cd "$LDAP_DIR"
javac -cp ".:$LDAP_JAR" LDAPServer.java || {
    echo "[-] Compilation failed."
    exit 1
}

# 4. LDAP-server starten
echo "[*] Starting LDAP server on port 1389..."
java -cp ".:$LDAP_JAR" LDAPServer
