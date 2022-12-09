<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/rebus.png">
</p>



# Rebus Snapshot Setup
We take node snapshot daily.

### Install lz4 (if needed)
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4
```

### Stop your node
```
sudo systemctl stop rebusd
```

### Reset your node
This will erase your node database. If you are already running validator, be sure you backed up your `priv_validator_key.json` prior to running the the command.

```
rebusd tendermint unsafe-reset-all --home $HOME/.rebusd --keep-addr-book
```

### Download & Install the snapshot
```
curl -L https://snap.nodeist.net/rebus/rebus.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.rebusd --strip-components 2
```

### Restart Service & Check Log:
```
sudo systemctl start rebusd && journalctl -u rebusd -f --no-hostname -o cat
```
