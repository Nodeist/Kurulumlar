## Chain explorer
[https://exp.nodeist.net/empower](https://exp.nodeist.net/Empower)

## Public endpoints

* api: [https://api-empower.nodeist.net](https://api-empower.nodeist.net)
* rpc: [https://rpc-empower.nodeist.net](https://rpc-empower.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/empower/addrbook.json > $HOME/.empowerchain/config/addrbook.json
```

**live-peers**
```bash
peers="e8b3fa38a15c426e046dd42a41b8df65047e03d5@95.217.144.107:26656,89ea54a37cd5a641e44e0cee8426b8cc2c8e5dfb@51.159.141.221:26656,0747860035271d8f088106814a4d0781eb7b2bc7@142.132.203.60:27656,3c758d8e37748dc692621a0d59b454bacb69b501@65.108.224.156:26656,41b97fced48681273001692d3601cd4024ceba59@5.9.147.185:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.empowerchain/config/config.toml
```
