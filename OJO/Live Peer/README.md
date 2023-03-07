<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/ojo.png">
</p>


# OJO Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
5af3d50dcc231884f3d3da3e3caecb0deef1dc5b@142.132.134.112:25356,c0ee71c74858b339787320596b805ed631c48ebb@213.133.100.172:27433,affee2f485ca15c68c302ad98e8de41fcd0e71ba@162.19.238.49:26656,fbeb2b37fe139399d7513219e25afd9eb8f81f4f@65.21.170.3:38656,dc19e5d986ea79e70180cfbee7789de9cd79e14e@95.217.57.232:56656,97ff540b57b89dd0b6737eddb92977523dd5a7b3@195.3.221.58:12656,8a8b9a8a58c922a7693715100710697ec69b1478@65.109.92.235:11086,7416a65de3cc548a537dbb8bdf93dbd83fe401d2@78.107.234.44:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=5af3d50dcc231884f3d3da3e3caecb0deef1dc5b@142.132.134.112:25356,c0ee71c74858b339787320596b805ed631c48ebb@213.133.100.172:27433,affee2f485ca15c68c302ad98e8de41fcd0e71ba@162.19.238.49:26656,fbeb2b37fe139399d7513219e25afd9eb8f81f4f@65.21.170.3:38656,dc19e5d986ea79e70180cfbee7789de9cd79e14e@95.217.57.232:56656,97ff540b57b89dd0b6737eddb92977523dd5a7b3@195.3.221.58:12656,8a8b9a8a58c922a7693715100710697ec69b1478@65.109.92.235:11086,7416a65de3cc548a537dbb8bdf93dbd83fe401d2@78.107.234.44:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ojo/config/config.toml
```
