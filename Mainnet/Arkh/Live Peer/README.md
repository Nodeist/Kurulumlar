<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/arkh.png">
</p>


# Arkh Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
808f01d4a7507bf7478027a08d95c575e1b5fa3c@86.247.125.164:26656,889e31730df026e6cec506e26a0791368f8073a2@162.19.236.117:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=808f01d4a7507bf7478027a08d95c575e1b5fa3c@86.247.125.164:26656,889e31730df026e6cec506e26a0791368f8073a2@162.19.236.117:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.arkh/config/config.toml
```
