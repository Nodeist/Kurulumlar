<p style="font-size:14px" align="right">
<a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>


<p align="center">
<img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Paloma/172488614-7d93b016-5fe4-4a51-99e2-67da5875ab7a.png">
</p>

# Pigeon relayer kurulumu
Paloma doğrulayıcılarının mesajları herhangi bir blok zincirine iletmeleri için bir Golang zincirler arası mesaj aktarma sistemi.

## Alchemy'e Kaydolun ve ETH Endpoint oluşturun
https://www.alchemy.com/ Sitesine kaydolun. ETH Mainnet Endpoint oluşturun ve `ETH_RPC_URL` nizi kopyalayın.
![image](https://i.hizliresim.com/oyj7k1h.png)

## Değişken Ayarları
```
ETH_RPC_URL=ALCHEMYENDPOINTINIZIYAZIN
ETH_PASSWORD=BIRSIFREBELIRLEYIN
```

Örnek
```
ETH_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/Mnj.....
ETH_PASSWORD=birikiucdort
```

Değişkenleri kaydedin

```
echo "export ETH_RPC_URL=${ETH_RPC_URL}" >> $HOME/.bash_profile
echo "export ETH_PASSWORD=${ETH_PASSWORD}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Kütüphaneyi indirin ve kurun
```
wget -O - https://github.com/palomachain/pigeon/releases/download/v0.2.5-alpha/pigeon_0.2.5-alpha_Linux_x86_64v3.tar.gz | \
tar -C /usr/local/bin -xvzf - pigeon
chmod +x /usr/local/bin/pigeon
mkdir ~/.pigeon
```

## EVM anahtarlarınızı ayarlayın
### SEÇENEK 1) Yeni anahtarlar oluşturun
Daha önce tanımladığınız parolayı kullanın `ETH_PASSWORD`
```
pigeon evm keys generate-new $HOME/.pigeon/keys/evm/eth-main
```
### SEÇENEK 2) Mevcut anahtarları içe aktar
```
pigeon evm keys import ~/.pigeon/keys/evm/eth-main
```

## ETH_SIGNER_KEY'i bash_profile'a yükleyin
```
echo "export ETH_SIGNING_KEY=0x$(cat .pigeon/keys/evm/eth-main/*  | jq -r .address | head -n 1)" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Yapılandırma dosyası oluşturun
```
sudo tee $HOME/.pigeon/config.yaml > /dev/null <<EOF
loop-timeout: 5s

paloma:
  chain-id: paloma-testnet-6
  call-timeout: 20s
  keyring-dir: $HOME/.paloma
  keyring-type: test
  keyring-pass-env-name: PASSWORD
  signing-key: ${WALLET}
  base-rpc-url: http://localhost:${PALOMA_PORT}657
  gas-adjustment: 1.5
  gas-prices: 0.001ugrain
  account-prefix: paloma

evm:
  eth-main:
    chain-id: 1
    base-rpc-url: ${ETH_RPC_URL}
    keyring-pass-env-name: PASSWORD
    signing-key: ${ETH_SIGNING_KEY}
    keyring-dir: $HOME/.pigeon/keys/evm/eth-main
EOF
```

## .env dosyasını ayarla
```
sudo tee $HOME/.pigeon/.env > /dev/null <<EOF
PASSWORD=$ETH_PASSWORD
EOF
```


## Hizmet oluştur
```
sudo tee /etc/systemd/system/pigeond.service > /dev/null <<EOF
[Unit]
Description=Pigeon Service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which pigeon) start
EnvironmentFile=$HOME/.pigeon/.env
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Kayıt olun ve hizmeti başlatın
```
sudo systemctl daemon-reload
sudo systemctl enable pigeond
sudo systemctl restart pigeond && sudo journalctl -u pigeond -f -o cat
```

## Aşağıdaki komutun çıktısını paloma telegram kanalına gönderin
```
palomad q valset validator-info <YOUR_PALOMA_VALIDATOR_ADDRESS>
```

Çıktı şuna benzemeli:
```
palomad q valset validator-info palomavaloper13uslh0y22ffnndyr3x30wqd8a6peqh25m8p743
chainInfos:
- address: 0x63f55bc560E981d53E1f5bb3643e3a96D26fc635
  chainID: eth-main
  chainType: EVM
  pubkey: Y/VbxWDpgdU+H1uzZD46ltJvxjU=
```
  
