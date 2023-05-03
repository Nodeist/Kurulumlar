## Chain explorer
[https://exp.nodeist.net/ojo](https://exp.nodeist.net/ojo)

## Public endpoints

* api: [https://api-ojo.nodeist.net](https://api-ojo.nodeist.net)
* rpc: [https://rpc-ojo.nodeist.net](https://rpc-ojo.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/ojo/addrbook.json > $HOME/.ojo/config/addrbook.json
```

**live-peers**
```bash
peers="1786d7d18b39d5824cae23e8085c87883ed661e6@65.109.147.57:36656,9ea0473b3684dbf1f2cf194f69f746566dab6760@78.46.99.50:22656,ed367ee00b2155c743be6f5b635de6e7ea5acc64@149.202.73.104:11356,66b140833cba7cadd92d544088d735e219adbf01@65.108.226.183:21656,0621bb73d18724cae4eb411e6b96765f95a3345e@178.63.8.245:61356,b33500a3aaeb7fa116bdbddbe9c91c3158f38f8d@128.199.18.172:26656,e0fb84d102a7a43e13362c848df725d6868aed55@144.76.164.139:37656,9bcec17faba1b8f6583d37103f20bd9b968ac857@38.146.3.230:21656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.ojo/config/config.toml
```
