 <p style="font-size:14px" align="right">
Sağ üst köşeden forklamayı ve yıldız vermeyi unutmayın ;) <br> <img src="https://i.hizliresim.com/njbmdlb.png"/></p>
<p style="font-size:14px" align="center">
<b>Bu sayfa, çeşitli kripto proje sunucularının nasıl çalıştırılacağına ilişkin eğitimler içerir. </b><br><br>
<a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="64"/></a> <br>Telegrama Katıl. <br>
<a href="https://nodeist.net/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="64"/></a> <br>Websitemizi Ziyaret et. 
</p>


# Obol Athena testnet hazırlık kılavuzu.

![Obol by Nodeist](https://img3.teletype.in/files/2f/d8/2fd8b17f-23dd-4def-937b-c50b4f11c7f8.jpeg)


Obol Network, dağıtılmış doğrulayıcı teknolojisi (DVT) aracılığıyla Ethereum'daki tek teknik arıza noktalarını ortadan kaldırma misyonuyla Ethereum POS için dağıtılmış bir protokol ve ekosistemdir.

Bir katman olarak Obol, dağıtılmış doğrulayıcılara izinsiz erişim sağlayarak ana zincirin ölçeklenmesini sağlamaya odaklanmıştır. Staking altyapısı, herhangi bir ölçekte bağlanabilen minimum güvenilir stake ağlarını içerecek şekilde protokolünün evriminde bir aşamaya giriyor.

07/08/2022'de ekip, Athena adlı ilk halka açık test ağının başlatıldığını duyurdu. Tüm detayları burada https://blog.obol.tech/the-athena-testnet/ bulabilirsiniz.

## Hazırlık 
Katılım için forma enr anahtarı vermemiz gerekiyor bunun için aşağıdaki işlemleri yapacağız. 
ve sonra formu dolduracağız. https://obol.typeform.com/AthenaTestnet

### Paketleri güncelleyin
```
sudo apt update && sudo apt upgrade -y
```

### Gerekli paketleri yükleyin
```
sudo apt install curl ncdu htop git wget -y
```

### Docker Yükleyin 
```
cd $HOME

apt update && apt purge docker docker-engine docker.io containerd docker-compose -y

rm /usr/bin/docker-compose /usr/local/bin/docker-compose

curl -fsSL https://get.docker.com -o get-docker.sh

sh get-docker.sh

curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

### Kütüphane kurulumu
```
git clone https://github.com/ObolNetwork/charon-distributed-validator-node.git

chmod o+w charon-distributed-validator-node

cd charon-distributed-validator-node

docker run --rm -v "$(pwd):/opt/charon" ghcr.io/obolnetwork/charon:v0.8.1 create enr
```

* işlemleri doğru yaptıysanız tüm işlemlerin sonunda size `enr-` key verilecek o keyi kopyalayıp yedekleyin ve forma yapıştırın. 
ayrıca `.charon/charon-enr-private-key` dosyasını yedekleyin.

şimdilik işlemler bu kadar.
