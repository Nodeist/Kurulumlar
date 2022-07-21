&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)



## Önerilen donanım gereksinimleri
- CPU: 1 CPU
- Memory: 2 GB RAM
- Disk: 20 GB SSD Storage

*şimdilik node kurulumu yok basit görevler var, ileride sistem gereksinimleri yükselecek ve döküman güncellenecektir.*

# Gno.land Kurulum

### Güncellemeler ve gereklilikler
Yükleme ve yapılandırma

```
wget -O gno.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Gno/gno.sh && chmod +x gno.sh && ./gno.sh

```

### Mnemonic Üret (kaydetmeyi unutma!)

```
cd gno

./build/gnokey generate
```

Üretilen mnemonic ile Cüzdan Oluştur (Verilen bilgileri yedeklemeyi unutmayın.)
```
./build/gnokey add account --recover
```

### Musluktan Jeton isteyin:
https://gno.land/faucet

Bakiyenizi kontrol edin. `CUZDANADRESINIZ` yazan kısma az önce aldığınız cüzdan adresini yazın.

```
./build/gnokey query auth/accounts/CUZDANADRESINIZ --remote gno.land:36657
```



Aşağıdakine benzer bir çıktı görmelisiniz:

```
height: 0                                                            
data: {                                                                
"BaseAccount": {                                                       
"address": "g1lr8jsfhtd2du33rgknv2977nc0uefmcty06xpd",               
"coins": "100gnot",                                                   

"public_key": {                                                        
"@type": "/tm.PubKeySecp256k1",                                      
"value": "AxJXHJE8y+b/l3v0LBbdr7QmikZVEEl8j3BH6hE+lh5f"            },                                                                   

"account_number": "1731",                                            
"sequence": "2"                                                    }
```

"account_number": "1731",                                            
"sequence": "2"    

Account number ve sekansınızı kaydedin.
