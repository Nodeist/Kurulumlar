## Chain explorer
[https://exp.nodeist.net/lava](https://exp.nodeist.net/lava)

## Public endpoints

* api: [https://api-lava.nodeist.net](https://api-lava.nodeist.net)
* rpc: [https://rpc-lava.nodeist.net](https://rpc-lava.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/lava/addrbook.json > $HOME/.lava/config/addrbook.json
```

**live-peers**
```bash
peers="6171a52cf0ffc1706409d2dcec56c1db81c86aae@176.103.222.17:26656,6ba3b6ec03839afffa64c83e18ff80a681f4968d@65.108.194.40:21756,342dbbf200eb906eed6901cb5edf6d341b4ebc9b@170.64.140.230:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:14456,14ae45e7f2ff7491cfa686a8fcac7cc095bc38ff@213.239.217.52:39656,2c419186cd96b59fe8b3307c54c27d6805414aba@65.108.8.28:60756,5d24eb95fa5974af7bb03e370382537251ab6328@95.217.158.66:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.lava/config/config.toml
```
