 <p style="font-size:14px" align="right">
Sağ üst köşeden forklamayı ve yıldız vermeyi unutmayın ;) <br> <img src="https://i.hizliresim.com/njbmdlb.png"/></p>
<p style="font-size:14px" align="center">
<b>Bu sayfa, çeşitli kripto proje sunucularının nasıl çalıştırılacağına ilişkin eğitimler içerir. </b><br><br>
<a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="64"/></a> <br>Telegrama Katıl. <br>
<a href="https://nodeist.net/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="64"/></a> <br>Websitemizi Ziyaret et. 
</p>


## Tavsiye Edilen Sistem Gereksinimleri
- 4 CPU 8GB RAM 
- Ubuntu 20.04

## Ubuntu Masaüstü Kurulumu
```
sudo apt update
sudo apt-get dist-upgrade
sudo apt-get install ubuntu-desktop
wget https://download.nomachine.com/download/7.9/Linux/nomachine_7.9.2_1_amd64.deb
sudo dpkg -i nomachine_7.9.2_1_amd64.deb
sudo adduser kullanici
usermod -aG sudo kullanici
reboot
```

## Testnet Kurulumu
```
sudo curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
sudo apt install docker-compose
sudo curl https://www.espressosys.com/cape/docker-compose.yaml --output docker-compose.yaml
sudo docker-compose pull
sudo docker-compose up
```

Web tarayıcınızın adres çubuğuna `localhost` yazarak işlemlere devam edin.
