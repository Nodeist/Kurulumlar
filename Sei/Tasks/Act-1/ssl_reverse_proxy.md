&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/gsu0zju.png)


# Kozmos zincirleriniz için ping pub'ı kurun

## Değişkenleri ayarla
```
CHAIN_NAME=Sei
API_PORT=1317
```

## Paketleri güncelle
```
sudo apt update && sudo apt upgrade -y
```

## nginx ve certbot'u kurun
```
sudo apt install nginx certbot python3-certbot-nginx -y
```

## Varsayılan ayarları temizle
```
sudo rm -f /etc/nginx/sites-{available,enabled}/default
```

## Yapılandırmayı ayarla
```
sudo tee /etc/nginx/sites-available/${CHAIN_NAME}-api.nodeist.net.conf > /dev/null <<EOF
server {
        listen 80;
        listen [::]:80;

        server_name ${CHAIN_NAME}-api.nodeist.net;

        location / {

                add_header Access-Control-Allow-Origin *;
                add_header Access-Control-Max-Age 3600;
                add_header Access-Control-Expose-Headers Content-Length;

                proxy_pass http://127.0.0.1:${API_PORT};
        }
}
EOF
```

## Bir sembolik bağlantı oluştur
```
sudo ln -s /etc/nginx/sites-available/${CHAIN_NAME}-api.nodeist.net.conf /etc/nginx/sites-enabled/${CHAIN_NAME}-api.nodeist.net.conf
```

## nginx'i yeniden yükle
```
sudo systemctl reload nginx.service
```

## Sertifikalarınızı alın
```
sudo certbot --nginx --register-unsafely-without-email
```