&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/gsu0zju.png)


# Cosmos zincirleriniz için ping pub'ı kurun

## 1. Paketleri güncelleyin
```
sudo apt update && sudo apt upgrade -y
```

## 2. nginx'i yükleyin
```
sudo apt install nginx -y
```

## 3. Düğümleri yükleyin
```
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 4. İpliği takın
```
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
```

## 3. İkili dosyaları yükleyin
```
cd ~
git clone https://github.com/ping-pub/explorer.git
cd explorer
```

## 4. Önceden tanımlanmış zincirleri temizleme
```
rm $HOME/explorer/src/chains/mainnet/*
```

## 5. Testnet zincirleri ekleyin (Örnektir)
```
wget -qO $HOME/explorer/src/chains/mainnet/clan.json https://raw.githubusercontent.com/Nodeist/explorer/d10612d996f2cfe8ac7b11d00551aef270aed368/src/chains/mainnet/clan.json

```

## 6. ping.pub'ı oluşturun
```
yarn && yarn build
cp -r $HOME/explorer/dist/* /var/www/html
sudo systemctl restart nginx
```