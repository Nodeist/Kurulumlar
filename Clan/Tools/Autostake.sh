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

ADDRESS="clan1cc8kv5nhw39hhjqk62etc92a7vulsxeayedhf5"
VALIDATOR="clanvaloper1cc8kv5nhw39hhjqk62etc92a7vulsxeaxkkwrj"
KEY_NAME="wallet"
PASS="1234"
CHAIN_ID="playstation-2"
GAS_VALUE="auto"
FEE_VALUE="300uclan"

############ AUTO DELEGATION #########

# Withdraw
while :
do
	echo $PASS | cland tx distribution withdraw-rewards "${VALIDATOR}"  --from "${KEY_NAME}" --commission --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" --fees="${FEE_VALUE}" -y
	
	sleep 20s
	
	AVAILABLE_COIN=$(cland query bank balances ${ADDRESS} --output json | jq -r '.balances | map(select(.denom == "uclan")) | .[].amount' | tr -cd [:digit:])
	KEEP_FOR_FEES=100000
	AMOUNT=$(($AVAILABLE_COIN - $KEEP_FOR_FEES))
	AMOUNT_FINAL=$AMOUNT"uclan"
	
	
	# Delegate
	echo $PASS | cland tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} --fees="${FEE_VALUE}" -y
	date
	sleep 90s
done;
