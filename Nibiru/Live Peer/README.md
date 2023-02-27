<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/nibiru.png">
</p>


# Nibiru Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
dd58949cab9bf75a42b556d04d3a4b1bbfadd8b5@144.76.97.251:40656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=dd58949cab9bf75a42b556d04d3a4b1bbfadd8b5@144.76.97.251:40656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml
```
