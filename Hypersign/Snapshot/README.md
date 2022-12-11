<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/hypersign.png">
</p>



# Hypersign Snapshot Setup
We take node snapshot every night at 00:00 UTC+3

You can browse the [logs](https://snap.nodeist.net/t/hid-node/log.txt) for current snapshot date, block height, and file size information.

### Install lz4 (if needed)
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4
```

### Stop your node
```
sudo systemctl stop hid-noded
```

### Reset your node
This will erase your node database. If you are already running validator, be sure you backed up your `priv_validator_key.json` prior to running the the command.

```
hid-noded tendermint unsafe-reset-all --home $HOME/.hid-node --keep-addr-book
```

### Download & Install the snapshot
```
curl -L https://snap.nodeist.net/t/hid-node/hid-node.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.hid-node --strip-components 2
```

### Restart Service & Check Log:
```
sudo systemctl start hid-noded && journalctl -u hid-noded -f --no-hostname -o cat
```
