<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/babylon.png">
</p>



# Babylon Snapshot Setup
We take node snapshot every night at 00:00 UTC+3

You can browse the [logs](https://snap.nodeist.net/t/babylon/log.txt) for current snapshot date, block height, and file size information.

### Install lz4 (if needed)
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4
```

### Stop your node
```
sudo systemctl stop babylond
```

### Reset your node
This will erase your node database. If you are already running validator, be sure you backed up your `priv_validator_key.json` prior to running the the command.

```
babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book
```

### Download & Install the snapshot
```
curl -L https://snap.nodeist.net/t/babylon/babylon.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.babylond --strip-components 2
```

### Restart Service & Check Log:
```
sudo systemctl start babylond && journalctl -u babylond -f --no-hostname -o cat
```
