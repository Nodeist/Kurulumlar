<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/mars.png">
</p>


# Mars Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
d2a2c21754be65ad4a4f1de1f6163f681a6e8af8@192.99.44.79:18556,2a66b2b518d908c91b734ac6bad07ae68e1553ba@141.94.171.61:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=d2a2c21754be65ad4a4f1de1f6163f681a6e8af8@192.99.44.79:18556,2a66b2b518d908c91b734ac6bad07ae68e1553ba@141.94.171.61:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mars/config/config.toml
```
