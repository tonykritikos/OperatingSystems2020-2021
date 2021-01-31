#! /bin/bash


insert_contact(){

read -p "Type the first name, then the last name and then all the telephone numbers (use commas between every entry): " contact
awk -F ',' '{ for(i=1; i<=NF; i+=1) {printf "%s ", $i;}{printf "\n";}}' <<< $contact >> contacts.list

}


delete_contact(){

read -p "Give the person's last name: " lname
cat contacts.list | grep $lname
read -p "Do you want to delete that contact? Press 1 to delete it or anything else to not delete it: " yn
if [ $yn -eq 1 ]
then
	sed -i "/$lname/d" contacts.list
fi
}

search_contact(){

read -p "Give some element of the contact: " element
cat contacts.list | grep $element

}


modify_contact(){

read -p "Enter the contact that you want to modify: " contact
read -p "Enter the new entry: " newentry
sed -i "s/$contact/$newentry/" contacts.list

}


sort_by_first_name(){

cat contacts.list | sort -k 1

}


sort_by_last_name(){

cat contacts.list | sort -k 2

}


if [ -f contacts.list ]
then
	echo "";
else
	touch contacts.list;
fi


echo "1.Insert Contact"

echo "2.Delete Contact"

echo "3.Modify Contact"

echo "4.Search Contact"

echo "5.Sort Contacts by FirstName"

echo "6.Sort Contacts by LastName"

echo "7.Quit"

read -p "Type a number between 1-7: " number

if [ $number -eq "1" ]
then
	insert_contact
fi
if [ $number -eq "2" ]
then
	delete_contact
fi
if [ $number -eq "3" ]
then
	modify_contact
fi
if [ $number -eq "4" ]
then
	search_contact
fi
if [ $number -eq "5" ]
then 
	sort_by_first_name
fi
if [ $number -eq "6" ]
then 
	sort_by_last_name
fi
if [ $number -eq "7" ]
then 
	echo "Nothing to do, huh?"
fi 
	echo "Exited the script! :) "
