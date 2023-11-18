#!/bin/sh

cd /xray

apk update
apk add --no-cache wget unzip
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip ./Xray-linux-64.zip
rm ./Xray-linux-64.zip

cat > ./config.json <<EOF
{
    "log": {
        "loglevel": "info"
    },
    "inbounds": [
        {
            "tag": "VMess TCP",
            "listen": "0.0.0.0",
            "port": 8081,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "40b1623c-6cfe-44ef-b6f6-3e9aefc1f0c7"
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "tcpSettings": {
                    "header": {
                        "type": "http",
                        "request": {
                            "method": "GET",
                            "path": [
                                "/"
                            ],
                            "headers": {
                                "Host": [
                                    "google.com"
                                ]
                            }
                        },
                        "response": {}
                    }
                },
                "security": "none"
            },
            "sniffing": {
                "enabled": true,
                "destOverride": [
                    "http",
                    "tls"
                ]
            }
        },
        {
            "tag": "VMess Websocket",
            "listen": "0.0.0.0",
            "port": 8080,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "40b1623c-6cfe-44ef-b6f6-3e9aefc1f0c7"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/",
                    "headers": {
                        "Host": "google.com"
                    }
                },
                "security": "none"
            },
            "sniffing": {
                "enabled": true,
                "destOverride": [
                    "http",
                    "tls"
                ]
            }
        }
    
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "DIRECT"
        },
        {
            "protocol": "blackhole",
            "tag": "BLOCK"
        }
    ],
    "routing": {
        "rules": [
            {
                "ip": [
                    "geoip:private"
                ],
                "domain": [
                    "geosite:private"
                ],
                "protocol": [
                    "bittorrent"
                ],
                "outboundTag": "BLOCK",
                "type": "field"
            }
        ]
    }
}

EOF

./xray -c ./config.json
