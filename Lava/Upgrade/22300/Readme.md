<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/lava.png">
</p>

# Chain upgrade to v0.4.3
> **Note** **Block Countdown can be found [here](https://lava.explorers.guru/block/22300)**

## Upgrade
Once the chain reaches the upgrade height, you will encounter the following panic error message:\
`ERR UPGRADE "xxx" NEEDED at height: 22300`
```
cd $HOME
git clone https://github.com/lavanet/lava
cd lava
git fetch --all
git checkout v0.4.3
make install
lavad version --long | head
sudo systemctl restart lavad && sudo journalctl -u lavad -f -o cat
```
