#!/bin/bash

#Defaults
FILE=""
COMPANY=""
TRANFERFILE=""
OUTPUTFILE=""
FILENAME=""

# Functions
printUsage(){
        # either 0 or >2 arguments were passed...error out.
        echo "*********************************************************"
        echo "* Usage: "
        echo "* -f | --file			Pass the input file as an argument on the command line."
        echo "* -c | --company		Pass the company name for which this file will be prepared (volcom|electric)."
        echo "* -t | --transfer		Pass -t or --transfer as an additional argument to transfer the file via ftp."
        echo "* -o | --output		Pass -o or --output to print the results to the console instead of the output file (for debugging purposes)."
        echo "* Example: ./run.sh -f FC_System.txt"
        echo "*********************************************************"
        exit 1             
}

copyFile(){
	# Copy the file to the root dir and change the name
	# The correct file name should be in the following format:
	# KWI-VOLCOM-ARTICLE-??????-??????.TXT  MUST BE *.TXT not *.txt (yyMMdd-hhmmss)
	# hard code time component to 141002
	now=$(date +"%y%m%d")		

	FILENAME="KWI-VOLCOM-ARTICLE-$now-141002.TXT"
	
	cp tmp/temp_file.txt $FILENAME
}

# ###############################################################
# Remove all " characters from the file.
#
removeQuotes(){
	sed -b -i.orig s/\"//g tmp/temp_file.txt
}

            
while [[ $1 == -* ]]; do
  case "$1" in
    -f|--file) FILE=$2; shift 2;;
    -c|--company) COMPANY=$2; shift 2;;
    -t|--transfer) TRANSFERFILE="yup"; shift;;
	-o|--output) OUTPUTFILE="console"; shift;;
    --) shift; break;;
    -*) 
		echo "invalid option: $1" 1>&2
		printUsage
		exit 1;;
  esac
done

# Validate input
if [ "$FILE" = "" ]; then
	echo "Missing file parameter (-f)"
	printUsage
	exit 1
fi

if [ "$COMPANY" = "" ]; then
	echo "Missing company parameter (-c)"
	printUsage
	exit 1
fi

#lower case the company variable to allow for case insensitivity
COMPANY=${COMPANY,,}
echo "$COMPANY"

if [ $COMPANY != "volcom" ] && [ $COMPANY != "electric" ]; then
	echo "Unknown company parameter (-c)"
	printUsage
	exit 1
fi

echo "Processing $FILE"

if [ "$COMPANY" = "volcom" ]; then
	echo "Processing with volcom logic"
	if [ "$OUTPUTFILE" != "" ]; then
		# Remove quote characters from the file
		sed -i s/\"//g $FILE
		# print to console
		bin/transform_volcom.awk $FILE
		echo "Process complete"
		exit 0
	else
		# print to tmp file
		bin/transform_volcom.awk $FILE > tmp/temp_file.txt
		removeQuotes
		copyFile
	fi
fi

if [ "$COMPANY" = "electric" ]; then
	echo "Processing with electric logic"
	if [ "$OUTPUTFILE" != "" ]; then
		# Remove quote characters from the file
		sed -i s/\"//g $FILE
		# print to console
		bin/transform_electric.awk $FILE
		echo "Process complete"
		exit 0
	else
		# print to tmp file
		bin/transform_electric.awk $FILE > tmp/temp_file.txt
		removeQuotes
		copyFile
	fi
fi


if [ "$TRANSFERFILE" == "yup" ]; then
   
	echo "Transferring file via ftp"
	bin/ftp.sh $FILENAME 

fi

echo "Process complete"
exit 0
