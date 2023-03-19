<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/realio.png">
</p>


# Realio Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
1cd70318b6a103cead4ee9e917ef927bc7889ca0@165.232.100.101:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=1cd70318b6a103cead4ee9e917ef927bc7889ca0@165.232.100.101:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.realio-network/config/config.toml
```
