&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/k29umk7.png)


# Quicksilver Telegram Alarm Installation Guide
This system will alert you with telegram about jails and inactive status. Also it sends you every hour short info about your node status.
	
Instruction:
	
1. Create telegram bot via `@BotFather`, customize it and `get bot API token` ([how_to](https://www.siteguarding.com/en/how-to-get-telegram-bot-api-token)).
2. Create at least 2 groups: `alarm` and `log`. Customize them, add your bot into your chats and `get chats IDs` ([how_to](https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id)).
3. Connect to your server and create `status` folder in the `$HOME directory` with `mkdir $HOME/status/`.
4. In this folder you have to create `cosmos.sh` file with `nano $HOME/status/cosmos.sh`. You don't have to do any edits on `cosmos.sh` file, it's ready to use.
> You can find `cosmos.sh` in this repository.
5. In this folder you have to create `cosmos.conf` file with `nano $HOME/status/cosmos.conf`. Customize it.
> You can find `cosmos.conf` in this repository.
6. Also you have to create as many `NAME.conf` files with `nano $HOME/status/NAME.conf`, as many nodes you have on the current server.
Customize your config files.
> You can find `pylons.conf.ornek` and `curl.md` in this repository.
7. Install some packages with `sudo apt-get install jq sysstat bc -y`.
8. Run `bash cosmos.sh` to check your settings. Normal output:

```
root@Nodeist:~/status# bash cosmos.sh 
 
/// 2022-05-21 14:16:44 ///
 
pylons-testnet-3

sync >>> 373010/373010.
jailed > true.
 
/// 2022-05-21 14:16:48 ///
 
stafihub-public-testnet-2

sync >>> 512287/512287.
place >> 47/100.
stake >> 118.12 fis.

root@Nodeist:~/status# 
```

	
9. Create `slash.sh` with `nano $HOME/status/slash.sh`, if you don't have one yet. This bash script will divide group of messages.
> You can find `slash.sh.ornek` in this repository.
10. Add some rules with `chmod u+x cosmos.sh slash.sh`.
11. Edit crontab with `crontab -e`.
> You can find `crontab.ornek` in this repository.
12. Check your logs with `cat $HOME/status/cosmos.log` or `tail $HOME/status/cosmos.log -f`.


## Referance list
Resources used in this project:
- Status [By Cyberomanov](https://github.com/cyberomanov)
