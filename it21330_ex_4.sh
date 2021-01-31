#! /bin/bash

if [ -d $1 ]
then
	ls -lh "$1" | grep -v ^d | awk '{print $9}' > file
	while read -r line;
	do
		(echo -n "$line   " ; echo $line | wc | awk '{print $3/$2}';) 2> a; echo $a
	
	done < file
	rm file
	rm a
else
	echo "There is no such directory!"
fi