&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/f0yifkf.png)


# Yaklaşan test ağı için bir Gentx kurma

## İşletim sistemi
* Linux (Ubuntu 20.04+ Önerilen)
* Mac os işletim sistemi

## Donanım Gereksinimleri
* Minimum Gereksinimler
     * 4GB RAM
     * 250 GB SSD
     * 1.4 GHz x2 CPU
* Önerilen
     * 8GB RAM
     * 500 GB SDD
     * 2.0 GHz x4 CPU
## değişkenleri ayarlama
```
NODENAME=<YOUR MONIKER>
```
`<YOUR MONİKER>` ifadesini istediğiniz herhangi bir şeyle değiştirin

Değişkenleri sisteme kaydedin ve içe aktarın
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export HID_CHAIN_ID=jagrat" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Paketleri Güncelle
```
sudo apt update && sudo apt upgrade -y
```

## Yükleme Ön Koşulları
```
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```
## GO'yu yükleyin (Tek komut)
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```
## İkili Dosyaları İndirin ve Oluşturun
```
cd $HOME
git clone https://github.com/hypersign-protocol/hid-node.git
cd hid-node
make install
```
### Sürümü kontrol edin
Ver `v0.1.0` göstermelidir
```
hid-noded version
```
### Cüzdan yap
Yeni cüzdan oluşturmak için çalıştırın:
```
hid-noded keys add wallet
```
ANILARI KAYDETMEYİ UNUTMAYIN!

Eski cüzdanı kurtarmak için şunu çalıştırın:
```
hid-noded keys add wallet --recover
```
Mnemonic'inizi kopyalayın
Anahtar adres bilgilerini şu komutu kullanarak görüntüleyebilirsiniz: "gizli düğümlü anahtarlar listesi"

## Doğrulayıcı Kurulumu (Genesis Öncesi)
başlangıç düğümü
```
hid-noded init $NODENAME --chain-id $HID_CHAIN_ID
```
Oluşturulan "genesis.json" dosyasındaki jeton değerini "hisse"den "uhid"e değiştirmek için aşağıdakileri çalıştırın.
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom" ]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["ssi"]["chain_namespace"]="jagrat"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```

### Gentx Hesabı Oluşturun
Genesis hesabı ekle
```
hid-noded add-genesis-account wallet 100000000000uhid
```
Gentx oluştur
```
hid-noded gentx wallet 100000000000uhid \
--chain-id $HID_CHAIN_ID \
--moniker="$NODENAME" \
--commission-max-change-rate=0.01 \
--commission-max-rate=1.0 \
--commission-rate=0.07 \
--min-self-delegation=100000000000 \
--details=" " \
--security-contact=" " \
--website=" "
```
--details , --security-contact ve --website'yi istediğiniz gibi değiştirebilir veya boş bırakabilirsiniz.

Gentx TX, `/home/$USER/.hid-node/config/gentx/gentx-xxxx.json"` klasörüne kaydedilecektir.

## PR Oluşturun
- [Depoyu](https://github.com/hypersign-protocol/networks) forklayın.
- `${HOME}/.hid-node/config/gentx/gentx-XXXXXXXX.json.` içeriğini kopyalayın.
- Forklu repo'da 'testnet/jagrat/gentxs' klasörü altında 'gentx-<validator-name-with-out-spaces>.json' dosyasını oluşturun ve son adımdan kopyalanan metni dosyaya yapıştırın.
- Forklu repodaki 'testnet/jagrat/peers' dizini altında 'peers-<validator-name>.txt' dosyasını oluşturun.
- Ana depoya bir Çekme Talebi oluşturun
 
## Talimatları bekleyin
Kalifiye olmak için [FORM](https://app.fyre.hypersign.id/form/hidnet-validator-interest?referrer=ZWxhbmcuMjA5QGdtYWlsLmNvbQ==)'u doldurun
  
## Config klasörünü yedeklemeyi unutmayın!
