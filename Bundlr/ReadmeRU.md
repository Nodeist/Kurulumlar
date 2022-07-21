&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>



# Стартовал долгожданный тестнет от команды Bundlr.

![resim](https://img2.teletype.in/files/92/35/92352e64-ee62-4cb0-a078-349ecad2b296.jpeg)


Проводник:
>- https://bundlr.network/explorer

## Аппаратные требования
- Память: 8 ГБ ОЗУ
-Процессор: 2 ядра
- Диск: 250 ГБ SSD
- Полоса пропускания: 1 Гбит/с для загрузки/100 Мбит/с для загрузки

## Шаги установки:
Вы можете настроить узел Bundlr за считанные минуты, используя приведенный ниже автоматический сценарий.
```
wget -O NodeistBundlr.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Bundlr/NodeistBundlr.sh && chmod +x NodeistBundlr.sh && ./NodeistBundlr.sh
```

### Действия после установки
Перейдите на сайт Arweave и создайте кошелек:
https://faucet.arweave.net/

Когда вы откроете сайт, появится экран, как на картинке, поставьте галочку и нажмите кнопку «Продолжить».

![resim](https://i.hizliresim.com/dcsodu9.png)

На втором экране снова установите флажок и нажмите кнопку «Загрузить кошелек».

![resim](https://i.hizliresim.com/mmypjxp.png)

Нажмите кнопку «Открыть всплывающее окно твита» на следующем экране, откроется окно для твита, там будет написан адрес вашего кошелька.
Скопируйте адрес своего кошелька. Не чирикать.

![resim](https://i.hizliresim.com/a7tw0uu.png)

Перейдите на https://bundlr.network/faucet и вставьте скопированный адрес кошелька. Тогда твит с этого сайта.
Зайдите на сайт и вставьте ссылку на отправленный вами твит.

Мы успешно загрузили наш кошелек на свой компьютер и получили нашу монету из крана.

Теперь нам нужно отредактировать загруженное имя кошелька.

- имя скачанного вами файла выглядит так:
`arweave-key-QeKJ_HaxE.....................ejQ.json`

Переименуйте этот файл в `wallet.json`. `И ДОЛЖЕН СДЕЛАТЬ РЕЗЕРВНУЮ КОПИИ`

Затем мы помещаем этот кошелек в папку `validator-rust` на нашем сервере.

Создаем наш служебный файл
```
tee $HOME/validator-rust/.env > /dev/null <<EOF
PORT=80
BUNDLER_URL="https://testnet1.bundlr.network"
GW_CONTRACT="RkinCLBlY4L5GZFv8gCFcrygTyd5Xm91CzKlR6qxhKA"
GW_ARWEAVE="https://arweave.testnet1.bundlr.network"
EOF
```
Запустите Докер:

Установка занимает около 10 минут. Поэтому рекомендуется заранее создать экран, чтобы предотвратить обрывы соединения.

```
cd ~/validator-rust && docker-compose up -d
```

Проверить журналы:

```
cd ~/validator-rust && docker-compose logs --tail=100 -f
```

Журналы должны выглядеть так:

![resim](https://i.hizliresim.com/cyq2y47.png)

Запускаем валидатор:
```
npm i -g @bundlr-network/testnet-cli
```

Добавьте свой валидатор в сеть. Отредактируйте часть «ipaddress»:
```
testnet-cli join RkinCLBlY4L5GZFv8gCFcrygTyd5Xm91CzKlR6qxhKA -w wallet.json -u "http://ipadress:80" -s 25000000000000
```

Когда все транзакции будут успешными, вы получите сообщение, подобное приведенному ниже.

![resim](https://i.hizliresim.com/9a8uzrb.png)


**Этого достаточно...**

Вы можете проверить адрес своего кошелька в Проводнике.
- https://bundlr.network/explorer
