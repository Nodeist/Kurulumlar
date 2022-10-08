#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="


sleep 2

set -e

wallet="wallet"

echo "Checking validator rewards..."

rewards=$(andromad query distribution rewards $(andromad keys show $wallet -a) -o json | jq '.total | to_entries' | jq -r ".[] | select(.value.denom == \"uandr\") | .value.amount")
	if [[ -n "$rewards" ]]; then
		rewards_result=$(echo "$rewards / 1000000" | bc)

		echo "${rewards_result} andr / ${rewards} uandr"
	else
		echo "No rewards"
	fi

	echo "Checking validator commission..."

	commission=$(andromad query distribution commission $(andromad keys show $wallet --bech val -a) -o json | jq '.commission | to_entries' | jq -r ".[] | select(.value.denom == \"uandr\") | .value.amount")
		if [[ -n "$commission" ]]; then
			commission_quick=$(echo "$commission / 1000000" | bc)

			echo "${commission_quick} andr / ${commission} uandr"
		else
			echo "No commissions"
		fi
