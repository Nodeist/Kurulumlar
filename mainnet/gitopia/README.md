## Chain explorer
[https://exp.nodeist.net/gitopia](https://exp.nodeist.net/Gitopia)

## Public endpoints

* api: [https://api-gitopia.nodeist.net](https://api-gitopia.nodeist.net)
* rpc: [https://rpc-gitopia.nodeist.net](https://rpc-gitopia.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/gitopia/addrbook.json > $HOME/.gitopia/config/addrbook.json
```

**live-peers**
```bash
peers="4cf66531681c92f15c95c25bd1bff524f9dca35e@65.109.154.181:26656,b2f764694d52e09793d68259d584ece0c194b6fe@65.108.229.93:26656,082e95b5d5351e68dcfb24dff802f9064cfd5a4c@65.109.92.241:51056,a94aec7233f9fec2b2de4b5c9dab6ad979820b3d@65.109.104.118:60756,a0ebd1e5845148c47451452047c7c99621da195e@65.109.96.93:60556,4adfa5889675e1e91ea4459e15ff4a0ba53e7828@65.108.224.156:19656,12f6b84a23b054a6591c647c2a4456c40af65cce@5.9.147.22:24657,88497ab3bbbcc1e8545771f45020e738bcce590f@95.165.89.222:24136,abca18ed112719b4f0a23932797dba2733f0fd44@23.88.5.169:25656,976d95adec7f0d7fda4464df019fa538fa0bb4ce@144.76.97.251:44656,ffd761a9e0d86609de6dae5935f99451694051a9@34.28.130.17:26656,5b2df98ad73a0a81a5bd31da4489a9236a7d7a99@65.21.91.160:26867,712dd67b7abe08577d394e90a4930492c8f7d2ee@65.108.124.219:41656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.gitopia/config/config.toml
```
