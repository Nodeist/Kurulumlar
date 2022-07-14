 <p style="font-size:14px" align="right">
Sağ üst köşeden forklamayı ve yıldız vermeyi unutmayın ;) <br> <img src="https://i.hizliresim.com/njbmdlb.png"/></p>
<p style="font-size:14px" align="center">
<b>Bu sayfa, çeşitli kripto proje sunucularının nasıl çalıştırılacağına ilişkin eğitimler içerir. </b><br><br>
<a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="64"/></a> <br>Telegrama Katıl. <br>
<a href="https://nodeist.net/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="64"/></a> <br>Websitemizi Ziyaret et. 
</p>

Peer bul
```
curl -sS http://localhost:36657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

Aktif set
```
query staking validators --limit 2000 -o json | jq -r '.validators[] | select(.status=="BOND_STATUS_BONDED") | [.operator_address, .status, (.tokens|tonumber / pow(10; 6)), .description.moniker] | @csv' | column -t -s"," | sort -k3 -n -r
```

İnaktif set
```
query staking validators --limit 2000 -o json | jq -r '.validators[] | select(.status=="BOND_STATUS_UNBONDED") | [.operator_address, .status, (.tokens|tonumber / pow(10; 6)), .description.moniker] | @csv' | column -t -s"," | sort -k3 -n -r
```

### Kullanılan portlar: 

| Proje           | Port       |
| --------------- | ---------- |
| Celestia        |   30       |
| Aura            |   31       |
| Defund          |   32       |
| Deweb           |   33       |
| Kujira-Mainnet  |   34       |
| Kyve            |   35       |
| Quicksilver     |   36       |
| Sei             |   37       |
| Terra2          |   38       |
| Comdex          |   39       |
| Uptick          |   40       |
| Paloma          |   41       |
| Another-1       |   42       |
| CrowdControl    |   43       |
| CrowdControl    |   44       |
