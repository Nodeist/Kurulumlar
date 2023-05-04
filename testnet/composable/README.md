## Chain explorer
[https://exp.nodeist.net/composable](https://exp.nodeist.net/composable)

## Public endpoints

* api: [https://api-composable.nodeist.net](https://api-composable.nodeist.net)
* rpc: [https://rpc-composable.nodeist.net](https://rpc-composable.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/composable/addrbook.json > $HOME/.banksy/config/addrbook.json
```

**live-peers**
```bash
peers="bf95ad80f82320b8fefea75eeede60f563d1f847@168.119.91.22:26656,4775d0152d784b3ddf4f48c2d0ebddf961b52655@43.157.56.21:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:15956,f23a8daca1f65aeee7ce6f6d47a56542a08538c9@66.45.233.110:26656,13c29d1d66d604e8920ba0170276368e4e77f249@88.99.3.158:22256,4bf7484e2100e9da01180fff7055642263f34ccc@65.108.71.163:26656,4c1ea1da9fb0442201e79535d71f66a5e0e1e68c@51.91.30.173:3000"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.banksy/config/config.toml
```
