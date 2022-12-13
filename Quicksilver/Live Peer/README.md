<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/quicksilver.png">
</p>


# Quicksilver Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
b9b8bb23e61d53ff3b293485d04ea567ebcd7933@65.108.65.94:26656,a94cf3e93cec8eef6d67c2972e4af5eae1a118b2@65.108.2.27:26656,926ce3f8ce4cda6f1a5ee97a937a44f59ff28fbf@65.108.13.176:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=b9b8bb23e61d53ff3b293485d04ea567ebcd7933@65.108.65.94:26656,a94cf3e93cec8eef6d67c2972e4af5eae1a118b2@65.108.2.27:26656,926ce3f8ce4cda6f1a5ee97a937a44f59ff28fbf@65.108.13.176:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quicksilverd/config/config.toml
```
