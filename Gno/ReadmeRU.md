<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Join Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Visit Our Website
</p>




## Recommended hardware requirements
- CPU: 1 CPU
- Memory: 2GB of RAM
- Disk: 20 GB SSD Storage

*There is no node setup for now, there are simple tasks, system requirements will increase in the future and the document will be updated.*

# Gno.land Installation

### Updates and requirements
Installation and configuration

```
wget -O gno.sh https://raw.githubusercontent.com/Nodeist/Kurulumlar/main/Gno/gno.sh && chmod +x gno.sh && ./gno.sh

```

### Generate Mnemonic (don't forget to save!)
```
cd gno

./build/gnokey generate
```

Create Wallet with the generated mnemonic (Don't forget to back up the information provided.)
```
./build/gnokey add account --recover
```

### Request Tokens from the faucet:
https://gno.land/faucet

Check your balance. In the section that says 'walletadress', write the wallet address you just received.

```
./build/gnokey query auth/accounts/walletadress --remote gno.land:36657
```



You should see output similar to the following:

```
height: 0                                                            
data: {                                                                
"BaseAccount": {                                                       
"address": "g1lr8jsfhtd2du33rgknv2977nc0uefmcty06xpd",               
"coins": "100gnot",                                                   

"public_key": {                                                        
"@type": "/tm.PubKeySecp256k1",                                      
"value": "AxJXHJE8y+b/l3v0LBbdr7QmikZVEEl8j3BH6hE+lh5f"            },                                                                   

"account_number": "1731",                                            
"sequence": "2"                                                    }
```

"account_number": "1731",
"sequence": "2"

Save your account number and sequence.
