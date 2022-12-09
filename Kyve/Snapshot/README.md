<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/kyve.png">
</p>



# Kyve Snapshot Setup
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
sudo systemctl stop kyved
```

### Reset your node
This will erase your node database. If you are already running validator, be sure you backed up your `priv_validator_key.json` prior to running the the command.

```
kyved tendermint unsafe-reset-all --home $HOME/.kyve --keep-addr-book
```

### Download & Install the snapshot
```
curl -L https://snap.nodeist.net/t/kyve/kyve.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.kyve --strip-components 2
```

### Restart Service & Check Log:
```
sudo systemctl start kyved && journalctl -u kyved -f --no-hostname -o cat
```
