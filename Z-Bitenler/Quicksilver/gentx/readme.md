&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/k29umk7.png)


# Generate Quicksilver mainnet gentx

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=quicksilver-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt-get install make build-essential gcc git jq chrony -y
```

## Install go
```
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```

## Download and install binaries
```
git clone https://github.com/ingenuity-build/quicksilver && cd quicksilver
git fetch origin --tags
git checkout v0.6.4-rc.0
make install
```

## Config app
```
quicksilverd config chain-id $CHAIN_ID
quicksilverd config keyring-backend file
```

## Init node
```
quicksilverd init $NODENAME --chain-id $CHAIN_ID
```

## Recover or create new wallet for mainnet
Option 1 - generate new wallet
```
quicksilverd keys add $WALLET
```

Option 2 - recover existing wallet
```
quicksilverd keys add $WALLET --recover
```

## Add genesis account
```
WALLET_ADDRESS=$(quicksilverd keys show $WALLET -a)
quicksilverd add-genesis-account $WALLET_ADDRESS 51000000uqck
```

## Generate gentx
```
quicksilverd gentx $WALLET 50000000uqck \
--chain-id $CHAIN_ID \
--moniker=$NODENAME \
--commission-rate=0.05 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.01
```

## Things you have to backup
- `24 word mnemonic` of your generated wallet
- contents of `$HOME/.quicksilverd/config/*`

## Submit PR with Gentx
1. Copy the contents of ${HOME}/.quicksilverd/config/gentx/gentx-XXXXXXXX.json.
2. Fork https://github.com/ingenuity-build/mainnet
3. Create a file `<VALIDATOR_NAME>.json` under the `/gentxs/` folder in the forked repo, paste the copied text into the file.
4. Create a Pull Request to the main branch of the repository

### Launch day

1. Check to see if there has been a later release. 
  If we have had to push any last minute tweaks, ensure you have the latest version of the codebase.

2. Download genesis 
  Fetch genesis.json into quicksilverd's config directory (default: `~/.quicksilverd`). It shall be released 24h before the network starts.

  ```sh
  curl -s https://raw.githubusercontent.com/ingenuity-build/mainnet/main/genesis/genesis.tar.gz > genesis.tar.gz
  tar -C ~/.quicksilverd/config/ -xvf genesis.tar.gz
   ```
3. Check genesis

  ```sh
  shasum -a 256 ~/.quicksilverd/config/genesis.json
  ## XXX  /home/<user>/.quicksilverd/config/genesis.json
  ```

4. Start your node and get ready to play!
