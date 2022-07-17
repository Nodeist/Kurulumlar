<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
<a href="https://discord.gg/ypx7mJ6Zzb" target="_blank"><img src="https://cdn.logojoy.com/wp-content/uploads/20210422095037/discord-mascot.png" width="30"/></a><br> Discord'a Katıl <br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et <br>
</p>

<p align="center">
  <img height="100" src="https://i.hizliresim.com/qa5txaz.png">
</p>

# Stride Grafana Monitor Kurulum Rehberi
## Önkoşullar

### Node'unuzun kurulu olduğunu sunucuya `exporter` yükleyin.
```
wget -O NodeistorExporter.sh https://raw.githubusercontent.com/Nodeist/Nodeistor/main/NodeistorExporter && chmod +x NodeistorExporter.sh && ./NodeistorExporter.sh
```
Kurulum sırasında sizden bir kaç bilgi istenecek. Bunlar:

| ANAHTAR |DEĞER |
|---------------|-------------|
| **bond_denom** | Denom Degeri. Örneğin Stride için `ustrd` |
| **bench_prefix** | Bench Prefix Değeri. Örneğin Stride için `stride`. Bu değeri cüzdan adresinizden öğrenebilirsiniz. **stride**1r5g0kes6jutsydez9qw2tx6vuc8scpxn5qtyle |
| **adresport** | Adres Portu. Default 9090'dır. app.toml'dan kontrol edin |
| **ladrport** | Laddr Portu. Default 26657'dir. config.toml'dan kontrol edin. |

** Eğer node kurulumunu bizim dökümanımızdan yaptıysanız, Kurulumlar sayfamızdan Stride port adresini kontrol edebilirsiniz. **

![nodeist](https://i.hizliresim.com/8nedatw.png)

Bu örnekte resimde gördüğünüz gibi Stride portumuz `44`.

Bunun anlamı şudur: Sizin default hali `9090` olan `adresport` unuz eğer node kurulumunu bizim dökümanımızdan yaptıysanız `44090`dır.

Aynı şekilde default hali `266657` olan `ladrport` unuz ise `44657`dir.

Sunucuzda aşağıdaki portların açık olduğundan emin olun:
- `9100` (node-exporter)
- `9300` (cosmos-exporter)

## Grafana Monitör Kurulumu
Doğrulayıcınızı doğru şekilde takip ve analiz edebilmeniz için grafana monitörü ayrı bir sunucuya kurmanızı öneririz.
Node'unuz durursa, sunucunuz arızalanırsa vs. gibi durumlarda da verileri takip etme şansınız olur. Çok büyük bir sistem gereksinimi istemiyor. 
aşağıdaki özelliklerde bir sistem monitör için yeterli. 

### Sistem Gereksinimleri
Ubuntu 20.04 / 1 VCPU / 2 GB RAM / 20 GB SSD

### Monitör Kurulumu
Yeni sunucunuza aşağıdaki kodu yazarak monitör kurulumunu tamamlayabilirsiniz.
```
wget -O NodeistMonitor.sh https://raw.githubusercontent.com/Nodeist/Nodeistor/main/NodeistMonitor && chmod +x NodeistMonitor.sh && ./NodeistMonitor.sh
```


### Prometheus Konfigurasyon dosyasına doğrulayıcı ekleme.
Aşağıdaki kodu farklı ağlar için birden çok kere kullanabilirsiniz. Yani aynı monitörde birden fazla validatörün istatistiğini görüntüleyebilirsiniz.
Bunu yapabilmek için eklemek istediğiniz her ağ için aşağıdaki kodu revize ederek yazın.
```
$HOME/Nodeistor/ag_ekle.sh VALIDATOR_IP WALLET_ADDRESS VALOPER_ADDRESS PROJECT_NAME
```

> Örneğin: ```$HOME/Nodeistor/ag_ekle.sh 1.2.3.4 Stridevaloper1s9rtstp8amx9vgsekhf3rk4rdr7qvg8dlxuy8v Stride1s9rtstp8amx9vgsekhf3rk4rdr7qvg8d6jg3tl Stride```


### Dockeri Başlatın
Monitor dağıtımına başlayın.
```
cd $HOME/Nodeistor && docker compose up -d
```

Kullanılan portlar:
- `9090` (prometheus)
- `9999` (grafana)

## Ayarlar

### Grafana konfigürasyonu
1. Web tarayıcınızı açın ve `sunucuipadresiniz:9999` yazarak grafana arayüzüne ulaşın.

![image](https://i.hizliresim.com/q5v1rxg.png)

2. Kullanıcı adınız ve şifreniz `admin`. ilk girişten sonra şifrenizi güncellemeniz istenecektir.

3. Nodeistor'u import edin.

3.1. Sol menüden `+` iconuna basın ve açılan pencereden `Import` seçeneğine tıklayın.

![image](https://i.hizliresim.com/g76skvm.png)

3.2. grafana.com Kontrol paneli kimliğini yazın `16580`. Ve `Load` a basın.

![image](https://i.hizliresim.com/2c4ely8.png)

3.3. Veri kaynağı olarak prometheus'u seçin ve importa basın.

![image](https://i.hizliresim.com/achuede.png)

4. Explorer yapılandırması

Normalde en çok blok kaçıranlar paneli nodes.guru explorer'a göre uyarlıdır. 

Eğer nodes.guru explorer'da olmayan bir ağ eklemek isterseniz en çok blok kaçıranlar sekmesinde düzenleme yapmanız gerekir.
> Bu işlem sadece `En çok blok kaçıranlar` sekmesi için geçerlidir ve çok da şart değildir.

Sekme başlığına tıklayın ve `edit`e basın.

![image](https://i.hizliresim.com/7g70srb.png)

4.1. **Overrides** sekmesine gelin.

![image](https://i.hizliresim.com/abdah90.png)

4.2. **datalink** bölümünden düzenle butonuna basın.

![image](https://i.hizliresim.com/gpqoyah.png)

4.3 Explorer adresini güncelleyin ve **Save** butonuna basın.

![image](https://i.hizliresim.com/b1st4xn.png)

4.4. Son olarak sağ üst köşeden tekrar **Save** butonuna basın ve ardından **Apply** butonuna basarak uygulayın.

5. Tebrikler! Nodeistor'u başarıyla kurdunuz ve yapılandırdınız.

## Pano içeriği
Grafana panosu 4 bölüme ayrılmıştır:
- **Doğrulayıcı sağlığı** - doğrulayıcı sağlığı için ana istatistikler. bağlı eşler ve cevapsız bloklar
- **Zincir sağlığı** - zincir sağlığı istatistiklerinin özeti ve en iyi doğrulayıcıların eksik blokları listesi
- **Doğrulayıcı istatistikleri** - rütbe, sınırlı jetonlar, komisyon, delegasyonlar ve ödüller gibi doğrulayıcı hakkında bilgiler
- **Donanım sağlığı** - sistem donanım ölçümleri. işlemci, ram, ağ kullanımı

## İstatistikleri Sıfırlayın
```
cd $HOME/cosmos_node_monitoring
docker compose down
docker volume prune -f
```

## Referans Listesi
Bu projede kullanılan kaynaklar:
- Grafana Validator İstatistikleri [Cosmos Validator by freak12techno](https://grafana.com/grafana/dashboards/14914)
- Grafana Hardware Sağlığı [AgoricTools by Chainode](https://github.com/Chainode/AgoricTools)
- Stack of monitoring araçları, docker konfigürasyonu [node_tooling by Xiphiar](https://github.com/Xiphiar/node_tooling/)
- Ve tüm parçaları birleştiren [Kristaps](https://github.com/kj89)
