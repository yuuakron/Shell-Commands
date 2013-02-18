#!/bin/bash

version(){
    echo >&2 "1.0.0 (2012/11/19)"
    exit 1;
}

usage(){
    echo >&2 "usage: $0 [-v] [-s size] [input]"
    echo >&2 "-h: display usage"
    echo >&2 "-s: max column size"
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

element(){
    if [ "$opt_s" ];then
        input | cut -d, -f$1 | cut -c-"$opt_s" | sed -n "$2p" | sed 's/[[:cntrl:]]//g'
    else
        input | cut -d, -f$1 | sed -n "$2p" | sed 's/[[:cntrl:]]//g'
    fi
}

maxwidth(){
    max=-1

    for row in $(seq 1 $rowcount)
    do
        value=`element $1 $row | wc -c | sed 's/[[:space:]]//g'`
        if [ $value -gt $max ];then
            max=$value
        fi
    done

    echo $max
}

printline(){
    for num in $(seq 1 $1)
    do
        printf "-"
    done
    printf "\n"
}

while getopts hs:v flag
do
case $flag in
h )  usage;;
s )  opt_s="$OPTARG";;
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

columncount=`input | sed -n "1p" | sed 's/[^,]//g' | wc -c | sed 's/[[:cntrl:]]//g'`
rowcount=`input | wc -l | sed 's/[[:cntrl:]]//g'`

for column in $(seq 1 $columncount)
do
    if [ "$opt_s" ];then
        maxwidtharray=("${maxwidtharray[@]}" "$opt_s")
    else
        maxwidtharray=("${maxwidtharray[@]}" "`maxwidth $column`")
    fi
done

allwidth=0
for column in $(seq 1 $columncount)
do
    col=$(($column - 1))
    allwidth=$(($allwidth + ${maxwidtharray[$col]}))
done
allwidth=$(($allwidth + $columncount +1))

printline $allwidth

for row in $(seq 1 $rowcount)
do
    line=
    for column in $(seq 1 $columncount)
    do
        col=$(($column - 1))
        width=${maxwidtharray[$col]}
        elem=`element $column $row`
        if [ "$column" -eq 1 -o "$row" -eq 1 ];then
            line=$line`printf "|%-${width}s" "$elem"`
        else
            line=$line`printf "|%${width}s" "$elem"`
        fi
    done
    printf "$line|\n"

    if [ "$row" -eq 1 ];then
        printline $allwidth
    fi
done

printline $allwidth

exit 0