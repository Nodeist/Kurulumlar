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

ADDRESS="stride10dahvqtd229q8ndggjk0upcjnkjckdjaup0uw0"
VALIDATOR="stridevaloper10dahvqtd229q8ndggjk0upcjnkjckdjal5tqz2"
KEY_NAME="wallet"
PASS="walletpass"
CHAIN_ID="stride-1"
GAS_VALUE="auto"
#FEE_VALUE=""

############ AUTO DELEGATION #########

# Withdraw
while :
do
	echo $PASS | strided tx distribution withdraw-rewards "${VALIDATOR}"  --from "${KEY_NAME}" --commission --chain-id=${CHAIN_ID} --gas="${GAS_VALUE}" -y
	
	sleep 20s
	
	AVAILABLE_COIN=$(strided query bank balances ${ADDRESS} --output json | jq -r '.balances | map(select(.denom == "ustrd")) | .[].amount' | tr -cd [:digit:])
	KEEP_FOR_FEES=100000
	AMOUNT=$(($AVAILABLE_COIN - $KEEP_FOR_FEES))
	AMOUNT_FINAL=$AMOUNT"ustrd"
	
	
	# Delegate
	echo $PASS | strided tx staking delegate "${VALIDATOR}" "${AMOUNT_FINAL}" --from "${KEY_NAME}" --chain-id=${CHAIN_ID} -y
	date
	sleep 3600s
done;
