## Chain explorer
[https://exp.nodeist.net/noria](https://exp.nodeist.net/Noria)

## Public endpoints

* api: [https://api-noria.nodeist.net](https://api-noria.nodeist.net)
* rpc: [https://rpc-noria.nodeist.net](https://rpc-noria.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/t/noria/addrbook.json > $HOME/.noria/config/addrbook.json
```

**live-peers**
```bash
peers="8336e98410c1c9b91ef86f13a3254a2b30a1a263@65.108.226.183:22156,e82fb793620a13e989be8b2521e94db988851c3c@165.227.113.152:26656,b55e2db9b3b63fde77462c4f5ce589252c5f45af@51.91.30.173:2009,4d8147a80c46ba21a8a276d55e6993353e03a734@165.22.42.220:26656,38de00b6d88286553eb123d16846190e5c594c59@51.79.30.118:26656,6b00a46b8c79deab378a8c1d5c2a63123b799e46@34.69.0.43:26656,31df60c419e4e5ab122ca17d95419a654729cbb7@102.130.121.211:26656,846731f7097e684efdd6b9446d562228640e2b14@34.27.228.66:26656,bb04cbb3b917efce76a8296a8411f211bad14352@159.203.5.100:26656,c3ee892de5052c2813a7e4968a3ba5c4518455cb@5.170.160.20:26656,aae38d6dd7a997000bd9ac195cb09fc1026f63d8@169.1.84.152:26656,0fbeb25dfdae849be87d96a32050741a77983b13@34.87.180.66:26656,419438c7cb152a88a30d6922a2b2c7077dd4daf5@88.99.3.158:22156,73e5dc6e04a1dd28e5851191eb9dede07f0b38fb@141.94.99.87:14095,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@176.9.82.221:22156"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.noria/config/config.toml
```
