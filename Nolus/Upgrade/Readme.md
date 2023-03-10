<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/nolus.png">
</p>

# Nolus Upgrade 
> **Block Countdown can be found [here](https://nolus.explorers.guru/block/1327000)**


## Install New Binary
```
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.2.1-testnet
make build
```

## Check Version
```
# should be v0.2.1-testnet
nolusd version
```


## Make Cosmovisor Directory and Copy Binary
```
mkdir -p $HOME/.nolus/cosmovisor/upgrades/v0.2.1/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/upgrades/v0.2.1/bin/
rm -rf build
```


## Check Version Again
```
# should be v9.0.0
$HOME/.nolus/cosmovisor/upgrades/v0.2.1/bin/nolusd version
```
