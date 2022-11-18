#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="                                     


sleep 2

############ SET PROPERTIES #########

ADDRESS="rebus1cvn7ldc24lvhhkyxz75x66hmmuppm2hpgzfjc8"
VALIDATOR="rebusvaloper1cvn7ldc24lvhhkyxz75x66hmmuppm2hpk44ddy"
KEY_NAME="wallet"
PASS="walletpass"
CHAIN_ID="reb_1111-1"
GAS_VALUE="auto"
#FEE_VALUE=""

############ AUTO DELEGATION #########

# Withdraw
while :
do
	echo $PASS | rebusd tx distribution withdraw-rewards "${VALIDATOR}"  --from "${KEY_NAME}" --commission --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" -y
	
	sleep 20s
	
	AVAILABLE_COIN=$(rebusd query bank balances ${ADDRESS} --output json | jq -r '.balances | map(select(.denom == "arebus")) | .[].amount' | tr -cd [:digit:])
	KEEP_FOR_FEES=100000
	AMOUNT=$(($AVAILABLE_COIN - $KEEP_FOR_FEES))
	AMOUNT_FINAL=$AMOUNT"arebus"
	
	
	# Delegate
	echo $PASS | rebusd tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} -y
	date
	sleep 90s
done;
