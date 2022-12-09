<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/nibiru.png">
</p>



# Nibiru Snapshot Setup
We take node snapshot daily.
Every Night at 00:00 UTC+3

### Install lz4 (if needed)
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4
```

### Stop your node
```
sudo systemctl stop nibid
```

### Reset your node
This will erase your node database. If you are already running validator, be sure you backed up your `priv_validator_key.json` prior to running the the command.

```
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book
```

### Download & Install the snapshot
```
curl -L https://snap.nodeist.net/t/nibiru/nibiru.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid --strip-components 2
```

### Restart Service & Check Log:
```
sudo systemctl start nibid && journalctl -u nibid -f --no-hostname -o cat
```
