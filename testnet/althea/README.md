## Chain explorer
[https://exp.nodeist.net/althea](https://exp.nodeist.net/althea)

## Public endpoints

* api: [https://api-althea.nodeist.net](https://api-althea.nodeist.net)
* rpc: [https://rpc-althea.nodeist.net](https://rpc-althea.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/althea/addrbook.json > $HOME/.althea/config/addrbook.json
```

**live-peers**
```bash
peers="16a9576c9a4cf9651b4215e3a877ae002555dd9b@116.202.117.229:31656,ba247bdf826a9636a8276d6a00d8004755f6bb18@162.19.238.210:26656,d5040e6aa2f190e04a39dc27e8199786a848e1cd@161.97.99.251:26156,eab7a70812ba39094fc8bbf4f69f099123863b38@81.30.157.35:11656,bdf94092f6dc380f6526f7b8b46b63192e95a033@173.212.222.167:29656,96320aaab7794933fddbc2bb101e54b8697c58e7@141.95.65.26:26656,17edf24237b1c2b5b196d344761f964407d05862@65.108.233.109:12456,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:52656,ff3fe47b494b0bf3dedf2d47dc9acf0e2ba3b7ae@65.108.43.113:52656,c5f4a56c4f1ba1cf3d4f8d787eb0f90d9cb963ec@65.109.34.133:61056,8cd0cf98fa86c01796b07d230aa5261e06b1b37d@95.217.206.246:26656,76932bbeb29836c6405329c21358d051ef6e33a3@65.109.65.163:21856,70caf9545f6fd67f2561964b0a69bf36ba6f81d4@5.161.205.63:26656,f6e3f995ba1c3ceed8bd556d9a23d2922d98a9a6@66.172.36.136:14656,0d4220d2bbda711183a8db6f45c26b1541fa0d6a@65.109.116.204:21856"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.althea/config/config.toml
```
