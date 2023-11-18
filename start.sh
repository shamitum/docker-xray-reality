#!/bin/sh

cd /xray

apk update
apk add --no-cache wget unzip
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip ./Xray-linux-64.zip
rm ./Xray-linux-64.zip

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
      "listen": "127.0.0.1",
      "port": 62789,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "sniffing": null,
      "streamSettings": null,
      "tag": "api"
    },
    {
      "listen": null,
      "port": 2053,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "email": "DSI",
            "flow": "",
            "id": "40b1623c-6cfe-44ef-b6f6-3e9aefc1f0c7"
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
          "dest": "twitter.com:443",
          "maxClient": "",
          "maxTimediff": 0,
          "minClient": "",
          "privateKey": "MC2OdYBuZCD3AtvAsDcJFrf0Lc4htF-uF9tKY86UwVw",
          "serverNames": [
            "twitter.com"
          ],
          "settings": {
            "fingerprint": "chrome",
            "publicKey": "MsWfgqMBMloiddLA4IRn3VOh-wwmnzDgbAurmGGxZWY",
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

./xray -c ./config.json
