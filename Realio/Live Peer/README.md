<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/realio.png">
</p>


# Realio Live Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=13de8696c1a4211beb99896408cb0e9b5c174bac@65.109.34.9:65.109.34.9:36656,aa194e9f9add331ee8ba15d2c3d8860c5a50713f@143.110.230.177:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.realio-network/config/config.toml
```
