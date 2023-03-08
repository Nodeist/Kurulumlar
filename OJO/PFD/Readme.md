
<h1 align="center"> Install price-feeder</h1> 


```python
# set vars
OJO_MAIN_WALLET="MAIN_WALLET"
OJO_PFD_WALLET="PFD_WALLET"

# add validator wallet
ojod keys add $OJO_MAIN_WALLET --home $OJO_HOME

# add pfd wallet
ojod keys add $OJO_PFD_WALLET --home $OJO_HOME

# save vars
OJO_MAIN_ADDR=$(ojod keys show $OJO_MAIN_WALLET -a --home $OJO_HOME) && echo $OJO_MAIN_ADDR
OJO_VALOPER=$(ojod keys show $OJO_MAIN_WALLET --bech val -a --home $OJO_HOME) && echo $OJO_VALOPER
OJO_PFD_ADDR=$(ojod keys show $OJO_PFD_WALLET -a --home $OJO_HOME) && echo $OJO_PFD_ADDR

# check vars
echo $OJO_MAIN_WALLET,$OJO_PFD_WALLET,$OJO_MAIN_ADDR,$OJO_VALOPER,$OJO_PFD_ADDR | tr "," "\n" | nl 
# output 5 lines

echo "
export OJO_MAIN_WALLET=${OJO_MAIN_WALLET}
export OJO_PFD_WALLET=${OJO_PFD_WALLET}
export OJO_MAIN_ADDR=${OJO_MAIN_ADDR}
export OJO_VALOPER=${OJO_VALOPER}
export OJO_PFD_ADDR=${OJO_PFD_ADDR}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```

## build price-feeder
```python
cd $HOME
git clone https://github.com/ojo-network/price-feeder
cd price-feeder
git checkout v0.1.1
make install
```
## config price-feeder
```python

OJO_KEYRING="os"
OJO_KEYRING_PASSWORD="devnetdevnet"
OJO_RPC_PORT=26657
OJO_GRPC_PORT=9090

# save vars
echo "
export OJO_KEYRING=${OJO_KEYRING}
export OJO_KEYRING_PASSWORD=${OJO_KEYRING_PASSWORD}
export OJO_RPC_PORT=${OJO_RPC_PORT}
export OJO_GRPC_PORT=${OJO_GRPC_PORT}
" >> $HOME/.bash_profile

source $HOME/.bash_profile

mkdir -p $HOME/price-feeder_config

# get template
wget -O $HOME/price-feeder_config/price-feeder.toml "https://raw.githubusercontent.com/ojo-network/price-feeder/main/price-feeder.example.toml"

# check vars (vars were set above)
echo $OJO_CHAIN,$OJO_HOME,$OJO_VALOPER,$OJO_MAIN_ADDR,$OJO_KEYRING,$OJO_KEYRING_PASSWORD,$OJO_RPC_PORT,$OJO_GRPC_PORT | tr "," "\n" | nl 
# output 8 lines

# add pass option if use "os" or "file" keyring
sed -i '/^dir *=.*/a pass = ""' $HOME/price-feeder_config/price-feeder.toml

# set values
sed -i "s/^address *=.*/address = \"$OJO_MAIN_ADDR\"/;\
s/^chain_id *=.*/chain_id = \"$OJO_CHAIN\"/;\
s/^validator *=.*/validator = \"$OJO_VALOPER\"/;\
s/^backend *=.*/backend = \"$OJO_KEYRING\"/;\
s|^dir *=.*|dir = \"$OJO_HOME\"|;\
s|^pass *=.*|pass = \"$OJO_KEYRING_PASSWORD\"|;\
s|^grpc_endpoint *=.*|grpc_endpoint = \"localhost:${OJO_GRPC_PORT}\"|;\
s|^tmrpc_endpoint *=.*|tmrpc_endpoint = \"http://localhost:${OJO_RPC_PORT}\"|;" $HOME/price-feeder_config/price-feeder.toml
```

## Create service
```python
tee $HOME/price-feeder.service > /dev/null <<EOF
[Unit]
Description=OJO PFD
After=network.target
[Service]
User=$USER
Environment="PRICE_FEEDER_PASS=${OJO_KEYRING_PASSWORD}"
Type=simple
ExecStart=$(which price-feeder) $HOME/price-feeder_config/price-feeder.toml --log-level debug
RestartSec=10
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/price-feeder.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable price-feeder
sudo systemctl start price-feeder && journalctl -u price-feeder -f -o cat
```
## Fund and delegate price-feeder addr
```python
# fund
ojod tx bank send $OJO_MAIN_ADDR $OJO_PFD_ADDR 1000000uojo --fees 200uojo --home $OJO_HOME
# delegate pfd addr
ojod tx oracle delegate-feed-consent $OJO_MAIN_ADDR $OJO_PFD_ADDR --fees 400uojo --home $OJO_HOME
# edit config 
sed -i "s/^address *=.*/address= \"$OJO_PFD_ADDR\"/" $HOME/price-feeder_config/price-feeder.toml
sudo systemctl restart price-feeder && journalctl -u price-feeder -f -o cat
```
```python
# check ojo status
ojod status --home $OJO_HOME |& jq

# check price-feeder
ojod q oracle slash-window --home $OJO_HOME
ojod q oracle miss-counter $OJO_VALOPER --home $OJO_HOME
```
