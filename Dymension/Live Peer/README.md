<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/dymension.png">
</p>


# Dymension Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
dc237ba44f4f178f6a72b60d9dee2337d424bfce@65.109.85.226:26656,3515bc6054d3e71caf2e04effaad8c95ee4b6dc6@165.232.186.173:26656,e9a375501c0a2eab296a16753667c708ed64649e@95.214.53.46:26656,2d05753b4f5ac3bcd824afd96ea268d9c32ed84d@65.108.132.239:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=dc237ba44f4f178f6a72b60d9dee2337d424bfce@65.109.85.226:26656,3515bc6054d3e71caf2e04effaad8c95ee4b6dc6@165.232.186.173:26656,e9a375501c0a2eab296a16753667c708ed64649e@95.214.53.46:26656,2d05753b4f5ac3bcd824afd96ea268d9c32ed84d@65.108.132.239:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.dymension/config/config.toml
```
