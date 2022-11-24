<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/gitopia.png">
</p>


# Genesis Mirror Download for Gitopia

The best place to download a chain genesis file is through its official hosting site (typically GitHub) as documented in the official doc. We offer a mirror download in case the official hosting site is down.

Our genesis file is uploaded from a fully-synced node. However, please still "trust but verify" before using our file.
```
wget -O genesis.json https://snapshots.nodeist.net/t/gitopia/genesis.json --inet4-only
mv genesis.json ~/.gitopia/config
```
