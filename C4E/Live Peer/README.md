<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/c4e.png">
</p>


# C4E Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
96b621f209eb2244e6b0976a8918e1f6536d9a3d@34.208.153.193:26656,c1bfac5b59966c2fc97d48540b9614f34785fbf3@57.128.144.137:26656,f5d50df79f2aa5a9d18576147f59b8807347b6f9@66.70.178.78:26656,85acd1e5580c950f5ede07c3da4bd814d42cf323@95.179.190.59:26656,fe9a629d1bb3e1e958b2013b6747e3dbbd7ba8d3@149.102.130.176:26656,37f3f290c59dcce9109ac828e9839dc9c22be718@188.34.134.24:26656,bb9cbee9c391f5b0744d5da0ea1abc17ed0ca1b2@159.69.56.25:26656,2f6141859c28c088514b46f7783509aeeb87553f@141.94.193.12:11656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
peers="96b621f209eb2244e6b0976a8918e1f6536d9a3d@34.208.153.193:26656,c1bfac5b59966c2fc97d48540b9614f34785fbf3@57.128.144.137:26656,f5d50df79f2aa5a9d18576147f59b8807347b6f9@66.70.178.78:26656,85acd1e5580c950f5ede07c3da4bd814d42cf323@95.179.190.59:26656,fe9a629d1bb3e1e958b2013b6747e3dbbd7ba8d3@149.102.130.176:26656,37f3f290c59dcce9109ac828e9839dc9c22be718@188.34.134.24:26656,bb9cbee9c391f5b0744d5da0ea1abc17ed0ca1b2@159.69.56.25:26656,2f6141859c28c088514b46f7783509aeeb87553f@141.94.193.12:11656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.c4e-chain/config/config.toml
```
