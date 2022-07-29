# Node Setup TR

[<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

[<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e\&utm\_campaign=Referral\_Invite\&utm\_medium=Referral\_Program\&utm\_source=badge)

![](https://i.hizliresim.com/qa5txaz.png)

## Gaia-Stride Relayer Kurulum Rehberi
Mevcut örnekte, iki kozmos zinciri arasında IBC relayerinin nasıl kurulacağını öğreneceğiz.

## Başlamadan önce hazırlık
Aktarıcıyı kurmadan önce aşağıdakilere sahip olduğunuzdan emin olmanız gerekir:
1. Bağlanmak istediğiniz her Cosmos projesi için tamamen senkronize edilmiş RPC düğümleri (Hem Stride Hem gaia ağında node'unuz olmalı)
2. RPC noktaları açıklanmalı ve hermes örneğinden erişilebilir olmalıdır
#### RPC yapılandırması `config.toml` dosyasında bulunur.
Rpc ayarını aşağıdaki gibi yaparak kaydedin.
```
laddr = "tcp://0.0.0.0:10657"
```

#### GRPC yapılandırması `app.toml` dosyasında bulunur
Grpc ayarını aşağıdaki gibi yaparak kaydedin.
```
address = "0.0.0.0:10090"
```

3. Indexer'ı iki düğümde de `kv` olarak ayarlayın. `Config.toml` dosyası.

Yukarıdaki işlemleri 2 node'unuz için yaptığınızdan da emin olun. 
Özet.
1-RPC ayarla
2-GRPC ayarla
3-Indexer ayarla

Daha sonra her iki node'unuza da restart atarak ayarı etkinleştirin.

#Relayer Kurulum
## Sistemi güncelle
```
sudo apt update && sudo apt upgrade -y
```

## Bağımlılıkları yükle
```
sudo apt install unzip -y
```

## Değişkenleri ayarla
Aşağıdaki tüm ayarlar, adım adım `STRIDE-TESTNET-2` ve juno `GAIA` test ağları arasındaki IBC Relayer için sadece örnektir. Lütfen kendi değerlerinizle doldurun.

Relayer name discord kullanıcı adınız:
```
RELAYER_NAME='Nodeist#3299'
```

### Chain A
Stride node'unuz için RPC ve GRPC kısımlarına kendi nodeunuza ait ipadresi+port yazın. ayrıca strd mnemoniclerinizi ekleyin. 
```
CHAIN_ID_A='STRIDE-TESTNET-2'
RPC_ADDR_A='127.0.0.1:44657'
GRPC_ADDR_A='127.0.0.1:44090'
ACCOUNT_PREFIX_A='stride'
TRUSTING_PERIOD_A='8hours'
DENOM_A='ustrd'
MNEMONIC_A='mnemonic gelecek'
```

### Chain B
Gaia node'unuz için RPC ve GRPC kısımlarına kendi nodeunuza ait ipadresi+port yazın. ayrıca gaia mnemoniclerinizi ekleyin. 

```
CHAIN_ID_B='GAIA'
RPC_ADDR_B='127.0.0.1:10657'
GRPC_ADDR_B='127.0.0.1:10090'
ACCOUNT_PREFIX_B='cosmos'
TRUSTING_PERIOD_B='8hours'
DENOM_B='uatom'
MNEMONIC_B='mnemonic gelecek'
```

## Hermes'i indirin
```
cd $HOME
wget https://github.com/informalsystems/ibc-rs/releases/download/v1.0.0-rc.0/hermes-v1.0.0-rc.0-x86_64-unknown-linux-gnu.zip
unzip hermes-v1.0.0-rc.0-x86_64-unknown-linux-gnu.zip
sudo mv hermes /usr/local/bin
hermes version
```

## Hermes için klasör oluşturun
```
mkdir $HOME/.hermes
```

## Hermes Config Dosyası oluşturun.
Yukarıda tanımladığımız değişkenleri kullanarak hermes yapılandırma dosyası oluşturun
Herhangi bir değişiklik yapmanız gerekmiyor.
```
sudo tee $HOME/.hermes/config.toml > /dev/null <<EOF
[global]
log_level = 'info'

[mode]

[mode.clients]
enabled = true
refresh = true
misbehaviour = true

[mode.connections]
enabled = false

[mode.channels]
enabled = false

[mode.packets]
enabled = true
clear_interval = 100
clear_on_start = true
tx_confirmation = true

[rest]
enabled = true
host = '127.0.0.1'
port = 3000

[telemetry]
enabled = true
host = '127.0.0.1'
port = 3001

[[chains]]
### CHAIN_A ###
id = '${CHAIN_ID_A}'
rpc_addr = 'http://${RPC_ADDR_A}'
grpc_addr = 'http://${GRPC_ADDR_A}'
websocket_addr = 'ws://${RPC_ADDR_A}/websocket'
rpc_timeout = '10s'
account_prefix = '${ACCOUNT_PREFIX_A}'
key_name = 'wallet'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 100000
max_gas = 600000
gas_price = { price = 0.001, denom = '${DENOM_A}' }
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 2097152
clock_drift = '5s'
max_block_time = '30s'
trusting_period = '${TRUSTING_PERIOD_A}'
trust_threshold = { numerator = '1', denominator = '3' }
memo_prefix = '${RELAYER_NAME} Relayer'

[[chains]]
### CHAIN_B ###
id = '${CHAIN_ID_B}'
rpc_addr = 'http://${RPC_ADDR_B}'
grpc_addr = 'http://${GRPC_ADDR_B}'
websocket_addr = 'ws://${RPC_ADDR_B}/websocket'
rpc_timeout = '10s'
account_prefix = '${ACCOUNT_PREFIX_B}'
key_name = 'wallet'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 100000
max_gas = 600000
gas_price = { price = 0.001, denom = '${DENOM_B}' }
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 2097152
clock_drift = '5s'
max_block_time = '30s'
trusting_period = '${TRUSTING_PERIOD_B}'
trust_threshold = { numerator = '1', denominator = '3' }
memo_prefix = '${RELAYER_NAME} Relayer'
EOF
```

## Hermes yapılandırmasının doğru olduğunu doğrulayın
Devam etmeden önce lütfen yapılandırmanızın doğru olup olmadığını kontrol edin
```
hermes health-check
```

Sağlıklı çıktı şöyle görünmelidir:
```
2022-07-21T19:38:15.571398Z  INFO ThreadId(01) using default configuration from '/root/.hermes/config.toml'
2022-07-21T19:38:15.573884Z  INFO ThreadId(01) [STRIDE-TESTNET-2] performing health check...
2022-07-21T19:38:15.614273Z  INFO ThreadId(01) chain is healthy chain=STRIDE-TESTNET-2
2022-07-21T19:38:15.614313Z  INFO ThreadId(01) [GAIA] performing health check...
2022-07-21T19:38:15.627747Z  INFO ThreadId(01) chain is healthy chain=GAIA
Success: performed health check for all chains in the config
```

## Anımsatıcı dosyaları kullanarak cüzdanları kurtarın
Bu adıma geçmeden önce, yukarıda mnemoniclerini yazdığınız cüzdanların hepsinde bir miktar token olduğundan emin olun. 
relayer çalışırken fee ödemesi için gerekiyor.
```
sudo tee $HOME/.hermes/${CHAIN_ID_A}.mnemonic > /dev/null <<EOF
${MNEMONIC_A}
EOF
sudo tee $HOME/.hermes/${CHAIN_ID_B}.mnemonic > /dev/null <<EOF
${MNEMONIC_B}
EOF
hermes keys add --chain ${CHAIN_ID_A} --mnemonic-file $HOME/.hermes/${CHAIN_ID_A}.mnemonic
hermes keys add --chain ${CHAIN_ID_B} --mnemonic-file $HOME/.hermes/${CHAIN_ID_B}.mnemonic
```

Başarılı çıktı şöyle görünmelidir:
```
2022-07-21T19:54:13.778550Z  INFO ThreadId(01) using default configuration from '/root/.hermes/config.toml'
Success: Restored key 'wallet' (stride1eardm7w7v9el9d3khkwlj9stdj9hexnfv8pea8) on chain STRIDE-TESTNET-2
2022-07-21T19:54:14.956171Z  INFO ThreadId(01) using default configuration from '/root/.hermes/config.toml'
Success: Restored key 'wallet' (juno1ypnerpxuqezq2vfqxm74ddkuqnektveezh5uaa) on chain GAIA
```

## Hermes servis arka plan programı oluşturun
```
sudo tee /etc/systemd/system/hermesd.service > /dev/null <<EOF
[Unit]
Description=hermes
After=network-online.target

[Service]
User=$USER
ExecStart=$(which hermes) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable hermesd
sudo systemctl restart hermesd
```

## Hermes günlüklerini kontrol edin
```
journalctl -fu hermesd -o cat
```

Ayrıca, https://stride.explorers.guru/account/$STRD_WALLET_ADDRESS explorer'ında görünen "Update Client (Ibc)" işlemlerini görmelisiniz.

![image](https://i.hizliresim.com/ad562wi.png)
![image](https://i.hizliresim.com/pgz94lr.png)
