&#x20;                             [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist) | [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://nodeist.net/)<mark style="color:purple;"></mark>

![](https://i.hizliresim.com/iz7y3vs.png)

# Paloma Руководство по установке монитора Grafana
## Предпосылки

### Загрузите `exporter` на сервер, на котором установлена ​​ваша нода.
```
wget -O NodeistorExporter.sh https://raw.githubusercontent.com/Nodeist/Nodeistor/main/NodeistorExporter && chmod +x NodeistorExporter.sh && ./NodeistorExporter.sh
```
Во время установки вам будет предложено ввести некоторую информацию. Эти:

| КЛЮЧ | ЗНАЧЕНИЕ |
|----------|--------------|
| **bench_denom** | Номинальная стоимость. Например, `ugrain` для Paloma |
| **bench_prefix** | Значение префикса скамейки. Например `paloma` для Paloma. Узнать это значение можно по адресу вашего кошелька. **paloma**jcqum902je9zwevat7zqczskwd4lhwuj9vwgsu |
| **grpc_port** | Порт вашего валидатора `grpc`, который определен в файле `app.toml`. Значение по умолчанию: `41090` |
| **rpc_port** | Порт вашего валидатора `rpc`, указанный в файле `config.toml`. Значение по умолчанию: `41657` |

Убедитесь, что на вашем сервере открыты следующие порты:
- `9100` (узел-экспортер)
- `9300` (космос-экспортер)

## Настройка монитора Grafana
Мы рекомендуем установить монитор grafana на отдельный сервер, чтобы вы могли правильно отслеживать и анализировать свой аутентификатор.
Если ваш узел останавливается, ваш сервер выходит из строя и т. д. В таких случаях у вас есть возможность следить за данными. Это не требует огромных системных требований.
Для монитора достаточно системы со следующими характеристиками.

### Системные Требования
Ubuntu 20.04 / 1 виртуальный процессор / 2 ГБ ОЗУ / 20 ГБ SSD

### Настройка монитора
Вы можете завершить настройку монитора, введя следующий код на новом сервере.
```
wget -O NodeistMonitor.sh https://raw.githubusercontent.com/Nodeist/Nodeistor/main/NodeistMonitor && chmod +x NodeistMonitor.sh && ./NodeistMonitor.sh
```

### Добавление валидатора в файл конфигурации Prometheus.
Вы можете использовать приведенный ниже код несколько раз для разных сетей. Другими словами, вы можете просматривать статистику более чем одного валидатора на одном мониторе.
Для этого напишите следующий код, изменив его для каждой сети, которую вы хотите добавить.
```
$HOME/Nodeistor/ag_ekle.sh VALIDATOR_IP WALLET_ADDRESS VALOPER_ADDRESS PROJECT_NAME
```

### Запустить Докер
Начните развертывание монитора.
```
cd $HOME/Nodeistor && docker compose up -d
```

Используемые порты:
- `9090` (прометей)
- `9999` (графана)

## Настройки

### Конфигурация Графана
1. Откройте веб-браузер и введите «IPADRESS:9999», чтобы получить доступ к интерфейсу grafana.

![image](https://i.hizliresim.com/q5v1rxg.png)

2. Ваше имя пользователя и пароль `admin`. После первого входа вам будет предложено обновить пароль.

3. Импортируйте Nodeistor.

3.1. Нажмите значок «+» в левом меню и нажмите «Импорт» во всплывающем окне.

![image](https://i.hizliresim.com/g76skvm.png)

3.2. Введите grafana.com ID панели управления `16580`. И нажмите «Загрузить».

![image](https://i.hizliresim.com/2c4ely8.png)

3.3. Выберите prometheus в качестве источника данных и нажмите импорт.

![image](https://i.hizliresim.com/achuede.png)

4. Конфигурация проводника

Нажмите на заголовок вкладки «Лучшие хиты» и нажмите «Изменить».

![image](https://i.hizliresim.com/7g70srb.png)

4.1. Перейдите на вкладку **Переопределения**.

![image](https://i.hizliresim.com/abdah90.png)

4.2. Нажмите кнопку «Выбрать под **подключением для передачи данных**».

![image](https://i.hizliresim.com/gpqoyah.png)

4.3 Обновите адрес Проводника и нажмите кнопку **Сохранить**.

![image](https://i.hizliresim.com/b1st4xn.png)

4.4. Наконец, снова нажмите кнопку **Сохранить** в правом верхнем углу, а затем примените, нажав кнопку **Применить**.

5. Поздравляем! Вы успешно установили и настроили Nodeistor.

## Содержимое буфера обмена
Панель инструментов Grafana разделена на 4 раздела:
- **Здоровье верификатора** - основная статистика состояния верификатора. подключенные пиры и пропущенные блоки
- **Chain Health** - сводка статистики состояния цепи и список отсутствующих блоков лучших валидаторов.
- **Статистика верификатора** - информация о валидаторе, такая как ранг, ограниченное количество монет, комиссия, делегирование и вознаграждение.
- **Состояние оборудования** — показатели системного оборудования. процессор, оперативная память, использование сети

## Сбросить статистику
```
cd $HOME/cosmos_node_monitoring
docker compose down
docker volume prune -f
```

## Справочный список
Ресурсы, используемые в этом проекте:
- Статистика Grafana Validator [Cosmos Validator от freak12techno](https://grafana.com/grafana/dashboards/14914)
- Состояние оборудования Grafana [AgoricTools от Chainode](https://github.com/Chainode/AgoricTools)
- Стек инструментов мониторинга, конфигурация докера [node_tooling от Xiphiar](https://github.com/Xiphiar/node_tooling/)
- И , который собирает все воедино [Kristaps](https://github.com/kj89)
