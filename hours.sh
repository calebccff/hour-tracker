#!/bin/bash

# Simple script to note hours to a CSV
#
# TODO:
# * Sort by date
# * Retrieve weekly total

THIS=$0
FILE=$HOME/work/iob/hours.csv
DATE=$(date +"%y.%m.%d")

die() {
	echo $1 1>&2
	exit
}

usage() {
	echo "$THIS: $THIS [ -d DATE ] [ -s ] [ -f FILE ] [ -i ] <number of hours> [ note ]"
	echo ""
	echo "	Keep track of working hours quickly and easily with a simple CSV."
	echo ""
	echo "	-d			Optional date of the work (TODAY by default)
						To match default use 'YYYY.mm.dd' format."
	echo "	-s			Sort the CSV by date"
	echo "	-f FILE		Use CSV file instead of the default (hours.csv)"
	echo "	-i			Don't add column headers if creating FILE"
	return 1
}

while getopts "d:f:s" options; do
	case "${options}" in
		d)
			DATE=${OPTARG}
			;;
		s)
			JUST_SORT=true
			;;
		f)
			FILE=${OPTARG}
			;;
		i)
			NO_HEADERS=true
			;;
		h)
			usage
			exit 1
			;;
		:)
			die "-${OPTARG} requires an argument"
			;;
		*)
			usage
			exit 1
			;;
	esac
done

NUM_HOURS=${@:$OPTIND:1}
NOTE=${@:$OPTIND+1:1}

if [ "$JUST_SORT" = "true" ]; then
	echo "Sorting not yet supported"
	exit 1
fi

if [ -z $NUM_HOURS ]; then
	cat $FILE | sed 's/,/ ,/g' | sed 's/"//g' | column -t -s, -W 3
	exit 0
fi

# Add column headers to CSV if it doesn't exist
if [ ! -f $FILE ] && [ "$NO_HEADERS" != "true" ]; then
	echo "Date,Hours,Note" >> $FILE
fi

echo "\"${DATE}\",${NUM_HOURS},\"${NOTE}\"" >> $FILE
