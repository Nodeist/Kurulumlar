<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/bluzelle.png">
</p>


# Bluzelle Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
d3150799a6be2561ed6df3e266264140a6e2514d@35.158.183.94:26656,ec45a9687a7aa8c3aeebe1d135d255c450e5ad02@13.57.179.7:26656,ecec40366517cafc9db0b638ebab28ad6344a2f4@18.143.156.117:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=d3150799a6be2561ed6df3e266264140a6e2514d@35.158.183.94:26656,ec45a9687a7aa8c3aeebe1d135d255c450e5ad02@13.57.179.7:26656,ecec40366517cafc9db0b638ebab28ad6344a2f4@18.143.156.117:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.curium/config/config.toml
```
