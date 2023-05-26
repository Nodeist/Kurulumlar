## Chain explorer
[https://exp.nodeist.net/cascadia](https://exp.nodeist.net/Cascadia)

## Public endpoints

* api: [https://api-cascadia.nodeist.net](https://api-cascadia.nodeist.net)
* rpc: [https://rpc-cascadia.nodeist.net](https://rpc-cascadia.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/cascadia/addrbook.json > $HOME/.cascadiad/config/addrbook.json
```

**live-peers**
```bash
peers="d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:15556,893b6d4be8b527b0eb1ab4c1b2f0128945f5b241@185.213.27.91:36656,046e5fdfcf33f221da082b8e4161689bcb915135@77.91.84.30:39656,783a3f911d98ad2eee043721a2cf47a253f58ea1@65.108.108.52:33656,ad417c4efa59e21b43e8e256c73b9939f1c22a0e@23.88.42.28:31656,2256cfe6777faf34317e90c5e12e2e9072322a95@162.55.183.155:10656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.cascadiad/config/config.toml
```
