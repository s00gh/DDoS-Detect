#!/bin/bash

# We need to set the conditions that we consider as a potential DDoS attack
rate_limit_threshold=2
interval_sec=10
file="/var/log/apache2/access.log"

# We introduce a variable reqpersec to compare with the threshold later to detemine if there is a potential DDoS attack happening
# cat "$file" reads the contents of the file
# wc -l counts the number of lines in the file
total_req=$(cat "$file" | wc -l)
req_per_sec=$((total_req/interval_sec))

if (( req_per_sec > rate_limit_threshold )); then
	echo "----!!----WARNING: POTENTIAL DDoS ATTACK HAPPENING NOW----!!----"
	echo " TOTAL NUMBER OF REQUESTS = $total_req "
	echo " THRESHOLD = $rate_limit_threshold "
	echo " DURATION = $interval_sec "
	echo " NUMBER OF REQUESTS PER SECOND = $req_per_sec "
	echo " LOG FILE STORED IN /var/log/apache2/access.log "
else
	echo "It is unlikely that a DDoS attack is happening now. You are safe. Have a good day!"
fi
