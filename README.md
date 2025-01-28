# .bash_profile
```#----- AWS -------

LabInstallDedcrowd() {
echo "[x] DedCrowd Lab is installing... "

echo "  crtndstry is installing..."
cd git; git clone https://github.com/nahamsec/crtndstry.git


}


s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1
}

#---- Content discovery ----
thewadl(){ #this grabs endpoints from a application.wadl and puts them in yahooapi.txt
curl -s $1 | grep path | sed -n "s/.*resource path=\"\(.*\)\".*/\1/p" | tee -a /opt/thewadlApi_$1.txt
}

#----- recon -----
crtndstry(){
./opt/crtndstry/crtndstry $1
}

am(){ #runs amass passively and saves to json
amass enum --passive -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1-domains.txt
}

certprobe(){ #runs httprobe on all the hosts from certspotter
curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe | tee -a ./all.txt
}

mscan(){ #runs masscan
sudo masscan -p4443,2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,744$}
}

certspotter(){
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
} #h/t Michiel Prins

crtsh(){
curl -s https://crt.sh/?Identity=%.$1 | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$1" | sort -u | awk 'NF'
}

certnmap(){
curl https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1  | nmap -T5 -Pn -sS -i - -$
} #h/t Jobert Abma

ipinfo(){
curl http://ipinfo.io/$1
}


#------ Tools ------
dirsearch(){ runs dirsearch and takes host and extension as arguments
dirsearch.py -u $1 -e $2 -t 50 -b
}


ncx(){
nc -l -n -vv -p $1 -k
}

crtshdirsearch(){ #gets all domains from crtsh, runs httprobe and then dir bruteforcers
curl -s https://crt.sh/?q\=%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe -c 50 | grep https | xargs -n1 -I{} dirsearch -u {} -e $2 -t 50 -b
}

# ncx fonksiyonu
ncx() {
  nc -l -n -vv -p "$1" -k
}

# crtshdirsearch fonksiyonu
crtshdirsearch() { # gets all domains from crtsh, runs httprobe and then dir bruteforcers
  curl -s "https://crt.sh/?q=%.$1&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe -c 50 | grep https | xargs -n1 -I{} dirsearch -u {} -e "$2" -t 50 -b
}


# sqlx fonksiyonu
sqlx() {
  sudo sqlmap -u "$1" --batch --dbs --tamper=space2comment --technique=BEUST --level=3 --risk=3 --schema
}

ffr() {
  ffuf -w /root/myWordlists/raft-medium-directories.txt -u "$1" -fs "$2" -t 230
}

ffj() {
 ffuf -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt -u "$1" -fs "$2" -t 230
}

fft() {
  echo "URL: $1"
  echo "Filter Size: $2"
}

subx() {
  # Parametreler ve dosya adları
  domain="$1"
  output_file="wholesubs_$domain.txt"
  github_token=""

  # Başlangıç bildirimi
  echo "[*] Subdomain toplama işlemi başladı: $domain"

  # Alt alan adları için geçici dosyalar
  tmp_dir=$(mktemp -d)
  sublist3r_file="$tmp_dir/sub1.txt"
  subfinder_file="$tmp_dir/sub2.txt"
  assetfinder_file="$tmp_dir/sub3.txt"
  crt_file="$tmp_dir/sub4.txt"
  github_file="$tmp_dir/sub5.txt"

  # Subdomain toplama araçları
  echo "[*] Sublist3r çalışıyor..."
  sublist3r -d "$domain" -o "$sublist3r_file" 2>/dev/null

  echo "[*] Subfinder çalışıyor..."
  subfinder -d "$domain" -all -recursive -silent > "$subfinder_file"

  echo "[*] Assetfinder çalışıyor..."
  assetfinder --subs-only "$domain" > "$assetfinder_file"

  echo "[*] crt.sh sorgusu çalışıyor..."
  curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\\*\\.//g' > "$crt_file"

  echo "[*] GitHub subdomain sorgusu çalışıyor..."
  github-subdomains -t "$github_token" -d "$domain" -o "$github_file"

  # Tüm sonuçları birleştir
  echo "[*] Sonuçlar birleştiriliyor..."
  cat "$sublist3r_file" "$subfinder_file" "$assetfinder_file" "$crt_file" "$github_file" | sort -u > "$output_file"

  # Geçici dosyaları temizle
  rm -rf "$tmp_dir"

  echo "[+] Alt alan adları başarıyla toplandı ve doğrulandı!"
  echo "Sonuçlar: $output_file"
}

linx() {
  base_url=$(echo "$1" | awk -F/ '{print $3}')
  sudo python3 /opt/LinkFinder/linkfinder.py -i "$1" -r ^/ -o cli | awk -v base="$base_url" '{print "https://"base$0}'
}

dotdot() {
  local file="$1"
  local dot_count="${2:-4}"  # Varsayılan olarak 4
  local green='\033[0;32m'
  local reset='\033[0m'

  # Dosya mevcut değilse hiçbir şey döndürme
  [[ -f "$file" ]] || return

  # Belirtilen noktaları filtrele ve eşleşen satırları yeşil renkte göster
  grep -E "^([^\.]*\.){$dot_count}[^\.]*$" "$file" | while read -r line; do
    echo -e "${green}${line}${reset}"
  done

  # Toplam eşleşen satır sayısını yeşil renkte göster
  local count
  count=$(grep -E "^([^\.]*\.){$dot_count}[^\.]*$" "$file" | wc -l)
  [[ "$count" -gt 0 ]] && echo -e "${green}Length: ${count}${reset}"
}

403() {
  if [ -z "$1" ]; then
    echo "[!] Please provide a URL as the first argument. Usage: 403 <URL>"
    return 1
  fi

  bash /opt/4-ZERO-3/403-bypass.sh -u "$1" --exploit
}


cmder() {
echo "# S3 bucket listeleme
s3ls my-bucket-name

# S3 dosya kopyalama
s3cp my-bucket-name /path/to/local/file.txt

# WADL endpointlerini keşfetme
thewadl https://example.com/application.wadl

# crtndstry ile domain bilgisi çekme
crtndstry example.com

# Amass ile pasif tarama
am example.com

# CertSpotter ile domain tarama
certprobe example.com

# Masscan ile port tarama
mscan 192.168.1.0/24

# CertSpotter'dan domain bilgisi çekme
certspotter example.com

# CRT.sh sorgusu ile domain bilgisi çekme
crtsh example.com

# CertSpotter ve Nmap ile tarama
certnmap example.com

# IP bilgisi sorgulama
ipinfo 8.8.8.8

# Dirsearch ile dizin tarama
dirsearch https://example.com php

# Netcat listener başlatma
ncx 8080

# CRT.sh ve Dirsearch taraması
crtshdirsearch example.com php

# SQLMap ile tarama
sqlx https://example.com/vulnerable.php?id=1

# FFUF ile dizin tarama
ffr https://example.com/FUZZ 10256

# Alt alan adı toplama
subx example.com

# LinkFinder ile bağlantı keşfetme
linx https://example.com

# Dotdot araması
dotdot subdomains.txt 4

# 403 bypass tarama
403 https://example.com/protected

# gsp https://example.com  #if you want :  gsp https://example.com | grepping_words
"
}

gsp() {
gospider -d 9 --js -a --subs -s "$1" | grep "$2"
}
```
