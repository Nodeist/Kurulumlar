
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
git clone https://github.com/cosmos/relayer.git
cd relayer/
git checkout v2.0.0-rc4
make install     
which rly
chmod +x $(which rly)
```

Stride ve GAIA arasında v2 GO Relayer'ı kurun.
```
DISCORDID="KADI#1234"
cd ~ && rly config init --memo "$DISCORDID"
```

### Değişkenleri ayarlayın.
```
SRC_CHAIN="STRIDE-TESTNET-2"
SRC_KEY="stride-rly"
SRC_MNEMONIC_PHRASE="stride için gizli kelimelerinizi yazın"
    
DST_CHAIN="GAIA"
DST_KEY="gaia-rly"
DST_MNEMONIC_PHRASE="gaia için gizli kelimelerinizi yazın"
```

### Config dosyası oluşturun.
```
cd $HOME/.relayer/config
cp config.yaml config.yaml-bak
```

SETADRESS:PORT KISMINI DÜZENLEYİN:
```
sudo tee $HOME/.relayer/config/config.yaml > /dev/null <<EOF
global:
api-listen-addr: :5183
timeout: 300s
memo: $YOUR_DISCORD_NAME
light-cache-size: 20
    chains:
        GAIA:
            type: cosmos
            value:
                key: $DST_KEY
                chain-id: $DST_CHAIN
                rpc-addr: http://SETADRESS:PORT
                grpc-addr: http://SETADRESS:PORT
                account-prefix: cosmos
                keyring-backend: test
                gas-adjustment: 1.2
                gas-prices: 0.0025uatom
                debug: true
                timeout: 300s
                output-format: json
                sign-mode: direct
                memo-prefix: $DISCORID
        STRIDE-TESTNET-2:
            type: cosmos
            value:
                key: $SRC_KEY
                chain-id: $SRC_CHAIN
                rpc-addr: http://SETADRESS:PORT
                account-prefix: stride
                keyring-backend: test
                gas-adjustment: 1.2
                gas-prices: 0.0025ustrd
                debug: true
                timeout: 300s
                output-format: json
                sign-mode: direct
                memo-prefix: $DISCORDID
    paths:
        STRIDE-GAIA:
            src:
                chain-id: $SRC_CHAIN
                client-id: 07-tendermint-0
                connection-id: connection-0
            dst:
                chain-id: GAIA
                client-id: 07-tendermint-0
                connection-id: connection-0
            src-channel-filter:
                rule: "allowlist"
                channel-list: [channel-0, channel-1, channel-2, channel-3, channel-4]	      
    EOF
```


### Anahtarları GO Relayer'a aktarın.
```
rly keys restore $SRC_CHAIN $SRC_KEY "$SRC_MNEMONIC_PHRASE"
rly keys restore $DST_CHAIN $DST_KEY "$DST_MNEMONIC_PHRASE"
```

### Bakiyelerinizi kontrol edin.
```
rly q balance $SRC_CHAIN
rly q balance $DST_CHAIN
```
    
Servis oluşturun.

```
sudo tee /etc/systemd/system/rlyd.service > /dev/null <<EOF
[Unit]
    Description=V2 Go relayer
    After=network-online.target
    
    [Service]
    User=$USER
    ExecStart=$(which rly) start STRIDE-GAIA --memo "$DISCORDID"
    Restart=on-failure
    RestartSec=3
    LimitNOFILE=65535
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    sudo systemctl daemon-reload
    sudo systemctl enable rlyd
    sudo systemctl restart rlyd
```
    
Logları kontrol edin.
```
sudo journalctl -fu rlyd -o cat
```
    
Yerleşik kanal kimliği (isteğe bağlı) aracılığıyla 2 aktarıcı arasında ham veri göndermeyi deneyin.
### STRIDE - GAIA
```
rly transact transfer $SRC_CHAIN $DST_CHAIN 1000ustrd $(rly chains address $SRC_CHAIN) channel-0 --path STRIDE-GAIA
```
Çıktı şöyle gözükmelidir:
```
2022-08-03T22:27:01.787461Z     info    Successful transaction  {"provider_type": "cosmos", "chain_id": "GAIA", "packet_src_channel": "channel-0", "packet_dst_channel": "channel-0", "gas_used": 88763, "fees": "234uatom", "fee_payer": "cosmos10dahvqtd229q8ndggjk0upcjnkjckdjal20q6r", "height": 135746, "msg_types": ["/ibc.applications.transfer.v1.MsgTransfer"], "tx_hash": "E7409183B5C598DBD8BC873F05E20AEFF76EDFB86201C598CE49D10A94C7CE40"}
```    
### GAIA - STRIDE
```
rly transact transfer $DST_CHAIN $SRC_CHAIN 100uatom $(rly chains address $DST_CHAIN) channel-0 --path STRIDE-GAIA
```

Çıktı şöyle gözükmelidir.
```
2022-08-03T22:27:11.774627Z     info    Successful transaction  {"provider_type": "cosmos", "chain_id": "GAIA", "packet_src_channel": "channel-0", "packet_dst_channel": "channel-0", "gas_used": 88763, "fees": "234uatom", "fee_payer": "cosmos10dahvqtd229q8ndggjk0upcjnkjckdjal20q6r", "height": 135748, "msg_types": ["/ibc.applications.transfer.v1.MsgTransfer"], "tx_hash": "534A062C429B265B7B9651DD8D37EB40539FFA683CB630473C7D33CFEB60FC7A"}
```
    
GO-Relayer Update Client(IBC) mesajını bulmak için cüzdanınızın işlemini gezginde kontrol edin:

![image](https://i.hizliresim.com/svuxkem.png)
