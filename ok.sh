#bash -c "$(curl -L https://raw.githubusercontent.com/oamca/computer_book_list/main/ok.sh)" @ install -u root
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
apt update
apt install curl nano ufw -y
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
rm /usr/local/etc/xray/config.json
#nano /usr/local/etc/xray/config.json
cat << EOF > /usr/local/etc/xray/config.json
{
    "log": {
        "loglevel": "none",
      "access":"access.log",
      "error":"error.log"
    },
    "inbounds": [
        {
            "port":8080,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "54679b8c-6d07-4f49-97b7-538ebce2a812", 
                        "level": 1,
                        "email": "noreply@gmail.com",
                        "alterId":0
                    }
                ],
                "disableInsecureEncryption": true,
                "decryption": "auto"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/fastssh" 
                }                
            }
        },
      {
         "port":80,
         "protocol":"vmess",
         "settings":{
            "clients":[
               {
                  "id":"54679b8c-6d07-4f49-97b7-538ebce2a812",
                  "level":1,
                  "email":"noreply@gmail.com",
                  "alterId":0
               }
            ],
            "disableInsecureEncryption":true,
            "decryption":"auto"
         },
         "streamSettings":{
            "network":"tcp",
            "security":"none",
            "tcpSettings":{
               "acceptProxyProtocol":false,
               "header":{
                  "type":"http",
                  "response":{
                     "version":"1.1",
                     "status":"200",
                     "reason":"OK",
                     "headers":{
                        "Content-Type":[
                           "application/octet-stream",
                           "video/mpeg",
                           "text/html"
                        ],
                        "Transfer-Encoding":[
                           "chunked"
                        ],
                        "Connection":[
                           "keep-alive"
                        ],
                        "Pragma":"no-cache"
                     }
                  }
               }
            }
         }
      }
    ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },    
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    }
  ]
}
EOF

cat << EOF > /usr/bin/s.sh
ufw status numbered
echo "begin with 1: "
read numdel
ufw delete $numdel
#myip="\${SSH_CLIENT%% *}"
#myip=$(echo $SSH_CLIENT | awk '{print $1}')
#myip=$(who | awk '{print $5}' | cut -d'(' -f2 | cut -d')' -f1)
client_ip=$(echo $SSH_CLIENT | awk '{ print $1}')
ufw allow from $client_ip
#ufw allow from $SSH_CLIENT
#ufw allow from \${myip}
ufw status verbose
EOF
chmod +x /usr/bin/s.sh

ufw allow 22
#echo "port 22" >> /etc/ssh/sshd_config
nano /etc/ssh/sshd_config
service ssh restart
ss -tulpn
echo "******************************"
echo "*  1. ufw allow (ssh port)   *"
echo "*  2. ufw enable             *"
echo "*  3. service xray restart   *"
echo "******************************"
