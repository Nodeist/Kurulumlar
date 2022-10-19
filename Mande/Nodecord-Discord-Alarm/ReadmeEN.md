&#x20;                                                       [<mark style="color:red;">**Website**</mark>](https://nodeist.net/) | [<mark style="color:blue;">**Discord**</mark>](https://discord.gg/ypx7mJ6Zzb) | [<mark style="color:green;">**Telegram**</mark>](https://t.me/noodeist)

&#x20;                                     [<mark style="color:purple;">**100$ Credit Free VPS for 2 Months(DigitalOcean)**</mark>](https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

![](https://i.hizliresim.com/n5iirpq.png)



# Nodecord


Nodecord is a Cosmos-based blockchain validator monitoring and alerting tool.
Monitors and alerts for scenarios such as:
- Slashing period uptime
- Recent missed blocks (is the validator signing currently)
- Jailed status
- Tombstoned status
- Individual sentry nodes unreachable/out of sync
- Chain halted

Discord messages are created in the configured webhook channel for:
- Current validator status
- Detected alerts


## Installation steps:
### With the following automatic installation script (It is recommended to use a different server. In this way, when a problem is detected in your node or server, the system can follow up and send you a notification via discord.)
```
wget -O NODECORD.sh https://raw.githubusercontent.com/Nodeist/Nodecord/main/NODECORD && chmod +x NODECORD.sh && ./NODECORD.sh
```

## Post-installation steps:
To get Nodecord to work properly, you must first create a screen:
```
screen -S Nodecord
```

### Configuration settings:
Create a configuration file.
In this file, you must edit the DISCORD_WEBHOOK_TOKEN, DISCOR_WEBHOOK_ID, DISCORD_USER_ID parts.
You can find more information on creating a Discord webhook [here](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks).

Copy your url after creating webhook. it will look like this:
`https://discord.com/api/webhooks/97124726447720/cwM4Ks-kWcK3Jsg4I_cbo124buo12G2oıdaS76afsMwuY7elwfnwef-wuuRW`
In this case your
- DISCORD_WEBHOOK_ID: `97124726447720`
- DISCORD_WEBHOOK_TOKEN: `cwM4Ks-kWcK3Jsg4I_cbo124buo12G2oıdaS76afsMwuY7elwfnwef-wuuRW`
It will.
- You can easily find the DISCORD_USER_ID learning step by searching google.

Also, edit the **validators:** section for which node you want to report.
- Name: Network name (Kujira, Osmosis, Quicksilver etc.)
- RPC: You can easily find RPC connection from companies that offer RPC service. I usually follow Polkachu.
Example rpc for Kujira: **https://kujira-rpc.polkachu.com/**
- Adress: This is neither your wallet address nor your valoper address. Pay attention to this. It must be your consensus address. You can find it in explorers.
- Chain-id: **Kaiyo-1** for Kujira example

In the queue sentry section:
- name: The name of your server. You can give any name.
- grpc: your server's ip address + rpc port

If you are running the same node on more than one server. (if you are hosting a backup server)
- name
- grpc

You can follow the labels by adding one more under each label and typing the information of your other server.
Open your file by typing `nano ~/Nodecord/config.yaml`. You will see a screen similar to the one below. Edit and save where necessary.

```
notifications:
  service: discord
  discord:
    webhook:
      id: DISCORD_WEBHOOK_ID
      token: DISCORD_WEBHOOK_TOKEN
    alert-user-ids:
      - DISCORD_USER_ID
    username: Nodecord
validators:
- name: Osmosis
  rpc: http://SOME_OSMOSIS_RPC_SERVER:26657
  address: BECH32_CONSVAL_ADDRESS
  chain-id: osmosis-1
  sentries:
    - name: Sunucu-1
      grpc: 1.2.3.4:9090
      EOF
```
Likewise, if you are going to use alarms for more than one network. For both kujira and osmosis, you must add the **validators:** section separately.
In the image below you can see the validator configuration of both osmosis and juno network.

![nodeist](https://i.hizliresim.com/hplawtm.png)

### Initializing the monitor

You can initialize the monitor with the following code:

```
cd && cd Nodecord && Nodecord monitor
```
This code pulls data from the config.yaml file you created by default and starts tracking.
I am using two separate yaml files for testnet and mainnet.
You can also create a testnet.yaml file for testnet. and you can run it in separate screen with the following code.

```
cd && cd Nodecord && Nodecord monitor -f ~/testnet.yaml
```

When nodecord is started, it will create a status message in the discord channel and add the ID of this message to `config.yaml`. Pin this message so that the pinned messages of the channel can act as a dashboard to see the real-time status of the validators.
![Nodeist](https://i.hizliresim.com/6qt5b5t.png)

It will send warning messages when any error condition is detected.

![Nodeist](https://i.hizliresim.com/8ow2s04.png)

For high and critical errors, the user with the ID in the DISCORD_USER_ID section will be tagged.

![Nodeist](https://i.hizliresim.com/2g4vd1k.png)

It will send an information message when the errors are fixed.

## Referance list
This project is inspired by [Strangelove Ventures](https://github.com/strangelove-ventures).
