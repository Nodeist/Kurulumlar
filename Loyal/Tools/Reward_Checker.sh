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

rewards=$(loyald query distribution rewards $(loyald keys show $wallet -a) -o json | jq '.total | to_entries' | jq -r ".[] | select(.value.denom == \"ulyl\") | .value.amount")
	if [[ -n "$rewards" ]]; then
		rewards_result=$(echo "$rewards / 1000000" | bc)

		echo "${rewards_result} lyl / ${rewards} ulyl"
	else
		echo "No rewards"
	fi

	echo "Checking validator commission..."

	commission=$(loyald query distribution commission $(loyald keys show $wallet --bech val -a) -o json | jq '.commission | to_entries' | jq -r ".[] | select(.value.denom == \"ulyl\") | .value.amount")
		if [[ -n "$commission" ]]; then
			commission_quick=$(echo "$commission / 1000000" | bc)

			echo "${commission_quick} lyl / ${commission} ulyl"
		else
			echo "No commissions"
		fi
