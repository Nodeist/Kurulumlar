
[<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

[<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e\&utm\_campaign=Referral\_Invite\&utm\_medium=Referral\_Program\&utm\_source=badge)

![](https://i.hizliresim.com/qa5txaz.png)

# Mevcut belirli kanallarda Stride ve GAIA arasında GO Relayer'ı kurun.

İndeksleyiciyi her node'da `kv` olarak ayarlayın.
```
sed -i -e "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.stride/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.gaia/config/config.toml  
```            
            
 RPC uç noktanızı herkese açık hale getirin.
```
sed -i.bak -e 's|^laddr = \"tcp:\/\/.*:\([0-9].*\)57\"|laddr = \"tcp:\/\/0\.0\.0\.0:\157\"|' $HOME/.stride/config/config.toml  
sed -i.bak -e 's|^laddr = \"tcp:\/\/.*:\([0-9].*\)57\"|laddr = \"tcp:\/\/0\.0\.0\.0:\157\"|' $HOME/.gaia/config/config.toml  
```            
                
değişiklik yaptıktan sonra fullnode'u yeniden başlatın.
Henüz yüklemediyseniz GO ve RUST'ı kurun.
    
###### GO Kurulum
# GO'nun kurulu olup olmadığını kontrol edin.
```
go version
```       

# Sonuç yoksa, GO'yu kurmak için aşağıdaki komutu yapın.
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu -y
ver="1.18.3"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

###### RUST Kurulumu
# RUST'ın kurulu olup olmadığını kontrol edin.
```
rustc --version
```            

# Sonuç yoksa kurun.
```
curl https://sh.rustup.rs/ -sSf | sh
source $HOME/.cargo/env
```

# v2 GO Relayer'ı yükleyin.
```
wget https://github.com/cosmos/relayer/releases/download/v2.0.0-rc4/Cosmos.Relayer_2.0.0-rc4_linux_amd64.tar.gz

tar -zxvf Cosmos.Relayer_2.0.0-rc4_linux_amd64.tar.gz

mv "Cosmos Relayer" /usr/local/bin/rly

rly config init
```

# Öncelikle ihtiyacımız olan zincir için gerekli ayarların olduğu bir dosya ekleyelim, bunun için şu komutu yazıyoruz:
`nano stride.json` 

İp adresş+port ve cüzdan isminizi düzenleyin. herhangi bir cüzdan ismi belirleyebilirsiniz. 
ThanksNodeist#1234 kısmına discord id yazın.
```
{
  "type": "cosmos",
  "value": {
    "key": "<your wallet moniker>",
    "chain-id": "STRIDE-TESTNET-2",
    "rpc-addr": "http://<your IP address>:26657",
    "account-prefix": "stride",
    "keyring-backend": "test",
    "gas-adjustment": 1.2,
    "gas-prices": "0.001ustrd",
    "debug": true,
    "timeout": "20s",
    "output-format": "json",
    "sign-mode": "direct"
    "memo-prefix": "ThanksNodeist#1234"

  }
}
```

İkinci zincir için de aynısını yapıyoruz:
`nano gaia.json`

```
{
  "type": "cosmos",
  "value": {
    "key": "<your wallet moniker>",
    "chain-id": "GAIA",
    "rpc-addr": "http://<your IP address>:26657",
    "account-prefix": "cosmos",
    "keyring-backend": "test",
    "gas-adjustment": 1.2,
    "gas-prices": "0.001uatom",
    "debug": true,
    "timeout": "20s",
    "output-format": "json",
    "sign-mode": "direct" 
    "memo-prefix": "ThanksNodeist#1234"
  }
}
```

Ardından düğümleri relayere kaydediyoruz:
```
rly chains add --file=/root/stride.json stride
rly chains add --file=/root/gaia.json gaia
```


Ardından, önce bir ağda, sonra diğerinde kurtarma anahtarları ekliyoruz:
```
rly keys restore stride <your wallet moniker> "mnemonic gelecek"
rly keys restore gaia <your wallet moniker> "mnemonic gelecek"
```

Bakiye kontrol: 
```
rly q balance stride
rly q balance gaia
````

Ardından, aktarıcıya aktarım yolunu eklemeniz gerekir, yalnızca gerekli satırları yapılandırma dosyasına eklemeniz gerekir. Bunu yapmak için yapılandırma dosyasını açın:nano $HOME/.relayer/config/config.yaml
`nano $HOME/.relayer/config/config.yaml` ve "paths: {}" satırını şununla değiştirin:

```
paths:
    stride-gaia:
        src:
            chain-id: STRIDE-TESTNET-2
            client-id: 07-tendermint-0
            connection-id: connection-0
        dst:
            chain-id: GAIA
            client-id: 07-tendermint-0
            connection-id: connection-0
        src-channel-filter:
            rule: allowlist
            channel-list:
                - channel-0
                - channel-12
                - channel-2
                - channel-3
                - channel-4

```

# Kurulumumuzu şu komutla kontrol edin:
```
rly paths list
```

Her şey yolundaysa, bir hizmet dosyası oluşturmaya devam ediyoruz:
`nano /etc/systemd/system/relayer.service`

İçine yazın, kaydedin.

```
[Unit]
Description=relayer
After=network.target
[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/rly start stride-gaia -d
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
```

Servisi başlatın:
```
systemctl enable relayer && systemctl start relayer
```

Log kontrol:
```
journalctl -u relayer -f -o cat
```

GO-Relayer Update Client(IBC) mesajını bulmak için cüzdanınızın işlemini gezginde kontrol edin:

![image](https://i.hizliresim.com/svuxkem.png)
