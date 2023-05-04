## Chain explorer
[https://exp.nodeist.net/andromeda](https://exp.nodeist.net/andromeda)

## Public endpoints

* api: [https://api-andromeda.nodeist.net](https://api-andromeda.nodeist.net)
* rpc: [https://rpc-andromeda.nodeist.net](https://rpc-andromeda.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/andromeda/addrbook.json > $HOME/.andromedad/config/addrbook.json
```

**live-peers**
```bash
peers="20248068f368f5d1eda74646d2bfd1fcdaffb3e1@89.58.59.75:60656,f81993a28a2cf0111dfa8b1943daba4691ef3825@45.142.214.163:26656,7ac17e470c16814be55aa02a1611b23a3fba3097@75.119.141.16:26656,064497a6f023caa1e5f1482425576540c22476fb@65.21.133.114:56656,b9836aff6d8e79b9a04b4a2a80d6007bf33a526b@198.244.179.125:32069,bd323d2c7ce260b831d20923d390e4a1623f32c4@213.239.215.195:20095,03603fb96ded3aabe7451efad31fb8d0c523a0ee@146.19.75.97:26656,72bba2142c9cada7e4b8e861fb79e8a66e345d99@95.217.236.79:50656,79d6dc8e8c827280f64164523d1ff02f9fde6f6d@38.242.230.118:26656,cdd5f44252e54bf8ebc4d35f10f1dbc40bb94128@194.163.134.227:26656,3c68a8074d2bfa2e5a4af81c64833871b3fa10f6@38.242.225.219:26656,315f2fa0bffec75bc93e449fd5dc194fe2d707e6@65.109.25.58:15656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.andromedad/config/config.toml
```
