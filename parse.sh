#!/bin/bash

# I set the "file" variable to contain logs from the file in the working directory /var/log/apache2
file="/var/log/apache2/access.log"

# then, I check if the file is empty. If it is empty, it will prompt me to generate some logs first before I run the bash script
if [ $file == 0 ]; then
	echo "access.log does not contain any logs!"
	exit 1
fi

# I define the variables SQLi_symbols and XSS_symbols to contain the common symbols/words that are used in SQLi and XSS attacks
SQLi_symbols=( "'" "--" "#" "/*...*/" "%" "+" "||" "<>" "!=" "<" ">" "<=" ">=" "==" "OR" "UNION" "DROP" "DELETE" "TRUNCATE" "SELECT" "UPDATE" "INSERT" "LIKE" "CONVERT" )
XSS_symbols=( "<" ">" "<script>" "</script>" )

# I use the "while" loop to repeatedly execute the code below as long as a certain condition is true
# "IFS= " by setting IFS to an empty value, we disable word splitting, ensuring that whitespaces are preserved
# "read" reads a line of input
# "-r" prevents the interpretation of backslashes, ensuring the line is read verbatim
# "line" is a variable that stores the content of each line read from the input source 
while IFS= read -r line; do
	for sqli in ${SQLi_symbols[@]}; do
		# * wildcard allows for partial matches, where the SQLi_symbol can appear anywhere in the line rather than having to match 1:1 with the line, which will then generate no results
		if [[ "$line" == *"$sqli"* ]]; then
			echo "$line"
			# "break" is used tterminate the inner loop once a matching symbol is found and continue to the next line in the log file, improving the efficiency of the bash script
			break
		fi
	done
	for xss in ${XSS_symbols[@]}; do
		if [[ "$line" == *"$xss"* ]]; then
			echo "$line"
			break
		fi
	done
# < "file" is used to redirect the content of "file" as input into the "while" loop
done < "$file"


