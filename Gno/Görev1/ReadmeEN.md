<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Join Telegram<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Visit Our Website
</p>


# User Registration
### Currently there are 2 ways to register as a user in GNO.LAND:

*Get an invite by someone with invite privileges.*

*Submit 2,000 $GNOT to the user registration agreement (note that this will change to $100 in the near future for accessibility).*

Although we recommend joining the [Official Gnoland Discord Server](https://discord.gg/xD2c2Nmd) to request invites or backup $GNOTs from the community,
You can also use the faucet which gives 100 $GNOT per request.
However, the latter is an inadvisable approach as you will have to spam the faucet 20+ times.

### Once you have the $2,000 GNOT in hand, start Ubuntu and navigate to your working directory.

```
cd gno
```
### Check your wallet balance
Write your wallet address in the section that says `WALLETADDRESS`
Make sure you have at least 2000gnot balance.

```
./build/gnokey query auth/accounts/WALLETADDRESS --remote gno.land:36657
```

### Perform registration
Now we will create a file that will contain the information of the process that will register you as a user with the following command:
Replace where it says `WALLETADDRESS` and `USERNAME`. Specify a username to use as username. must be in lowercase letters only.
Do not use numbers and special characters.
```
./build/gnokey maketx call WALLETADDRESS --pkgpath "gno.land/r/users" --func "Register" --gas-fee 1gnot --gas-wanted 2000000 --send "2000gnot" --args "" --args "USERNAME" --args "" > unsigned.tx
```

### Perform the signature operation
Edit `WALLETADDRESS`, `ACCOUNTNUMBER`, `SEQUENCENUMBER` according to you.
```
./build/gnokey sign WALLETADDRESS --txpath unsigned.tx --chainid testchain --number ACCOUNTNUMBER --sequence SEQUENCENUMBER > signed.tx
```

### Publish the signature:
```
./build/gnokey broadcast signed.tx --remote gno.land:36657
```
*You should see your username [in the list found here](https://gno.land/r/users) if all operations are done correctly.*

# Task
Now we can move on to the task step.

Prepare and publish an English article about Gno.
Medium, twitter etc. You can use blog sites.

### After preparing your article, publish it by typing the code below;
Edit the `WALLETADDRESS` and `ARTICLELINK` sections according to you.
```
./build/gnokey maketx call WALLETADDRESS --pkgpath "gno.land/r/boards" --func "CreateReply" --gas-fee 1gnot --gas-wanted 2000000 --send "" --broadcast true --chainid testchain --args "1" --args "8" --args "8" --args "ARTICLELINK" --remote gno.land:36657
```

If the process is successful, you should see your article link on the [Quest Posts](https://gno.land/r/boards:gnolang/8) page.

