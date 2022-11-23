<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/acre.png">
</p>


# Acre Live Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=d86d7a9d8059ae726f3322ff1eb9e2797fe62a72@65.108.233.44:26616,06ab07aaa0d90c784f043c8e2b78c6a92182afea@109.123.246.47:26606,bac90a590452337700e0033315e96430d19a3ffa@23.106.238.167:26656,91c0b06f0539348a412e637ebb8208a1acdb71a9@178.162.165.193:21095,d01fb8d008cb5f194bc27c054e0246c4357256b3@31.7.196.72:26656,dbe9c383a709881f6431242de2d805d6f0f60c9e@65.109.52.156:7656,1264ee73a2f40a16c2cbd80c1a824aad7cb082e4@149.102.146.252:26656,e2d029c95a3476a23bad36f98b316b6d04b26001@49.12.33.189:36656,276be584b4a8a3fd9c3ee1e09b7a447a60b201a4@116.203.29.162:26656,e29de0ba5c6eb3cc813211887af4e92a71c54204@65.108.1.225:46656,ef28f065e24d60df275b06ae9f7fed8ba0823448@46.4.81.204:34656,4f3dd8908239b95a893df9615916a3a9e66fc5e6@155.133.22.171:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.teritorid/config/config.toml
```
