#!/bin/sh

#loading ftp_settings.properties as a source file 
. conf/ftp_settings.properties

echo "Tranferring $1"
FILE=$1

ftp -n $host <<END_SCRIPT

quote USER $userID
quote PASS $password
put $FILE
quit
END_SCRIPT
exit 0