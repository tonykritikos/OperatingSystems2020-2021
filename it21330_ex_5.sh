#! /bin/bash

a=`df -h / | awk '{print $5}' | grep  '^[0-9]'`
a=${a%?}

if (( $a <= 90 ))
then
	echo "$a% of your / filesystem is used. Ok!";
else
	echo "$a% of your / filesystem is used Delete some files!!!";
fi

