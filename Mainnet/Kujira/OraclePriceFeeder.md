# Kujira Oracle Kılavuzu

## Giriş
Doğrulayıcıların zincir üstü oracle için fiyat beslemeleri göndermeleri gerekir.
"fiyat besleyici" uygulaması, birden fazla sağlayıcıdan fiyat verilerini alabilir ve
bu görevi yerine getirmek için oracle oyları gönderin.


## Gereksinimler
- Bu kılavuz, Ubuntu 22.04 çalıştırdığınızı varsayar.
- "fiyat besleyici"nin, çalışan bir düğümün RPC ve gRPC bağlantı noktalarına erişmesi gerekiyor.
   Bu kılavuz, aynı makinede olduğunu varsayar ve "localhost" kullanır
   varsayılan bağlantı noktaları 26657 ve 9090 ile. Bunları gerektiği gibi 'config.toml' içinde değiştirin.


## Kullanıcı kurulumu
En iyi uygulama, düğüm yazılımını yalıtılmış, ayrıcalığı olmayan bir kullanıcı üzerinde çalıştırmaktır.
Bu kılavuzda "kujioracle" kullanıcısını oluşturacağız; kullanıcı adınız farklıysa
göründüğü yerde değiştirin.

### "kujioracle" kullanıcısını oluşturun
```bash
sudo useradd -m -s /bin/bash kujioracle
```


