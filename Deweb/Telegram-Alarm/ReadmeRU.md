<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>



<p align="center">
  <img height="100" src="https://i.hizliresim.com/kitpt1x.png">
</p>


# Deweb Telegram Alarm Установка Руководство
Эта система предупредит вас о тюрьме или неактивном статусе через телеграмму. Он также отправляет вам краткую информацию о состоянии вашего узла каждый час.

Инструкции:

1. Создайте бота телеграммы с помощью `@BotFather`, настройте его и `получите токен API бота` ([если вы не знаете, как](https://www.siteguarding.com/en/how-to-get-telegram-bot-api-token)).

2. Создайте как минимум 2 группы: `alarm` и `log` (вы можете использовать одного и того же телеграмм-бота для будильника и лога, если хотите). Настройте их, добавьте своего бота в свои чаты и `получите идентификаторы чатов` ([если вы не знаете, как](https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id)) .

3. Подключитесь к вашему серверу и создайте папку `status` с `mkdir $HOME/status/`.

4. Вам необходимо создать файл `cosmos.sh` в этой папке; `nano $HOME/status/cosmos.sh`. Никаких изменений вносить не нужно, файл `cosmos.sh` готов к использованию.
> Вы можете найти файл `cosmos.sh` в этом репозитории.

5. Нам нужен файл `cosmos.conf` для определения информации о нашем узле; `nano $HOME/status/cosmos.conf` . Настройте информацию в файле.
> Вы можете найти файлы `cosmos.conf.ornek` и `curl.md` в этом репозитории.

6. Установите пакеты `jq` и `bc`; `sudo apt-get install jq bc -y`.

7. Перейдите в папку «status» и запустите команду «bash Cosmos.sh», чтобы увидеть свои настройки. Если все правильно, вывод должен быть следующим или подобным:
```
root@Nodeist:~/status# bash cosmos.sh 
 
/// 2022-05-21 14:16:44 ///
 
pylons-testnet-3

sync >>> 373010/373010.
jailed > true.
 
/// 2022-05-21 14:16:48 ///
 
stafihub-public-testnet-2

sync >>> 512287/512287.
place >> 47/100.
stake >> 118.12 fis.

root@Nodeist:~/status# 
```
8. Давайте создадим наш файл `slash.sh`; `nano $HOME/status/slash.sh` .
> Вы можете найти файл `slash.sh.ornek` в этом репозитории.

9. Добавьте несколько правил; `chmod u+x cosmos.sh slash.sh`.

10. Редактируем кронтаб (выбираем вариант №1); `crontab-е`.
> Вы можете найти файл `crontab.ornek` в этом репозитории.

12. Вы можете проверить свои журналы с помощью `cat $HOME/status/cosmos.log` или `tail $HOME/status/cosmos.log -f`.

## Справочный список
Ресурсы, используемые в этом проекте:
- Статус [by Cyberomanov](https://github.com/cyberomanov)
