## Chain explorer
[https://exp.nodeist.net/timpi](https://exp.nodeist.net/Timpi)

## Public endpoints

* api: [https://api-timpi.nodeist.net](https://api-timpi.nodeist.net)
* rpc: [https://rpc-timpi.nodeist.net](https://rpc-timpi.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/timpi/addrbook.json > $HOME/.TimpiChain/config/addrbook.json
```

**live-peers**
```bash
peers="dfb017436f9d4898ffbacd26f9965bd1e273351b@148.113.138.171:26656,7d6938bdfce943c1d2ba10f3c3f0fe8be7ba7b2c@173.249.54.208:26656,319ec1fd84c147d49f08078aef085c57a8edf09a@45.79.48.248:26656,0373e97105a51c2711ba486f8906acb8da1978f7@167.235.153.124:26656,1a99c42921864c8dc322a579bd57ce2f4778a9f1@5.180.186.25:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.TimpiChain/config/config.toml
```