## Derleme ortamı kurulumu
[Düğüm Kılavuzunu](https://github.com/Nodeist/Kurulumlar/tree/main/Z-Bitenler/Kujira-Mainnet) zaten izlediyseniz, yalnızca
Bu bölümde ihtiyacınız olan **Go toolchain'i kurun**

### Derleme paketlerini kurun
```bash
sudo apt install -y build-essential git unzip curl
```

### go araç zincirini kurun
1. 1.18.5'i indirin ve çıkarın.
```bash
curl -fsSL https://golang.org/dl/go1.18.5.linux-amd64.tar.gz | sudo tar -xzC /usr/local
```
2. "kujioracle" olarak oturum açın.
```bash
sudo su -l kujioracle
```
3. "kujioracle" için ortam değişkenlerini yapılandırın.
```bash
cat <<EOF >> ~/.bashrc
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source ~/.bashrc
go version  # should output "go version go1.18.5 linux/amd64"
```


## 'fiyat besleyici' oluştur
1. "kujioracle" olarak oturum açın (önceden oturum açtıysanız atlayın).
```bash
sudo su -l kujioracle
```
2. "kujirad" v0.5.0'ı oluşturun. 'Fiyat besleyici' oluşturmak için depoya ihtiyacımız var ve
   anahtarlık dosyasını oluşturmak için ikili dosyayı kullanın.
```bash
git clone https://github.com/Team-Kujira/core
cd core
git checkout v0.5.0
make install
cd ..
kujirad version  # should output "0.5.0"
```
3. "Fiyat besleyici" oluşturun.
```bash
git clone https://github.com/Team-Kujira/oracle-price-feeder
cd oracle-price-feeder
make install
price-feeder version
```
## 'fiyat besleyici'yi yapılandırın

### Bir cüzdan oluşturun
Bu cüzdan nispeten güvensiz olacak, yalnızca oy göndermek için ihtiyacınız olan fonları depolayacak.

1. "kujioracle" olarak oturum açın (önceden oturum açtıysanız atlayın).
```bash
sudo su -l kujioracle
```
2. Anahtarlık için cüzdan ve parola oluşturun.
```bash
kujirad keys add oracle
```
3. "anahtarlık dosyası" dizinini yapılandırın. Bu, 'fiyat besleyici' 
Anahtarlığı bulmayı sağlar.
```bash
mkdir ~/.kujira/keyring-file
mv ~/.kujira/*.info ~/.kujira/*.address ~/.kujira/keyring-file
```

### Besleyici yetkisini ayarlayın
Bu adım, doğrulayıcınız adına Oracle oyları göndermek için yeni cüzdanınızı yetkilendirecektir.
İşlem, doğrulayıcı cüzdandan gönderilmelidir, bu nedenle uygun olduğu bir düğümde çalıştırın.

- "<oracle_wallet>" kısmını yeni cüzdan adresinizle değiştirin.
- "<validator_wallet>" ifadesini doğrulayıcı cüzdan adınızla değiştirin.

```bash
kujirad tx oracle set-feeder <oracle_wallet> --from <validator_wallet> --fees 250ukuji
```


### Yapılandırmayı oluşturun
1. "kujioracle" olarak oturum açın (önceden oturum açtıysanız atlayın).
```bash
sudo su -l kujioracle
```
2. En sevdiğiniz metin düzenleyiciyle yapılandırma dosyasını oluşturun.
     - "<wallet_address>" kısmını Oracle cüzdan adresinizle değiştirin (ör. "kujira16jchc8l8hfk98g4gnqk4pld29z385qyseeqqd0")
     - "<validator_address>" kısmını doğrulayıcı adresinizle değiştirin (ör. "kujiravaloper1e9rm4nszmfg3fdhrw6s9j69stqddk7ga2x84yf")

    ```toml title="~/config.toml"  
    gas_adjustment = 1.5
    gas_prices = "0.00125ukuji"
    enable_server = true
    enable_voter = true
    provider_timeout = "500ms"

    [server]
    listen_addr = "0.0.0.0:7171"
    read_timeout = "20s"
    verbose_cors = true
    write_timeout = "20s"

    [[deviation_thresholds]]
    base = "USDT"
    threshold = "2"

    [account]
    address = "<wallet_address>"
    chain_id = "kaiyo-1"
    validator = "<validator_address>"
    prefix = "kujira"

    [keyring]
    backend = "file"
    dir = "/home/kujioracle/.kujira"

    [rpc]
    grpc_endpoint = "localhost:9090"
    rpc_timeout = "100ms"
    tmrpc_endpoint = "http://localhost:26657"

    [telemetry]
    enable_hostname = true
    enable_hostname_label = true
    enable_service_label = true
    enabled = true
    global_labels = [["chain-id", "kaiyo-1"]]
    service_name = "price-feeder"
    type = "prometheus"

    [[provider_endpoints]]
    name = "binance"
    rest = "https://api1.binance.com"
    websocket = "stream.binance.com:9443"
    ```

#### Döviz çiftlerini doğrulayın
Bölünmeyi önlemek için yalnızca beyaz listeye alınan mezhepler için fiyat oyları göndermek önemlidir.
Şu anda yapılandırılmış denomları görmek ve gerekirse "[[currency_pairs]]" değerini güncellemek için bu bağlantıyı kontrol edin:
[kaiyo-1 oracle parametreleri](https://lcd.kaiyo.kujira.setten.io/oracle/params).

## 'fiyat besleyici'yi çalıştır
1. "kujioracle" olarak oturum açın (önceden oturum açtıysanız atlayın).
```bash
sudo su -l kujioracle
```
2. 'stdin'de şifreyi girerek uygulamayı çalıştırın.
```bash
echo <keyring_password> | price-feeder ~/config.toml
```

## Bir hizmet oluşturun
Bir systemd hizmeti, "fiyat besleyici"yi arka planda çalışır durumda tutar ve durursa yeniden başlatır.

1. Favori metin düzenleyicinizi kullanarak hizmet dosyasını `sudo` ile oluşturun.
"<keyring_password>" öğesini oluşturduğunuzla değiştirin.
```ini title="/etc/systemd/system/kujira-price-feeder.service"
[Unit]
Description=kujira-price-feeder
After=network.target

[Service]
Type=simple
User=kujioracle
ExecStart=/home/kujioracle/go/bin/price-feeder /home/kujioracle/config.toml
Restart=on-abort
LimitNOFILE=65535
Environment="PRICE_FEEDER_PASS=<keyring_password>"

[Install]
WantedBy=multi-user.target
```
2. Yeni hizmeti almak için 'systemd'yi yeniden yükleyin.
```bash
sudo systemctl daemon-reload
```
3. Hizmeti başlatın.
```bash
sudo systemctl start kujira-price-feeder
```
4. Hizmet günlüklerinizi sıralayın.
```bash
sudo journalctl -fu kujira-price-feeder
```
5. (İsteğe bağlı) Hizmeti etkinleştirin. Bu, her önyüklemede başlayacak şekilde ayarlayacaktır.
```bash
sudo systemctl enable kujira-price-feeder
```
