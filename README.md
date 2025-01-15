# .bash_profile
```
#----- AWS -------

s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1 
}

#---- Content discovery ----
thewadl(){ #this grabs endpoints from a application.wadl and puts them in yahooapi.txt
curl -s $1 | grep path | sed -n "s/.*resource path=\"\(.*\)\".*/\1/p" | tee -a ~/tools/dirsearch/db/yahooapi.txt
}

#----- recon -----
crtndstry(){
./tools/crtndstry/crtndstry $1
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
python3 ~/tools/dirsearch/dirsearch.py -u $1 -e $2 -t 50 -b 
}

ncx(){
nc -l -n -vv -p $1 -k
}

crtshdirsearch(){ #gets all domains from crtsh, runs httprobe and then dir bruteforcers
curl -s https://crt.sh/?q\=%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe -c 50 | grep https | xargs -n1 -I{} python3 ~/tools/dirsearch/dirsearch.py -u {} -e $2 -t 50 -b 
}

# sqlx fonksiyonu
sqlx() {
  sudo sqlmap -u "$1" --batch --dbs --technique=space2comment -t BEUST --level=3 --risk=3 --schema
}

ffx() {
  ffuf -w /root/myWordlists/raft-medium-directories.txt -u "$1" -fs "$2" -t 230
}


fft() {
  echo "URL: $1"
  echo "Filter Size: $2"
}

subx() {
  # Parametreler ve dosya adları
  domain="$1"
  output_file="sub.$domain.txt"
  intermediate_file="intermediate_$domain.txt"
  github_token="ghp_TOKEN"

  # Başlangıç bildirimi
  echo "[*] Subdomain toplama işlemi başladı: $domain"

  # Paralel işlemlerle subdomain toplama
  (
    echo "[*] Sublist3r çalışıyor..."
    sublist3r -d "$domain" &>/dev/null
  ) > "$intermediate_file" &

  (
    echo "[*] Subfinder çalışıyor..."
    subfinder -d "$domain" -all -recursive -silent &>/dev/null
  ) >> "$intermediate_file" &

  (
    echo "[*] Assetfinder çalışıyor..."
    assetfinder --subs-only "$domain" &>/dev/null
  ) >> "$intermediate_file" &

  (
    echo "[*] crt.sh sorgusu çalışıyor..."
    curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' &>/dev/null
  ) >> "$intermediate_file" &

  echo "[+] Alt alan adları başarıyla toplandı ve doğrulandı!"
  echo "Sonuçlar: $intermediate_file"
}

linkx(){
  sudo python3 /opt/LinkFinder/linkfinder.py -i "$1" -r ^/ -o cli

```
