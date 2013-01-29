#!/bin/bash

version(){
    echo >&2 "1.0.0 (2012/11/27)"
    exit 1;
}

usage(){
    echo >&2 "usage: $0 [-v] [input]"
    echo >&2 "-h: display usage"
    echo >&2 "-o: output filename"
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

rowcount(){
    input | sed -n '2,$p' | wc -l
}

printLineNum(){
    for a in $(seq 1 "$1")
    do
        echo $a
    done
}

categoryelem(){
input | cut -d, -f1 | sed -n "$1p"
}

labelelem(){
input | sed -n "1p" | cut -d, -f$1
}

columncount(){
input | sed -n "1p" | sed "s/[^,]//g" | wc -c | sed 's/[[:space:]]//g'
}

#初期化
opt_o=output

while getopts ho:v flag
do
case $flag in
h )  usage;;
o )  opt_o="$OPTARG";;
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

tmpfile=`mktemp TEMPXXXXXX`
tmpfile2=`mktemp TEMPXXXXXX`
printLineNum `rowcount` > $tmpfile
input | cut -d, -f2- | sed -n '2,$p' | sed 's/,/ /g' | paste $tmpfile - > $tmpfile2

#X軸ラベルの指定
commands="set xtics rotate by -15 (\"`categoryelem 2`\" 1"
for num in $(seq 2 `rowcount`)
do
    num2=$(($num +1))
    commands=$commands",\"`categoryelem $num2`\" $num"
done
commands=$commands");"

#プロット
commands=$commands"plot \"$tmpfile2\" using 1:2 w lp title \"`labelelem 2`\";"
for num in $(seq 3 `columncount`)
do
    commands=$commands"replot \"$tmpfile2\" using 1:$num w lp title \"`labelelem $num`\";"
done

#出力
commands=$commands"set terminal jpeg size 960,720;set out \"${opt_o}.jpg\";replot"

#gnuplot
gnuplot -e "$commands"

rm $tmpfile
rm $tmpfile2

exit 0