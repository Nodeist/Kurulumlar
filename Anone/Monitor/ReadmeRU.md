<p style="font-size:14px" align="right">
 100$ Бесплатный VPS на 2 Месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Присоединяйтесь к Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Посетите наш сайт
</p>




<p align="center">
  <img height="100" src="https://i.hizliresim.com/cdpen5h.png">
</p>

# Another-1 Руководство по установке монитора Grafana
## Предпосылки

### Загрузите `exporter` на сервер, на котором установлена ​​ваша нода.
```
wget -O NodeistorExporter.sh https://raw.githubusercontent.com/Nodeist/Nodeistor/main/NodeistorExporter && chmod +x NodeistorExporter.sh && ./NodeistorExporter.sh
```
Во время установки вам будет предложено ввести некоторую информацию. Эти:

| КЛЮЧ | ЗНАЧЕНИЕ |
|----------|--------------|
| **bench_denom** | Номинальная стоимость. Например, `uan1` для Another-1 |
| **bench_prefix** | Значение префикса скамейки. Например `one` для Another-1. Узнать это значение можно по адресу вашего кошелька. **one1**jcqum902je9zwevat7zqczskwd4lhwuj9vwgsu |
| **adresport** | address порт. По умолчанию 9090. проверить app.toml |
| **ladrport** | ladr Порт. По умолчанию 26657. Проверьте в config.toml. |

** Если вы установили наш узел из нашего документа, вы можете проверить адрес порта «Another-1» на нашей странице установки. **

![nodeist](https://i.hizliresim.com/8nedatw.png)

В этом примере наш порт Another-1 — «42», как вы можете видеть на рисунке.

Это означает: Ваш «адрес», который по умолчанию равен «9090», будет «42090», если вы установили узел из нашего документа.

Точно так же ваш «ladrport», который по умолчанию равен «26657», равен «42657».

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
- И [Kristaps](https://github.com/kj89), который собирает все воедино
