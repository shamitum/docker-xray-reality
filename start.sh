#!/bin/sh

cd /xray

apk update
apk add --no-cache wget unzip
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip ./Xray-linux-64.zip
rm ./Xray-linux-64.zip

if test -z "$CONFIG"
then
    PORT=${PORT:-2083}
    ID=${ID:-"d42e30bc-f02c-40c1-92b9-883739bf0dcf"}
    SNI=${SNI:-"twitter.com"}
    
    cat > ./config.json <<EOF
{
  "api": {
    "services": [
      "HandlerService",
      "LoggerService",
      "StatsService"
    ],
    "tag": "api"
  },
  "dns": null,
  "fakeDns": null,
  "inbounds": [
    {
      "listen": null,
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "email": "DSI",
            "flow": "",
            "id": "${ID}"
          }
        ],
        "decryption": "none",
        "fallbacks": []
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls",
          "quic",
          "fakedns"
        ],
        "enabled": true
      },
      "streamSettings": {
        "grpcSettings": {
          "multiMode": true,
          "serviceName": ""
        },
        "network": "grpc",
        "realitySettings": {
          "dest": "${SNI}:443",
          "maxClient": "",
          "maxTimediff": 0,
          "minClient": "",
          "privateKey": "YMxPCNI7tdE_DEeQJ6zUsxqxXwrP_dKrZRiVbqCTYVY",
          "serverNames": [
            "${SNI}"
          ],
          "settings": {
            "fingerprint": "chrome",
            "publicKey": "7SKzmBUoSMBTbm8P1pEXnA4ERSKp6hrwLXSh2ZnH3Hc",
            "serverName": "",
            "spiderX": "/"
          },
          "shortIds": [
            "1d78f5e7"
          ],
          "show": false,
          "xver": 0
        },
        "security": "reality"
      },
      "tag": "inbound-2053"
    }
  ],
  "log": {
    "error": "./error.log",
    "loglevel": "warning"
  },
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundDownlink": true,
      "statsInboundUplink": true
    }
  },
  "reverse": null,
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "blocked",
        "type": "field"
      },
      {
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ],
        "type": "field"
      }
    ]
  },
  "stats": {},
  "transport": null
}
EOF
else
    echo "$CONFIG" > ./config.json
fi

 ./xray -c ./config.json
