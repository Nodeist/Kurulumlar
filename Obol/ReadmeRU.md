&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>



# Руководство по подготовке к тестовой сети Obol Athena.

![Obol by Nodeist](https://img3.teletype.in/files/2f/d8/2fd8b17f-23dd-4def-937b-c50b4f11c7f8.jpeg)


Obol Network — это распределенный протокол и экосистема для Ethereum POS с миссией устранения единых технических точек отказа в Ethereum с помощью технологии распределенного валидатора (DVT).

В качестве уровня Obol сосредоточен на обеспечении масштабирования основной цепи за счет предоставления несанкционированного доступа к распределенным валидаторам. Инфраструктура стейкинга вступает в фазу эволюции своего протокола, чтобы включать в себя минимально надежные сети стейкинга, которые могут быть подключены в любом масштабе.

08.07.2022 команда объявила о запуске первой общедоступной тестовой сети под названием Athena. Все подробности вы можете найти здесь https://blog.obol.tech/the-athena-testnet/.

## Подготовка
Для участия нам нужно дать ключ enr форме, для этого мы сделаем следующее.
и тогда мы заполним форму. https://obol.typeform.com/AthenaTestnet

### Обновление пакетов
```
sudo apt update && sudo apt upgrade -y
```

### Установить необходимые пакеты
```
sudo apt install curl ncdu htop git wget -y
```

### Установить Докер
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

### Установка библиотеки
```
git clone https://github.com/ObolNetwork/charon-distributed-validator-node.git

chmod o+w charon-distributed-validator-node

cd charon-distributed-validator-node

docker run --rm -v "$(pwd):/opt/charon" ghcr.io/obolnetwork/charon:v0.8.1 create enr
```

* Если вы выполнили операции правильно, в конце всех операций вам будет предоставлен ключ `enr-`, скопируйте и сделайте резервную копию этого ключа и вставьте его в форму.
также сделайте резервную копию файла `.charon/charon-enr-private-key`.

Это все на данный момент.
