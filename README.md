# README
**This page contains tutorials on how to operate various crypto project servers.** 


&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

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

#### Kullanılan portlar:

| Network      | Port |
| ------------ | ---- |
| Celestia     | 30   |
| Clan         | 31   |
| Defund       | 32   |
| Deweb        | 33   |
| Kujira       | 34   |
| Kyve         | 35   |
| Quicksilver  | 36   |
| Sei          | 37   |
| BOŞ          | 38   |
| BOŞ          | 39   |
| Uptick       | 40   |
| Paloma       | 41   |
| Another-1    | 42   |
| CrowdControl | 43   |
| Stride       | 44   |
| Teritori     | 45   |
