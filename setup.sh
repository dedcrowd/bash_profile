#!/bin/bash

# Sistem güncellemelerini yapıyoruz
echo "[*] Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Gerekli araçları kuruyoruz
echo "[*] Installing essential tools..."

# Git'i kuruyoruz
sudo apt install -y git

# Go ve Go modül yükleyici
echo "[*] Installing Go..."
sudo apt install -y golang

# Python ve pip'i kuruyoruz
echo "[*] Installing Python3 and pip..."
sudo apt install -y python3 python3-pip

# Curl, jq, nmap, masscan gibi araçları kuruyoruz
sudo apt install -y curl jq nmap masscan ffuf dirsearch amass sublist3r findomain assetfinder github-subdomains httprobe

# Subdomain ve URL araçlarını kuruyoruz
echo "[*] Installing Subdomain and URL tools..."
sudo apt install -y sublist3r subfinder assetfinder github-subdomains

# Burp Suite ve diğer tarayıcı araçları
echo "[*] Installing Burp Suite..."
sudo apt install -y burpsuite

# Nmap ve Masscan kurulumları
echo "[*] Installing Nmap and Masscan..."
sudo apt install -y nmap masscan

# SQLMap kuruyoruz
echo "[*] Installing SQLMap..."
sudo apt install -y sqlmap

# GoSpider kurulumunu yapıyoruz
echo "[*] Installing GoSpider..."
go get github.com/jaeles-project/gospider

# Nuclei kurulumunu yapıyoruz
echo "[*] Installing Nuclei..."
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Katana kurulumunu yapıyoruz
echo "[*] Installing Katana..."
go install github.com/projectdiscovery/katana/cmd/katana@latest

# ParamSpider kurulumu
echo "[*] Installing ParamSpider..."
git clone https://github.com/devanshbatham/ParamSpider.git /opt/ParamSpider

# Eyewitness kurulumu
echo "[*] Installing Eyewitness..."
git clone https://github.com/FortyNorthSecurity/EyeWitness.git /opt/EyeWitness

# Jaeles kurulumunu yapıyoruz
echo "[*] Installing Jaeles..."
go install github.com/jaeles-project/jaeles@latest

# Go'yu kuruyoruz
echo "[*] Installing Go..."
sudo apt install -y golang-go

# Xsstrike kurulumunu yapıyoruz
echo "[*] Installing Xsstrike..."
git clone https://github.com/UltimateHackers/XSStrike.git /opt/XSStrike

# Nmap ve Masscan yükleme
echo "[*] Installing masscan..."
sudo apt install -y masscan

# Nginx kurulumunu yapıyoruz
echo "[*] Installing Nginx..."
sudo apt install -y nginx

# gospider kurulumunu yapıyoruz
go install github.com/jaeles-project/gospider@latest

# Go modül araçları kuruyoruz
echo "[*] Installing Go modules..."
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/bitquark/shortscan/cmd/shortscan@latest

# Go-Subdomains installation
echo "[*] Installing GitHub Subdomain Finder..."
git clone https://github.com/gwendal-lecoguic/github-subdomains.git /opt/github-subdomains

# Eyewitness (screen capture tool)
git clone https://github.com/FortyNorthSecurity/EyeWitness.git /opt/EyeWitness

# Veritabanı yedekleme
echo "[*] Setting up aliases for better workflow..."
echo "alias linkfinder='python3 /opt/LinkFinder/linkfinder.py'" >> ~/.bashrc
echo "alias secure1='echo hu86c9k; openvpn /mnt/c/Users/Akif/Downloads/vpnbook-openvpn-de220/vpnbook-de220-tcp443.ovpn'" >> ~/.bashrc
echo "alias secure2='echo hu86c9k; openvpn /mnt/c/Users/Akif/Downloads/vpnbook-openvpn-de220/vpnbook-de220-tcp80.ovpn'" >> ~/.bashrc
echo "alias subx='subfinder -d'" >> ~/.bashrc
source ~/.bashrc

# GoAraçlar için bir klasör oluşturuyoruz
mkdir -p ~/go_tools && cd ~/go_tools

# Çeşitli tools yüklemelerini otomatikleştiriyoruz
echo "[*] Installing additional tools..."

# GoSpider için özel modül yükleyelim
go install github.com/jaeles-project/gospider@latest

# Setup bitiminde birkaç uyarı
echo "[*] Setup completed successfully!"

echo "[*] You can use the following commands: linkfinder, subx, sqlx, gospider, and many more!"

echo "[+] Enjoy your Penetration Testing environment!"
