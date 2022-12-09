<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kujira.png">
</p>



# Kujira Snapshot Setup
We take node snapshot daily.

### Install lz4 (if needed)
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4
```

### Stop your node
```
sudo systemctl stop kujirad
```

### Reset your node
This will erase your node database. If you are already running validator, be sure you backed up your `priv_validator_key.json` prior to running the the command.

```
kujirad tendermint unsafe-reset-all --home $HOME/.kujira --keep-addr-book
```

### Download & Install the snapshot
```
curl -L https://snap.nodeist.net/kujira/kujira.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.kujira --strip-components 2
```

### Restart Service & Check Log:
```
sudo systemctl start kujirad && journalctl -u kujirad -f --no-hostname -o cat
```
