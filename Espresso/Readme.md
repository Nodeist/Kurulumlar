# Espresso-Testnet-Kurulum
Espresso Testnet Kurulum Rehberi
```
sudo apt install docker -y
  
apt install docker.io -y
  
curl https://www.espressosys.com/cape/docker-compose.yaml --output docker-compose.yaml  
  
apt install docker-compose -y 
  
docker-compose pull  
       
apt-get install screen  
  
screen -S Espresso 
  
docker-compose up  
```
  
## Kurulum sonrası adımlar 

Bilgisayarınızın başlat menüsüne `Komut İstemi` yazıp yönetici olarak çalıştırın.  

Ardından sırayla aşağıdaki iki kodu yapıştırın. `sunucuip` kısımlarını düzenlemeniz gerekiyor.
```
netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=80 connectaddress=sunucuip connectport=80  

netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=60000 connectaddress=sunucuip connectport=60000  
```


Tarayıcımıza girip yeni sekme açarak adres çubuğuna `localhost` yazıp enterliyoruz.  
Ekran aşağıdaki gibi gözükecektir.  

![image](https://user-images.githubusercontent.com/107777584/174918835-ecccffb8-ff8c-46a5-a5a1-5399f7da8ef5.png)  

`Set up a new wallet` butonuna tıklayıp devam ediyoruz.  

![image](https://user-images.githubusercontent.com/107777584/174918922-33578b82-77da-4c43-b854-f138699f1ae0.png)  

`Reveal Keys` butonuna tıklayarak devam ediyoruz.  

![image](https://user-images.githubusercontent.com/107777584/174919078-c1d036e0-7713-4f82-b6a0-4606233ad3a3.png)  

Üstü çizili 12 kelimeyi güvenli bir yere kaydedip `continue` butonuna basalım.  

![image](https://user-images.githubusercontent.com/107777584/174919401-27596867-8c19-4583-8909-664325c03ec4.png)  

Bir önceki adımda kopyaladığımız sıraya göre kelimeleri butonlara tıklayarak seçelim ve `continue` diyelim.   

![image](https://user-images.githubusercontent.com/107777584/174919474-d0d3a027-87e9-498d-a7c5-9cdc9a89beda.png)  

Keystore name kısmını doldurup not alalım ve continue butonuna basalım.  

![image](https://user-images.githubusercontent.com/107777584/174919518-1caf7ed4-a133-47e1-acdb-9ced86c4d5dc.png)  

Şifre oluşturup continue butonuna basalım. (Şifreyi kaydetmeyi unutmayın !)  

Sonraki ekranda create wallet diyerek işlemi tamamlanmasını bekliyoruz. (Biraz zaman alabilir)  

![image](https://user-images.githubusercontent.com/107777584/174919555-f91fe66d-c534-4352-ab8c-b55d32b92466.png)  

![image](https://user-images.githubusercontent.com/107777584/174919570-dd089704-c4f3-4df8-b342-6c9ac100b2a0.png)  

![image](https://user-images.githubusercontent.com/107777584/174919598-464c6710-7aea-443e-a831-3f3e084b8c62.png)  

![image](https://user-images.githubusercontent.com/107777584/174919623-ab8400c6-97a9-4248-bf33-0eb75b136254.png)  

Şifremizle giriş yapıyoruz.  

![image](https://user-images.githubusercontent.com/107777584/174919661-e4fe9b22-91e8-4d22-a5e9-ca4f8425e085.png)  

Sırasıyla 1 ve 2 nolu adımlara tıklıyoruz.  

![image](https://user-images.githubusercontent.com/107777584/174919734-70cf9756-817b-40e3-9ac4-4cd6179cf1ae.png)  

Oluşturduğumuz cüzdan adresini kopyalayıp aşağıdaki tweete cevap olarak gönderiyoruz. Böylece tokenleri talep etmiş olacağız.  

https://twitter.com/EspressoSys/status/1537447721916698625  

![image](https://user-images.githubusercontent.com/107777584/174919774-d96123bc-5d4c-42a2-8e0f-4b1fc89b0a2f.png) 

* Ek olarak ayrıca discorda da cüzdan adresini yazarak token isteyebiliyorsunuz. 
Kurulum adımları bu kadar. 
