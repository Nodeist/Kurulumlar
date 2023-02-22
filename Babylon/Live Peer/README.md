<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/babylon.png">
</p>


# Babylon Live Peers
Here is a list of active peers. Add them to your `config.toml` if you have trouble finding peers.
```
0c5e0d543408a1082140f8bcce87d2021e88a1ac@144.76.109.221:33656,a4f76dddb6bdb195a0e49be82a3fd789d98631df@65.109.85.170:55656,fb4f8b0cf32bcf41fd2330c8d632f1d95004b127@54.83.122.43:26656,69ef025bead8bc5d9ad5297be2d8e6d01a864227@65.109.89.5:33656,f74f8c78f680dfddeb15158b5019c839b9e0db39@144.76.164.139:14656,b531acac8945962606025db892d86bb0bf0872af@3.93.71.208:26656,ed9df3c70f5905307867d4817b95a1839fdf1655@154.53.56.176:27656,cd9d96f554e7298a8d1f1a94489f7a51520f01ff@142.132.152.46:47656,e3f9ccbfc86011bb2bd6c2756b2c8b8dc4c8eb97@54.81.138.3:26656
```

Here is a script for you to update `persistent_peers` setting with these peers in `config.toml`.

```
PEERS=0c5e0d543408a1082140f8bcce87d2021e88a1ac@144.76.109.221:33656,a4f76dddb6bdb195a0e49be82a3fd789d98631df@65.109.85.170:55656,fb4f8b0cf32bcf41fd2330c8d632f1d95004b127@54.83.122.43:26656,69ef025bead8bc5d9ad5297be2d8e6d01a864227@65.109.89.5:33656,f74f8c78f680dfddeb15158b5019c839b9e0db39@144.76.164.139:14656,b531acac8945962606025db892d86bb0bf0872af@3.93.71.208:26656,ed9df3c70f5905307867d4817b95a1839fdf1655@154.53.56.176:27656,cd9d96f554e7298a8d1f1a94489f7a51520f01ff@142.132.152.46:47656,e3f9ccbfc86011bb2bd6c2756b2c8b8dc4c8eb97@54.81.138.3:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.babylond/config/config.toml
```
