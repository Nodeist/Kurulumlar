<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>


# Регистрация пользователя
### В настоящее время существует 2 способа зарегистрироваться в качестве пользователя в GNO.LAND:

*Получите приглашение от кого-то с правами приглашения.*

*Внесите 2000 $GNOT в соглашение о регистрации пользователя (обратите внимание, что в ближайшем будущем эта сумма будет изменена на 100 долларов США для обеспечения доступности).*

Хотя мы рекомендуем присоединиться к [Официальному серверу Gnoland Discord](https://discord.gg/xD2c2Nmd), чтобы запрашивать приглашения или создавать резервные копии $GNOT от сообщества,
Вы также можете использовать сборщик, который дает 100 $ GNOT за запрос.
Однако последний вариант не рекомендуется, так как вам придется спамить сборщик более 20 раз.

### Как только вы получите GNOT за 2000 долларов, запустите Ubuntu и перейдите в свой рабочий каталог.

```
cd gno
```

### Проверьте баланс своего кошелька
Напишите адрес своего кошелька в разделе «walletadress».
Убедитесь, что у вас есть по крайней мере 2000 gnot баланса.

```
./build/gnokey query auth/accounts/walletadress --remote gno.land:36657
```

### Выполнить регистрацию
Теперь мы создадим файл, который будет содержать информацию о процессе, который зарегистрирует вас как пользователя с помощью следующей команды:
Замените там, где написано «CUZDANADRESI» и «ИМЯ ПОЛЬЗОВАТЕЛЯ». Укажите имя пользователя, которое будет использоваться в качестве имени пользователя. должен состоять только из строчных букв.
Не используйте цифры и специальные символы.
```
./build/gnokey maketx call CUZDANADRESI --pkgpath "gno.land/r/users" --func "Register" --gas-fee 1gnot --gas-wanted 2000000 --send "2000gnot" --args "" --args "USERNAME" --args "" > unsigned.tx
```

### Выполнить операцию подписи
Отредактируйте «WALLETADDRESS», «ACCOUNTNUMBER», «SEQUENCENUMBER» по своему усмотрению.
```
./build/gnokey sign WALLETADDRESS --txpath unsigned.tx --chainid testchain --number ACCOUNTNUMBER --sequence SEQUENCENUMBER > signed.tx
```

### Опубликовать подпись:
```
./build/gnokey broadcast signed.tx --remote gno.land:36657
```
*Вы должны увидеть свое имя пользователя [в списке, найденном здесь](https://gno.land/r/users), если все операции выполнены правильно.*

# Задача
Теперь мы можем перейти к этапу задачи.

Подготовьте и опубликуйте статью на английском языке о Gno.
Медиум, твиттер и т.д. Вы можете использовать сайты блогов.

### После подготовки статьи опубликуйте ее, введя код ниже;
Отредактируйте разделы `WALLETADDRESS` и `ARTICLELINK` по своему усмотрению.
```
./build/gnokey maketx call WALLETADDRESS --pkgpath "gno.land/r/boards" --func "CreateReply" --gas-fee 1gnot --gas-wanted 2000000 --send "" --broadcast true --chainid testchain --args "1" --args "8" --args "8" --args "ARTICLELINK" --remote gno.land:36657
```

Если процесс прошел успешно, вы должны увидеть ссылку на свою статью на странице [Quest Posts](https://gno.land/r/boards:gnolang/8).

