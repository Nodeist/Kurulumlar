<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/sao.png">
</p>


# Sao Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
a5298771c624a376fdb83c48cc6c630e58092c62@192.18.136.151:26656,59cef823c1a426f15eb9e688287cd1bc2b6ea42d@152.70.126.187:26656,e96613a87f825269bf81ece62a9c53e611f0143c@91.201.113.194:46656,91b67dd0d2904d95748e1ec5311e39033cfeaabc@65.109.92.240:1076,af7259853f202391e624c612ff9d3de1142b4ca4@52.77.248.130:26656,c196d06c9c37dee529ca167701e25f560a054d6d@3.35.136.39:26656,87aae9e66b092c79c6e5e1a7c64ec21128359f7e@144.76.97.251:37656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=a5298771c624a376fdb83c48cc6c630e58092c62@192.18.136.151:26656,59cef823c1a426f15eb9e688287cd1bc2b6ea42d@152.70.126.187:26656,e96613a87f825269bf81ece62a9c53e611f0143c@91.201.113.194:46656,91b67dd0d2904d95748e1ec5311e39033cfeaabc@65.109.92.240:1076,af7259853f202391e624c612ff9d3de1142b4ca4@52.77.248.130:26656,c196d06c9c37dee529ca167701e25f560a054d6d@3.35.136.39:26656,87aae9e66b092c79c6e5e1a7c64ec21128359f7e@144.76.97.251:37656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.sao/config/config.toml
```
