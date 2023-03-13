<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kyve.png">
</p>


# Kyve Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
7b3e38a97fdbebe73fd977d7da420019925a80cd@192.168.29.248:26656,100e5f097ebb73ecf0df415e419f3319cfc8458c@167.99.141.216:26656,f645af14c553021f838115caacd6f530a54233fa@192.168.1.177:26656,0fe8e7419225639ec2775e52952dfe74534275c5@135.181.215.62:26656,31afcf1856538f28afcc11e9ce78d32e981ab4ff@10.92.47.216:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=7b3e38a97fdbebe73fd977d7da420019925a80cd@192.168.29.248:26656,100e5f097ebb73ecf0df415e419f3319cfc8458c@167.99.141.216:26656,f645af14c553021f838115caacd6f530a54233fa@192.168.1.177:26656,0fe8e7419225639ec2775e52952dfe74534275c5@135.181.215.62:26656,31afcf1856538f28afcc11e9ce78d32e981ab4ff@10.92.47.216:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml
```
