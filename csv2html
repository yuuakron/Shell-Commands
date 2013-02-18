#!/bin/bash

version(){
    echo >&2 "1.0.0 (2012/11/27)"
    exit 1;
}

usage(){
    echo >&2 "usage: $0 [-v] [input]"
    echo >&2 "-h: display usage"
    echo >&2 "-v: display version"
    exit 1;
}

input(){
    if [ "${#buf[@]}" -ne 0 ];then
        for line in $(seq 0 "${#buf[@]}")
        do
            echo ${buf[$line]}
        done
    else
        cat $inputfile
    fi
}

while getopts hv flag
do
case $flag in
h )  usage;;
v )  version;;
* )  usage;;
esac
done

shift $(( $OPTIND - 1 ))

inputfile=$1

if [ "$#" -lt 1 ];then
    while read a;
    do
        buf=("${buf[@]}" "$a")
    done
fi

echo "<table border=1px>"

input | sed -n '1p' | sed 's/^/<tr><th>/' | sed 's/,/<\/th><th>/g' | sed 's/$/<\/th><\/tr>/'
input | sed -n '2,$p' | sed 's/^/<tr><td>/' | sed 's/,/<\/td><td>/g' | sed 's/$/<\/td><\/tr>/'

echo "</table>"

exit 0