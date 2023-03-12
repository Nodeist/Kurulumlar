<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/8ball.png">
</p>

# 8Ball Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
fca96d0a1d7357afb226a49c4c7d9126118c37e9@one.8ball.info:26656,aa918e17c8066cd3b031f490f0019c1a95afe7e3@two.8ball.info:26656,98b49fea92b266ed8cfb0154028c79f81d16a825@three.8ball.info:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=fca96d0a1d7357afb226a49c4c7d9126118c37e9@one.8ball.info:26656,aa918e17c8066cd3b031f490f0019c1a95afe7e3@two.8ball.info:26656,98b49fea92b266ed8cfb0154028c79f81d16a825@three.8ball.info:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.8ball/config/config.toml
```
