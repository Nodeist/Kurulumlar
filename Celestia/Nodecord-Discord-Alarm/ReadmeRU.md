&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/5oh0erz.png)



# узелкорд

Nodecord — это инструмент мониторинга и оповещения валидатора блокчейна на базе Cosmos.

Мониторы и оповещения для таких сценариев, как:
- Время простоя в работе
- Последние пропущенные блоки (в настоящее время подписывает валидатор)
- Статус тюрьмы
- Статус надгробия
- Отдельные сторожевые узлы недоступны/асинхронны
- Цепь остановлена

Сообщения Discord генерируются в канале webhook, настроенном для:
- Текущий статус валидатора
- Обнаруженные оповещения

## Шаги установки:
### С помощью следующего скрипта автоматической установки (рекомендуется использовать другой сервер. Таким образом, при обнаружении проблемы на вашем узле или сервере система может отреагировать и отправить вам уведомление через разногласия.)

```
wget -O NODECORD.sh https://raw.githubusercontent.com/Nodeist/Nodecord/main/NODECORD && chmod +x NODECORD.sh && ./NODECORD.sh
```

## Действия после установки:
Чтобы Nodecord работал правильно, вы должны сначала создать экран:
```
screen -S Nodecord
```

### Параметры конфигурации:
Создайте файл конфигурации.
В этом файле необходимо отредактировать части DISCORD_WEBHOOK_TOKEN, DISCOR_WEBHOOK_ID, DISCORD_USER_ID.
Вы можете найти дополнительную информацию о создании вебхука Discord [здесь](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks).

Скопируйте свой URL после создания вебхука. это будет выглядеть так:
`https://discord.com/api/webhooks/97124726447720/cwM4Ks-kWcK3Jsg4I_cbo124buo12G2oıdaS76afsMwuY7elwfnwef-wuuRW`
В этом случае ваш
- DISCORD_WEBHOOK_ID: `9712472647720`
- DISCORD_WEBHOOK_TOKEN: `cwM4Ks-kWcK3Jsg4I_cbo124buo12G2oidaS76afsMwuY7elwfnwef-wuuRW`
Так и будет.
- Вы можете легко найти этап обучения DISCORD_USER_ID, выполнив поиск в Google.


Кроме того, отредактируйте раздел **validators:**, для которого вы хотите создать отчет.
- Имя: сетевое имя (Kujira, Osmosis, Quicksilver и т. д.)
- RPC: Вы можете легко найти подключение RPC от компаний, которые предлагают услугу RPC. Обычно я следую "-Polkachu-". Пример rpc для Кудзиры: https://kujira-rpc.polkachu.com/
- Адрес: это не адрес вашего кошелька и не ваш адрес valoper. Обратите на это внимание. Это должен быть ваш согласованный адрес. Найти его можно в проводниках.
- Chain-id: **Kaiyo-1** для примера Кудзиры

В разделе охраны очереди:
- name: Имя вашего сервера. Вы можете дать любое имя.
- grpc: IP-адрес вашего сервера + порт rpc

Если вы используете один и тот же узел на нескольких серверах. (если вы размещаете резервный сервер)
- имя
- грпс

Вы можете следить за метками, добавляя еще одну под каждой меткой и вводя информацию о другом вашем сервере.
Откройте файл, набрав `nano ~/Nodecord/config.yaml`. Вы увидите экран, аналогичный приведенному ниже. Отредактируйте и сохраните, где необходимо.

```
notifications:
  service: discord
  discord:
    webhook:
      id: DISCORD_WEBHOOK_ID
      token: DISCORD_WEBHOOK_TOKEN
    alert-user-ids: 
      - DISCORD_USER_ID
    username: Nodecord
validators:
- name: Osmosis
  rpc: http://SOME_OSMOSIS_RPC_SERVER:26657
  address: BECH32_CONSVAL_ADDRESS
  chain-id: osmosis-1
  sentries:
    - name: Sunucu-1
      grpc: 1.2.3.4:9090
```
Аналогично, если вы собираетесь использовать будильники для более чем одной сети. Как для kujira, так и для osmosis вы должны добавить раздел **validators:** отдельно.
На изображении ниже вы можете увидеть конфигурацию валидатора как osmosis, так и juno network.

![nodeist](https://i.hizliresim.com/hplawtm.png)

### Инициализация монитора

Вы можете инициализировать монитор с помощью следующего кода:

```
cd && cd Nodecord && Nodecord monitor
```
Этот код извлекает данные из файла «config.yaml», который вы создали по умолчанию, и запускает отслеживание.
Я использую два отдельных файла yaml для тестовой сети и основной сети.
Вы также можете создать файл «testnet.yaml» для тестовой сети. и вы можете запустить его на отдельном экране со следующим кодом.

```
cd && cd Nodecord && Nodecord monitor -f ~/testnet.yaml
```

Когда nodecord запускается, он создаст сообщение о состоянии в канале разногласий и добавит идентификатор этого сообщения в «config.yaml». Закрепите это сообщение, чтобы закрепленные сообщения канала могли действовать как панель мониторинга, чтобы увидеть реальную информацию. временной статус валидаторов.

![Nodeist](https://i.hizliresim.com/6qt5b5t.png)

Он будет отправлять предупреждающие сообщения при обнаружении любого состояния ошибки.

![Nodeist](https://i.hizliresim.com/8ow2s04.png)

При высоких и критических ошибках будет помечен пользователь с идентификатором в разделе DISCORD_USER_ID.

![Nodeist](https://i.hizliresim.com/2g4vd1k.png)

Он отправит информационное сообщение, когда ошибки будут исправлены.


## Справочный список
Этот проект вдохновлен [Strangelove Ventures](https://github.com/strangelove-ventures).
