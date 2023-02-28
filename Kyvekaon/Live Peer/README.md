<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kyve.png">
</p>


# Kyve Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
a16f15669692ac66d1eed3e32485077abdf4b08c@161.97.98.83:26656,e215ad0f0664a121efdd627cb580a5312bb6dd1f@65.109.104.171:28656,1a9a719766a43bac6949770362e0e742af0fa7de@135.181.214.190:26658,5e4396a64a069227e25cb34b35eda9693c8ec260@185.172.191.11:26656,1fa8c846f0bebaf6d1ddf803569709e3965f1999@185.144.99.33:26656,782359e3c4d543a605fda2cdbda4a439cb5a0bac@162.55.245.142:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=a16f15669692ac66d1eed3e32485077abdf4b08c@161.97.98.83:26656,e215ad0f0664a121efdd627cb580a5312bb6dd1f@65.109.104.171:28656,1a9a719766a43bac6949770362e0e742af0fa7de@135.181.214.190:26658,5e4396a64a069227e25cb34b35eda9693c8ec260@185.172.191.11:26656,1fa8c846f0bebaf6d1ddf803569709e3965f1999@185.144.99.33:26656,782359e3c4d543a605fda2cdbda4a439cb5a0bac@162.55.245.142:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml
```
