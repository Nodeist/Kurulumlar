## Chain explorer
[https://exp.nodeist.net/ununifi](https://exp.nodeist.net/Ununifi)

## Public endpoints

* api: [https://api-ununifi.nodeist.net](https://api-ununifi.nodeist.net)
* rpc: [https://rpc-ununifi.nodeist.net](https://rpc-ununifi.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/ununifi/addrbook.json > $HOME/.ununifi/config/addrbook.json
```

**live-peers**
```bash
peers="1357ac5cd92b215b05253b25d78cf485dd899d55@[2600:1f1c:534:8f02:7bf:6b31:3702:2265]:26656,ed7e91350c4086fa1a2237978d4fbda50f9620a1@51.195.145.109:26656,1f954a27230c300417b4abf876dc26e1b243b6c6@128.1.131.123:26656,7fcfaf5941c0a4c22d39ec239862a97fda5dc5d8@159.69.59.89:26676,c25eea256d716ced4a156515bffe74709700d752@54.86.9.250:26656,5fe291fddba68eba46711af84cc9803629e42a6a@75.119.158.3:26656,cea8d05b6e01188cf6481c55b7d1bc2f31de0eed@3.101.90.205:26656,fa38d2a851de43d34d9602956cd907eb3942ae89@45.77.14.59:26656,67899600321bc673dce01489f0a79007cb44da96@139.144.77.82:26656,796c62bb2af411c140cf24ddc409dff76d9d61cf@[2600:1f1c:534:8f02:ca0e:14e9:8e60:989e]:26656,6031e074a44b10563209a0fb81a1fc08323796d7@192.99.44.79:23256,553d7226aaee5a043b234300f57f99e74c81f10c@88.99.69.190:26656,51da685a375d9fdebf20e989f3c2775a0f717d2d@184.174.35.252:26656,e9539642f4ca58bb6dc09257d4ba8fc00467235f@65.108.199.120:60656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.ununifi/config/config.toml
```
