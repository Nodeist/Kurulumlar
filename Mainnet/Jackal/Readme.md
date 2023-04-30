## Chain explorer
[https://exp.nodeist.net/jackal](https://exp.nodeist.net/jackal)

## Public endpoints

* api: [https://api-jackal.nodeist.net](https://api-jackal.nodeist.net)
* rpc: [https://rpc-jackal.nodeist.net](https://rpc-jackal.nodeist.net)

## Peering

**addrbook**
```bash
curl -Ls https://ss.nodeist.net/jackal/addrbook.json > $HOME/.canine/config/addrbook.json
```

**live-peers**
```bash
peers="ad8afbc89ac64db1ee99fdd904cbd48876d44b7d@195.3.222.240:26256,c5b43622ecd7413dd41905f6f8f5b5befd299ced@65.109.65.210:32656,c2842c76779913e05fa4256e3caab852e1782951@202.61.194.254:60756,9bcaee1ad957fa75f60a6dd9d8870e53220794a9@104.37.187.214:60756,e0740626622af6f64c5c71cc8a2723bfc7eedf66@99.241.52.117:26456,d9bfa29e0cf9c4ce0cc9c26d98e5d97228f93b0b@65.109.88.38:37656,ee2ef67b49cbc7b4af7ff0b7321870a5d9ae69a5@65.108.138.80:17556,0daa5dcda773b1d3842ba2881cf27aab519a2cac@54.36.108.222:28656,af774f532cf4b53528b0c418d01dbec549207841@162.19.84.205:26656,519f2b648a2a8794ac33b195f39b6d836e09f8f2@131.153.154.13:26656,f3b96273f3b1a7d2594851badd4302f16db81cfa@23.29.55.92:26656,13cf937bc1525c587fa82b441013995238d68a6e@143.42.114.129:26656,55bbee79c024a5032222ee4cac0d932c4033c63a@142.132.209.97:26656,976d837d399c0914cca7ba81fcd554b1f3d7a7bd@216.209.198.116:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.canine/config/config.toml
```
