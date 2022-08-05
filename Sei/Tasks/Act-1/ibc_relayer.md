&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/gsu0zju.png)

# Başka bir testnet ile bir aktarıcı / ibc kanalı kurun
Mevcut örnekte, iki kozmos zinciri arasında IBC rölesinin nasıl kurulacağını öğreneceğiz.

## Başlamadan önce hazırlık
Aktarıcıyı kurmadan önce aşağıdakilere sahip olduğunuzdan emin olmanız gerekir:
1. Bağlanmak istediğiniz her Cosmos projesi için tamamen senkronize edilmiş RPC düğümleri
2. RPC noktaları açıklanmalı ve hermes örneğinden erişilebilir olmalıdır
#### RPC yapılandırması `config.toml` dosyasında bulunur.

```
laddr = "tcp://0.0.0.0:12657"
```
#### GRPC yapılandırması `app.toml` dosyasında bulunur
```
address = "0.0.0.0:12090"
```

3. İndeksleme `kv` olarak ayarlandı ve her düğümde etkinleştirildi
4. Her zincir için jetonlarla finanse edilen ayrı cüzdanlara ihtiyacınız olacak. Bu cüzdanlar tüm aktarma işlemlerini yapmak için kullanılacak

## Sistemi güncelle
```
sudo apt update && sudo apt upgrade -y
```

## Bağımlılıkları yükle
```
sudo apt install unzip -y
```

## Değişkenleri ayarla
Aşağıdaki tüm ayarlar, sei 'atlantic-1' ve uptick 'stride-testnet-2' test ağları arasındaki IBC Relayer için sadece örnektir. Lütfen kendi değerlerinizle doldurun.
```
RELAYER_NAME='Nodeist#3299'
```

### Chain A
```
CHAIN_ID_A='atlantic-1'
RPC_ADDR_A='166.157.55.69:37657'
GRPC_ADDR_A='166.157.55.69:37090'
ACCOUNT_PREFIX_A='sei'
TRUSTING_PERIOD_A='2days'
DENOM_A='usei'
MNEMONIC_A='Mnemonic yazınız..'
```

### Chain B
```
CHAIN_ID_B='STRIDE-TESTNET-2'
RPC_ADDR_B='143.131.13.26:44657'
GRPC_ADDR_B='143.131.13.26:44090'
ACCOUNT_PREFIX_B='stride'
TRUSTING_PERIOD_B='14days'
DENOM_B='ustrd'
MNEMONIC_B='Mnemonic yazınız...'
```

## Hermes'i İndir
```
cd $HOME
wget https://github.com/informalsystems/ibc-rs/releases/download/v1.0.0-rc.0/hermes-v1.0.0-rc.0-x86_64-unknown-linux-gnu.zip
unzip hermes-v1.0.0-rc.0-x86_64-unknown-linux-gnu.zip
sudo mv hermes /usr/local/bin
hermes version
```

## Hermes'i eve yönlendir
```
mkdir $HOME/.hermes
```

## hermes yapılandırması oluşturun
Generate hermes config file using variables we have defined above
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
2022-07-21T19:38:15.573884Z  INFO ThreadId(01) [atlantic-1] performing health check...
2022-07-21T19:38:15.614273Z  INFO ThreadId(01) chain is healthy chain=atlantic-1
2022-07-21T19:38:15.614313Z  INFO ThreadId(01) [uptick_7776-1] performing health check...
2022-07-21T19:38:15.627747Z  INFO ThreadId(01) chain is healthy chain=uptick_7776-1
Success: performed health check for all chains in the config
```

## Anımsatıcı dosyaları kullanarak cüzdanları kurtarın
Bu adıma geçmeden önce, lütfen her zincirde ayrı cüzdanlar oluşturduğunuzdan ve tokenlerle finanse ettiğinizden emin olun.
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
Success: Restored key 'wallet' (sei1eardm7w7v9el9d3khkwlj9stdj9hexnfv8pea8) on chain atlantic-1
2022-07-21T19:54:14.956171Z  INFO ThreadId(01) using default configuration from '/root/.hermes/config.toml'
Success: Restored key 'wallet' (uptick1ypnerpxuqezq2vfqxm74ddkuqnektveezh5uaa) on chain uptick_7776-1
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
journalctl -u hermesd -f -o cat
```

## boş kanallar bulun
```
hermes query channels --chain ${CHAIN_ID_A}
hermes query channels --chain ${CHAIN_ID_B}
```

## Kanal kaydı
```
hermes create channel --a-chain ${CHAIN_ID_A} --b-chain ${CHAIN_ID_B} --a-port transfer --b-port transfer --order unordered --new-client-connection
```
Çıktı, mevcut zincirler için oluşturulmuş kanallar hakkında size tüm bilgileri vermelidir.

## IBC Relayer kullanarak belirteç aktarımı gerçekleştirin
Aşağıdaki tüm komutlar sadece birer örnektir

### 'atlantic-1'den 'STRIDE-TESTNET-2'e usei belirteçleri gönder
```
seid tx ibc-transfer transfer transfer channel-162 stride10dahvqtd229q8ndggjk0upcjnkjckdjaup0uw0 666usei --from $WALLET --fees 200usei
```

### Send ustrd tokens from `STRIDE-TESTNET-2` to `atlantic-1`
```
strided tx ibc-transfer transfer transfer channel-5 sei12kv4wufm0kmuagpdqmgjlshq89hh55n7yqmcrn 666ustrd --from $WALLET --fees 300ustrd
```