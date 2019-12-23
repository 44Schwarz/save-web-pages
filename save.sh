#!/bin/bash

# A script to save web pages to the web archive
# Pass a filename with urls or a single url

BASE_URL='https://web.archive.org/save/'

usage() {
	echo "Usage: ./save.sh [[-f file] | [-u url] | [-h]]"
}

make_request() {
	if [ -z "$1" ]; then
		return;
	fi
	full_url="$BASE_URL$1"
	# echo $full_url
	curl --silent -I $full_url 1>> work.log
	if [ "$?" != 0 ]; then
		echo "Something went wrong while fetching $1"
	fi
}

read_file() {
	file=$1
	if [ -f "$file" ]; then
		while IFS='' read -r line; do
			make_request $line
		done < $file
	else
		echo "File $file does not exist"
		exit 2
	fi

}

if [ -z "$1" ]; then
	usage
	exit
fi

while [ -n "$1" ]; do
    case $1 in
        -f | --file )           shift
                                read_file $1
                                ;;
        -u | --url )            shift
		                make_request $1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

