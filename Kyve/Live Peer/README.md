<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kyve.png">
</p>


# Kyve Live Peers
Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=94f8496c7f50cdbb3b6114b81356ecc547e5417a@95.217.239.213,bd1993c1595bc23ec3691056ea2041214aa01b40@148.251.47.69,abfb21fe07f6575ede31e8cf00f10c4fe07b03b0@167.235.31.186,4daaf2978669a3b5f79a777b81f5c2bb2dcf8dcf@75.119.134.69,f6f6f2fba5e2f0f859994b08b93d005b63eaa26d@195.201.237.172,a1e6b2f31f83fce519433286592809c7ec775261@5.161.85.85,16f8c16da06483cf620c42c7c59ac97eaeb011cf@168.119.213.113,802eb6c2b3277bf04eff9c74e16d0e05cc1a59e3@95.216.143.230,d2549f542370737bb07d2e6376984b5cf9dc871f@161.97.92.178,d57eed80e3f0ae8d27d0df5737816acd62001c97@75.119.130.253
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml
```
