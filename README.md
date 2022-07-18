<p style="font-size:14px" align="center">
  2 Aylık 100$ Kredili Ücretsiz VPS <br>
100$ Free VPS for 2 Month <br>
 100$ бесплатно VPS на 2 месяца <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
</p>
<p style="font-size:14px" align="center">
<b>Bu sayfa, çeşitli kripto proje sunucularının nasıl çalıştırılacağına ilişkin eğitimler içerir. </b><br>
<b>This page contains tutorials on how to operate various crypto project servers. </b><br>
<b>Эта страница содержит руководства по работе с различными серверами криптографических проектов. </b> <br>
<a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="64"/></a> <br>Telegrama Katıl.<br>Join Telegram.<br>Присоединяйтесь к Telegram.<br> <br>
<a href="https://nodeist.net/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="64"/></a> <br>Websitemizi Ziyaret et. <br>Visit Our Website. <br>Посетите наш сайт. <br>
<br> 
<a href="https://discord.gg/ypx7mJ6Zzb" target="_blank"><img src="https://cdn.logojoy.com/wp-content/uploads/20210422095037/discord-mascot.png" width="64"/></a> <br>Discord'a katıl <br>Join Discord <br>Присоединяйтесь к Discord <br>

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

| Network           | Port       |
| --------------- | ---------- |
| Celestia        |   30       |
| Clan            |   31       |
| Defund          |   32       |
| Deweb           |   33       |
| Kujira          |   34       |
| Kyve            |   35       |
| Quicksilver     |   36       |
| Sei             |   37       |
| BOŞ             |   38       |
| BOŞ             |   39       |
| Uptick          |   40       |
| Paloma          |   41       |
| Another-1       |   42       |
| CrowdControl    |   43       |
| Stride          |   44       |
| Teritori        |   45       |
