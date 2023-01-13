<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/mars.png">
</p>


# Mars Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
e12bc490096d1b5f4026980f05a118c82e81df2a@85.17.6.142:26656,f3dceab155a74772595ae33ee6b72165c31fd888@62.171.166.106:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=e12bc490096d1b5f4026980f05a118c82e81df2a@85.17.6.142:26656,f3dceab155a74772595ae33ee6b72165c31fd888@62.171.166.106:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mars/config/config.toml

```
