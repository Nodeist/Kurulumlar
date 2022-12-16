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

wallet="second" # your wallet name
current_proposal=$(c4ed q gov proposals -o json | jq -r '.proposals[] | select(.status == "PROPOSAL_STATUS_VOTING_PERIOD") | .proposal_id' | tail -n 1)

	echo "Last proposal is: $current_proposal"

	while true
	do
		last_proposal=$(c4ed q gov proposals -o json | jq -r '.proposals[] | select(.status == "PROPOSAL_STATUS_VOTING_PERIOD") | .proposal_id' | tail -n 1)

			if [[ $current_proposal -lt $last_proposal ]]
			then
				echo "New proposal: $last_proposal"
				echo "Voting YES..."
				c4ed tx gov vote $last_proposal yes --from $wallet -y

				current_proposal=$last_proposal
			fi

			sleep 2
		done
