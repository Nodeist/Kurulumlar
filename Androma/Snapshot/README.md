<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/logos/androma.png">
</p>


# Androma Snapshot Setup
We take node snapshot daily.
(Every Night at 00:00 UTC+3)

You can browse the [logs](https://snap.nodeist.net/t/androma/log.txt) for current snapshot date, block height, and file size information.


### Install lz4 (if needed)
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4
```

### Stop your node
```
sudo systemctl stop andromad
```

### Reset your node
This will erase your node database. If you are already running validator, be sure you backed up your `priv_validator_key.json` prior to running the the command.

```
andromad tendermint unsafe-reset-all --home $HOME/.androma --keep-addr-book
```

### Download & Install the snapshot
```
curl -L https://snap.nodeist.net/t/androma/androma.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.androma --strip-components 2
```

### Restart Service & Check Log:
```
sudo systemctl start andromad && journalctl -u andromad -f --no-hostname -o cat
```
