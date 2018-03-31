#!/bin/bash


# begin script

# check number arguments 

if [ $# -eq 0 ]
then
echo " ERROR! the number of arguments is 0">&2;
exit;
fi

 
if [ $# -gt 2 ] 
then 
echo " ERROR! the number of arguments is greater than expected">&2;
exit;
fi

#chek argument 2
### expr A012345 : '-\?[0-9]\+$' >/dev/null && echo num || echo not num

expr $2 : '-\?[0-9]\+$' >/dev/null && vv=1 || vv=0 #not num
if [ $vv -eq 0 ] 
then
echo " ERROR! the second argument is not a number">&2;
exit;
else
#Checking that the value of the parameter is greater than 0
     if [ $2 -lt 0 ]
     then
     echo " ERROR! value is less than 0">&2;
     exit;
     fi

fi

#chek argument 1

if ! [ -d "$1" ]; then
echo " ERROR! there is no such directory">&2;
exit;
fi

#Check if there is a folder for backup
if ! [ -d /tmp/backups ]; then
mkdir /tmp/backups
fi

#generate a name for the archive
an="$1";
#echo "$an";
#delete first char
an=${an:1:${#an}}
#replacement </> to <->
an1="${an//\//-}"
an2="$an1.tar.gz"
#echo "$an2";
#how many files
ann=$(ls -la /tmp/backups | grep "$an1" | wc -l );

#echo "name for search $an1 -- how many files $ann"

# new archive

if [ "$ann" -eq 0 ]
then
tar -czf "/tmp/backups/$an2" "$1"
exit;
fi

# continue archive for 1

if [ "$ann" -eq 1 ]
then
count=1 ;
mv "/tmp/backups/$an2" "/tmp/backups/$an1.$count.tar.gz"
tar -czf "/tmp/backups/$an2" "$1"
#exit;
fi


# continue archive for many

if [ "$ann" -gt 1 ]
then

let count=$ann-1;
while [ $count -ge 1 ]
do
let count1=$count+1; 
mv "/tmp/backups/$an1.$count.tar.gz" "/tmp/backups/$an1.$count1.tar.gz"
let count=$count-1;
let count1=$count1-1;
done

if [ "$count" -eq 0 ]
then
mv "/tmp/backups/$an2" "/tmp/backups/$an1.$count1.tar.gz"
tar -czf "/tmp/backups/$an2" "$1"
#exit;
fi
fi

#delete unnecessary archives

#let ann=$ann+1;
ann=$(ls -la /tmp/backups | grep "$an1" | wc -l );
#echo " >>>>>>>>>>>>>>>>  $ann"
if [ $2 -eq 0 ]
then
echo " ERROR! you can not delete all the archives. removal was not performed">&2;
exit;
fi

#fordel=$($ann-$2);

if [ $ann -le $2 ]
then
exit;
fi

if [ $ann -gt $2  ]
then
let fordel=$ann-$2;
let fordel1=$ann-1;
while [ $fordel -ge 1 ]
do
#let count1=$count+1;
rm "/tmp/backups/$an1.$fordel1.tar.gz"
let fordel=$fordel-1;
let fordel1=$fordel1-1;
#let count1=$count1-1;
done
#exit;
fi



#echo "========================="
#for n in "$@"
#do
#  echo "$n"
#done
#echo "end of script";
