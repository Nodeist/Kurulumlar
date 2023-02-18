<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/blockx.png">
</p>


# Blockx Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
4a7401f7d6daa39d331196d8cc179a4dcb11b5f9@143.198.110.221:26656,49a5a62543f5fec60db42b00d9ebe192c3185e15@143.198.97.96:26656,dccf886659c4afcb0cd4895ccd9f2804c7e7e1cd@143.198.101.61:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=4a7401f7d6daa39d331196d8cc179a4dcb11b5f9@143.198.110.221:26656,49a5a62543f5fec60db42b00d9ebe192c3185e15@143.198.97.96:26656,dccf886659c4afcb0cd4895ccd9f2804c7e7e1cd@143.198.101.61:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.blockxd/config/config.toml
```
