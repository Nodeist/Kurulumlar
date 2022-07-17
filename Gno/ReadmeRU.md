<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>

## Рекомендуемые аппаратные требования
- ЦП: 1 ЦП
- Память: 2 ГБ оперативной памяти
- Диск: 20 ГБ SSD

*Настройки узла пока нет, есть простые задачи, в будущем системные требования увеличатся и документ будет обновляться.*

# Установка Gno.land

### Обновления и требования
Установка и настройка

```
wget -O gno.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Gno/gno.sh && chmod +x gno.sh && ./gno.sh

```
### Создать мнемонику (не забудьте сохранить!)

```
cd gno

./build/gnokey generate
```

Создайте кошелек со сгенерированной мнемоникой (не забудьте сделать резервную копию предоставленной информации).
```
./build/gnokey add account --recover
```

### Запросить токены из крана:
https://gno.land/faucet

Проверьте свой баланс. В разделе «walletaddress» напишите адрес кошелька, который вы только что получили.

```
./build/gnokey query auth/accounts/walletaddress --remote gno.land:36657
```



Вы должны увидеть вывод, подобный следующему:

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

"номер_счета": "1731",
"последовательность": "2"

Сохраните номер своей учетной записи и последовательность.
