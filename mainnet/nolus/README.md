## Chain explorer
[https://exp.nodeist.net/nolus](https://exp.nodeist.net/nolus)

## Public endpoints

* api: [https://api-nolus.nodeist.net](https://api-nolus.nodeist.net)
* rpc: [https://rpc-nolus.nodeist.net](https://rpc-nolus.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/nolus/addrbook.json > $HOME/.nolus/config/addrbook.json
```

**live-peers**
```bash
peers="39fa78be2d32bde352c7252c219f75ad81aaf14a@144.76.40.53:19756,18845b356886a99ee704f7a06de79fc8208b47d1@57.128.96.155:19756,e5e2b4ae69c1115f126abcd5aa449842e29832b0@51.255.66.46:2110,13f2ff36f5caeec4bca6705aebc0ce5fb65aefb3@168.119.89.8:27656,6cceba286b498d4a1931f85e35ea0fa433373057@169.155.170.20:26656,7740f125a480d1329fa1015e7ea97f09ee4eded7@107.135.15.66:26746,488c9ee36fc5ee54e662895dfed5e5df9a5ff2d5@136.243.39.118:26656,aeb6c84798c3528b20ee02985208eb72ed794742@185.246.87.116:26666,cbbb839a7fee054f7e272688787200b2b847bbf0@103.180.28.91:26656,67d569007da736396d7b636224b97349adcde12f@51.89.98.102:55666,e16568ad949050e0a817bddaf651a8cce04b0e7a@176.9.70.180:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.nolus/config/config.toml
```
