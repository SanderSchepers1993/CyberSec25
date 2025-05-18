#!/bin/bash

set -e

echo "[*] Installing dependencies..."
sudo apt update
sudo apt install -y wget unzip curl

echo "[*] Downloading Eclipse Temurin JDK 8u beta from 2021-11-17..."
cd ~
wget --show-progress https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u-2021-07-26-19-42-beta/OpenJDK8U-jdk_x64_linux_hotspot_2021-07-26-19-42.tar.gz

echo "[*] Extracting JDK..."
tar -xzf OpenJDK8U-jdk_x64_linux_hotspot_2021-11-17-22-03.tar.gz
sudo mkdir -p /opt/java
sudo mv jdk8u322-b03 /opt/java/java8ubeta

echo "[*] Configuring java and javac alternatives..."
sudo update-alternatives --install /usr/bin/java java /opt/java/java8ubeta/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /opt/java/java8ubeta/bin/javac 1
sudo update-alternatives --set java /opt/java/java8ubeta/bin/java
sudo update-alternatives --set javac /opt/java/java8ubeta/bin/javac

echo "[*] Java version set to:"
java -version

echo "[*] Preparing vulnerable webapp..."
cd ~/CyberSec25/webapp

if [ ! -f "javax.servlet-api-4.0.1.jar" ]; then
    echo "[*] Downloading javax.servlet-api..."
    wget -q https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar
fi

echo "[*] Compiling Main.java..."
javac -cp .:javax.servlet-api-4.0.1.jar Main.java

echo "[*] Starting vulnerable webapp on port 8080..."
java -cp .:javax.servlet-api-4.0.1.jar Main
