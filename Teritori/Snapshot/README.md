<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/teritori.png">
</p>



# Teritori Snapshot Setup
We take node snapshot daily.

### Install lz4 (if needed)
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4
```

### Stop your node
```
sudo systemctl stop teritorid
```

### Reset your node
This will erase your node database. If you are already running validator, be sure you backed up your `priv_validator_key.json` prior to running the the command.

```
teritorid tendermint unsafe-reset-all --home $HOME/.teritorid --keep-addr-book
```

### Download & Install the snapshot
```
curl -L https://snap.nodeist.net/teritori/teritori.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.teritorid --strip-components 2
```

### Restart Service & Check Log:
```
sudo systemctl start teritorid && journalctl -u teritorid -f --no-hostname -o cat
```
