## Instructions

### Stop the service and reset the data

```bash
sudo systemctl stop timpid
cp $HOME/.TimpiChain/data/priv_validator_state.json $HOME/.TimpiChain/priv_validator_state.json.backup
rm -rf $HOME/.TimpiChain/data
```

### Download latest snapshot

```bash
curl -L https://ss.nodeist.net/t/timpi/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.TimpiChain --strip-components 2
mv $HOME/.TimpiChain/priv_validator_state.json.backup $HOME/.TimpiChain/data/priv_validator_state.json
```

### Restart the service and check the log

```bash
sudo systemctl restart timpid && sudo journalctl -u timpid -f --no-hostname -o cat
```
