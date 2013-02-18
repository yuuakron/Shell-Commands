#!/bin/bash

version(){
    echo >&2 "1.0.0 (2012/11/15)"
    exit 1;
}

usage(){
    echo >&2 "usage: $0 [-chmrs] [-f inputformat] input ..."
    echo >&2 "-c: print CSV"
    echo >&2 "-e: print benchmark raw data( not normalized data )"
    echo >&2 "-f: input format"
    echo >&2 "-g: print gnuplot format"
    echo >&2 "-h: display usage"
    echo >&2 "-l: printing level(0:Sum of all results only 1: default ... x:all data)"
    echo >&2 "-m: Multi input from one File"
    echo >&2 "-n: no print error info"
    echo >&2 "-r: All files recursively"
    echo >&2 "-s: print CSV obtained by swaping rows and columns"
    echo >&2 "-v: display version"
    echo >&2 "inputformat: `UsageArgSign d` : CrystalDiskMark Mode"
    echo >&2 "inputformat: `UsageArgSign x`: Xbench Mode"
    echo >&2 "inputformat: `UsageArgSign c`: CrystalMark Mode"
    exit 1;
}

CrystalDiskMarkPattern1="Sequential Read\|Sequential Write\|Random Read 512KB\|Random Write 512KB\|Random Read 4KB (QD=1)\|Random Write 4KB (QD=1)\|Random Read 4KB (QD=32)\|Random Write 4KB (QD=32)"
CrystalDiskMarkPattern2=$CrystalDiskMarkPattern1"\|Test\|Date"
CrystalDiskMarkPattern=("" "$CrystalDiskMarkPattern1" "$CrystalDiskMarkPattern2")

CrystalMarkPattern0="CrystalMark :"
CrystalMarkPattern1=$CrystalMarkPattern0"\|^\[.*\]"
CrystalMarkPattern2=$CrystalMarkPattern1"\|Fibonacci\|Napierian\|Eratosthenes\|QuickSort\|MikoFPU\|RandMeanSS\|FFT\|Mandelbrot\|Read\|Write\|Read\/Write\|Cache\|RandomRead512K\|RandomWrite512K\|RandomRead 64K\|RandomWrite 64K\|Text\|Square\|Circle\|BitBlt\|Sprite\|Scene\|Lines\|Polygons"
CrystalMarkPattern3=$CrystalMarkPattern2"\|OS\|Display Mode\|Memory\|DirectX\|CPU Name\|Vendor String\|Name String\|CPU Type\|Number(Logical)\|Family\|Model :\|Stepping\|Feature\|Clock\|Data Rate\|ChipSet\|North\|South\|Video\|IDE Controller"
CrystalMarkPattern=("$CrystalMarkPattern0" "$CrystalMarkPattern1" "$CrystalMarkPattern2" "$CrystalMarkPattern3")

XbenchPattern0="Results"
XbenchPattern1=$XbenchPattern0"\|CPU Test\|Memory Test\|Quartz Graphics Test\|OpenGL Graphics Test\|User Interface Test\|Disk Test"
XbenchPattern2=$XbenchPattern1"\|GCD Loop\|Floating Point Basic\|vecLib FFT\|Floating Point Library\|System\t\|Stream\|Line\|Rectangle\|Circle\|Bezier\|Text\|Spinning Squares\|Elements\|Sequential\|Random"
XbenchPattern3=$XbenchPattern2"\|Allocate\|Fill\|Copy\|Scale\|Add\|Triad\|Uncached"
XbenchPattern4=$XbenchPattern3"\|Xbench Version\|System Version\|Physical RAM\|Model\|Drive Type"
XbenchPattern=("$XbenchPattern0" "$XbenchPattern1" "$XbenchPattern2" "$XbenchPattern3" "$XbenchPattern4")

patternError(){
    if [ ! "$opt_n" ];then
        echo >&2 "error: $1 : This printing level is not supported."
    fi
    exit 1
}

pattern(){
    isnum=`echo $opt_l | grep ^[0-9]*$`

    if [ ! "$isnum" ];then
        return 1
    fi

    case $opt_f in
    d ) p="${CrystalDiskMarkPattern[$opt_l]}";;
    c ) p="${CrystalMarkPattern[$opt_l]}";;
    x ) p="${XbenchPattern[$opt_l]}";;
    esac

    if [ "$p" ];then
        echo $p
    else
        return 1
    fi
}

#最大7つのコマンドまで追加可能
labelSedCommand(){
#non normalized
    if [ "$opt_e" ];then
        CrystalDiskMarkCommands=('s/ *\(.*\) : .*/\1/' 's/\(.*Read.*\)/\1[MB\/s]/' 's/\(.*Write.*\)/\1[MB\/s]/')
        CrystalMarkCommands=('s/\[ \(.*\) \].*/\1/' 's/ *\(.*\) :.* MB\/s .*/\1[MB\/s]/' 's/ *\(.*\) :.* FPS .*/\1[FPS]/'  's/ *\(.*\) :.*/\1/' 's/IDE *[0-9].*/HDD/' 's/SATA *[0-9].*/HDD/')
        GeekCommands=()
        XbenchCommands=('s/[[:cntrl:]][[:cntrl:]]\(.*\)[[:cntrl:]][[:cntrl:]].*/\1/' 's/\[/(/g' 's/\]/)/g' 's/ \([[:alpha:]]*\/sec\)/[\1]/g' 's/[[:cntrl:]][0-9\.]\{1,\}//g')
#normalized
    else
        CrystalDiskMarkCommands=('s/ *\(.*\) : .*/\1/' 's/\(.*Read.*\)/\1[MB\/s]/' 's/\(.*Write.*\)/\1[MB\/s]/')
        CrystalMarkCommands=('s/\[ \(.*\) \].*/\1/' 's/ *\(.*\) :.*/\1/' 's/IDE *[0-9].*/HDD/' 's/SATA *[0-9].*/HDD/')
        GeekCommands=()
        XbenchCommands=('s/[[:cntrl:]][[:cntrl:]]\(.*\)[[:cntrl:]][[:cntrl:]].*/\1/' 's/\[/(/g' 's/\]/)/g' 's/ \([[:alpha:]]*\/sec\)//g' 's/[[:cntrl:]][0-9\.]\{1,\}//g')
    fi

    case $opt_f in
    d ) echo "${CrystalDiskMarkCommands[$1]}";;
    c ) echo "${CrystalMarkCommands[$1]}";;
    x ) echo "${XbenchCommands[$1]}";;
    esac
}

#最大7つのコマンドまで追加可能
benchSedCommand(){
#non normalized
    if [ "$opt_e" ];then
        CrystalDiskMarkCommands=('s/.* : *\(.*\)/\1/' 's/\([0-9\.]*\) MB\/s.*/\1/')
        CrystalMarkCommands=('s/\[ .*\ ] *\(.*\)/\1/' 's/.*: *\(.*\)/\1/' 's/\([0-9\.]*\) MB\/s.*/\1/' 's/\([0-9\.]*\) FPS.*/\1/' 's/.*( *\([0-9]*\))/\1/')
        GeekCommands=()
        XbenchCommands=('s/.*[[:cntrl:]]\([0-9\.]*\).*\/sec.*/\1/' 's/[[:cntrl:]][[:cntrl:]].*[[:cntrl:]][[:cntrl:]]\(.*\)/\1/' 's/[[:cntrl:]][[:cntrl:]].*[[:cntrl:]]\(.*\)[[:cntrl:]].*/\1/' 's/.*[[:cntrl:]]\(.*\)[[:cntrl:]]/\1/')
#normalized
    else
        CrystalDiskMarkCommands=('s/.* : *\(.*\)/\1/' 's/\([0-9\.]*\) MB\/s.*/\1/')
        CrystalMarkCommands=('s/\[ .*\ ] *\(.*\)/\1/' 's/.*: *\(.*\)/\1/' 's/.*( *\([0-9]*\))/\1/')
        GeekCommands=()
        XbenchCommands=('s/[[:cntrl:]][[:cntrl:]][[:cntrl:]].*[[:cntrl:]]\(.*\)[[:cntrl:]].*/\1/' 's/[[:cntrl:]][[:cntrl:]].*[[:cntrl:]][[:cntrl:]]\(.*\)/\1/' 's/[[:cntrl:]][[:cntrl:]].*[[:cntrl:]]\(.*\)[[:cntrl:]].*/\1/' 's/.*[[:cntrl:]]\(.*\)[[:cntrl:]]/\1/')
    fi

    case $opt_f in
    d ) echo "${CrystalDiskMarkCommands[$1]}";;
    c ) echo "${CrystalMarkCommands[$1]}";;
    x ) echo "${XbenchCommands[$1]}";;
    esac
}

modeSign(){
    echo "c"
    echo "d"
    echo "x"
}

sign(){
    case $1 in
    d ) echo "CrystalDiskMark";;
    c ) echo "CrystalMark 2004R3";;
    x ) echo "^Results";;
    esac
}

argSign(){
    case $1 in
    d ) echo "d disk CrystalDiskMark";;
    c ) echo "c crystal CrystalMark";;
    x ) echo "x Xbench";;
    esac
}

UsageArgSign(){
    argSign $1 | sed 's/ / or /g'
}

toCSV(){
    echo `echo $@ | sed 's/,/./g' | sed 's/ /,/g'`
}

label(){
    p=`pattern`
    if [ "$?" -eq 1 ];then
        patternError $opt_l
    fi
    if [ "`checkMultiInputMode $1`" ];then
        p="$p""\|Platform :"
        mcommand='s/.*Platform :.*/Platform/'
    else
        echo 'Platform'
    fi
    grep "$p" "$1" | sed -e "`labelSedCommand 0`" -e "`labelSedCommand 1`" -e "`labelSedCommand 2`" -e "`labelSedCommand 3`" -e "`labelSedCommand 4`" -e "`labelSedCommand 5`" -e "`labelSedCommand 6`" -e "$mcommand" -e 's/[[:cntrl:]]//g'
}

labeltoCSV(){
    result=`label $1 | sed 's/ /¥/g'`
    toCSV $result | sed 's/¥/ /g'
}

labelwithMultiInput(){
    label $1 | sed -n "1,`columncount $1`p"
}

labeltoCSVwithMultiInput(){
    result=`labelwithMultiInput $1 | sed 's/ /¥/g'`
    toCSV $result | sed 's/¥/ /g'
}

printLabel(){
    if [ "$opt_c" -a ! "$opt_g" -a ! "$opt_s" ]; then
        for file in $@
        do
                if [ "`checkFileFormat $file $opt_f`" ]; then
                    if [ "`checkMultiInputMode $file`" ];then
                        labeltoCSVwithMultiInput $file
                    else
                        labeltoCSV $file
                    fi
                    return
                fi
        done
    fi
}

bench(){
    p=`pattern`
    if [ "$?" -eq 1 ];then
        patternError $opt_l
    fi

    if [ "`checkMultiInputMode $1`" ];then
        p="$p""\|Platform :"
        mcommand='s/.*Platform : *\(.*\)/\1/'
    elif [ ! "$opt_g" ];then
        basename $1 | sed 's/\..*$//'
    fi

    grep "$p" "$1" | sed -e "`benchSedCommand 0`" -e "`benchSedCommand 1`" -e "`benchSedCommand 2`" -e "`benchSedCommand 3`" -e "`benchSedCommand 4`"  -e "`benchSedCommand 5`"  -e "`benchSedCommand 6`" -e "$mcommand" -e 's/[[:cntrl:]]//g'
}

benchtoCSV(){
    result=`bench $1 | sed 's/ /¥/g'`
    echo `toCSV $result | sed 's/¥/ /g'`
}

benchtoCSVwithMultiInput(){
    line=""
    for a in $(seq 1 "`columncount $1`")
    do
        line=$line"- "
    done
    bench $1 | sed 's/,/./g' | paste -d , $line
}

benchtoSwapCSV(){
    if [ ! "$tmpfile" ];then
        tmpfile=`mktemp TEMPXXXXXX`
        label $1 | sed 's/,/./g' > $tmpfile
    fi
    tmpfile2=`mktemp TEMPXXXXXX`
    bench $1 | sed 's/,/./g' | paste -d , $tmpfile - > $tmpfile2
    rm $tmpfile
    tmpfile=$tmpfile2
}

benchtoSwapCSVwithMultiInput(){
    if [ ! "$tmpfile" ];then
        tmpfile=`mktemp TEMPXXXXXX`
        labelwithMultiInput $1 | sed 's/,/./g' > $tmpfile
    fi
    tmpfile2=`mktemp TEMPXXXXXX`
    columnnum=`columncount $1`
    column1=1
    column2=$columnnum

    for i in $(seq 1 "`rowcount $1`")
    do
       bench $1 | sed 's/,/./g' | sed -n "${column1},${column2}p" | paste -d , $tmpfile - > ${tmpfile2}
    tmp=$tmpfile
    tmpfile=${tmpfile2}
    tmpfile2=$tmp
    column1=$(($column1 + $columnnum))
    column2=$(($column2 + $columnnum))
    done

    rm ${tmpfile2}
}

benchtoGnuplot(){
    echo "$linenum "`bench $1 | sed -n '/^[0-9\.]*$/p'`
    linenum=$(($linenum + 1))
}

printLineNum(){
    for a in $(seq "$linenum" "$1")
    do
        echo $a
    done
}

columncount(){
    count=`label $1 | sed -n "1,/Platform/p" | wc -l`
    count=$(($count - 1))
    echo $count
}

columncountOnlyNum(){
    column=`columncount $1`
    numcount=`bench $1 | sed -n "1,${column}p" | sed -n '/^[0-9\.]\{1,\}$/p' | wc -l`
    echo $numcount
}

rowcount(){
    echo `grep "Platform :" "$1" | wc -l`
}

benchtoGnuplotwithMultiInput(){
    line=""
    for a in $(seq 1 "`columncountOnlyNum $1`")
    do
        line=$line"- "
    done 

    tmpfile=`mktemp TEMPXXXXXX`
    printLineNum `rowcount $1` > $tmpfile
    bench $1 | sed -n '/^[0-9\.]\{1,\}$/p' | paste $line | paste $tmpfile -
    rm $tmpfile
    linenum=$(($linenum + `rowcount $1`))
}

checkFileFormat(){
    grep "`sign $2`" "$1"
}

printBench(){
        if [ "`checkFileFormat $1 $opt_f`" ]; then
            if [ "$opt_g" -a "`checkMultiInputMode $1`" ];then
                benchtoGnuplotwithMultiInput $1
            elif [ "$opt_g" ];then
                benchtoGnuplot $1
            elif [ "$opt_s" -a "`checkMultiInputMode $1`" ]; then
                benchtoSwapCSVwithMultiInput $1 $tmpfile
            elif [ "$opt_s" ];then
                benchtoSwapCSV $1 $tmpfile
            elif [ "$opt_c" -a "`checkMultiInputMode $1`" ]; then
                benchtoCSVwithMultiInput $1
            elif [ "$opt_c" ];then
                benchtoCSV $1
            else
                bench $1
            fi
            return
        fi
    fileFormatError $1
}

fileError(){
    if [ ! "$opt_n" ];then
        echo >&2 "error: $1 : This file or directory not found."
    fi
}

modeError(){
    if [ ! "$opt_n" ];then
        echo >&2 "error: $1 : This mode is not supported."
    fi
    exit 1;
}

fileFormatError(){
    if [ ! "$opt_n" ];then
        echo >&2 "error: $1 : This file is not compatible with current mode."
    fi
}

unknownFileFormatError(){
    if [ ! "$opt_n" ];then
        echo >&2 "error : All files are not compatible with all mode."
    fi
    exit 1;
}

parseFiles(){
    for file in $@
    do
        if [ ! -e "$file" ]; then
            fileError $file
        fi

        if [ -f "$file" ]; then
            echo $file
        fi

        if [ -d "$file" ]; then
            for FILE in ${file}/*
            do
                if [ "$opt_r" ]; then
                    parseFiles ${FILE}
                elif [ -f "$FILE" ];then
                    echo ${FILE}
                fi
            done
        fi
    done
}

#最初のファイルでモードを決定する
detectMode(){
    if [ ! "$opt_f" ];then
        for file in $@
        do
            for sign in `modeSign`
            do
                if [ "`checkFileFormat $file $sign`" ]; then
                    opt_f=$sign
                    return
                fi
            done
        done
        unknownFileFormatError
    else
        checkMode
    fi
}

checkMode(){
    for mode in `modeSign`
    do
        for sign in `argSign $mode`
        do
            if [ "$sign" = "$opt_f" ];then
                opt_f=$mode
                return
            fi
        done
    done

    modeError $opt_f
}

checkMultiInputMode(){
    if [ "$opt_m" ];then
        echo $opt_m
        return
    fi

    if [ "`rowcount $1`" -gt 1 ];then
        echo a
    fi
}

#初期化
opt_l=1
linenum=1

while getopts cef:ghl:mnrsv flag
do
case $flag in
c )  opt_c=1;;
e )  opt_e=1;;
f )  opt_f="$OPTARG";;
g )  opt_g=1;;
h )  usage;;
l )  opt_l="$OPTARG";;
m )  opt_m=1;;
n )  opt_n=1;;
r )  opt_r=1;;
s )  opt_s=1;;
v )  version;;
* ) OPT_ERROR=1; break;;
esac
done

if [ $OPT_ERROR ]; then      # option error
    usage
fi

shift $(( $OPTIND - 1 ))

if [ $# -ge 1 ]; then
    files=`parseFiles $@`
    detectMode $files
    printLabel $files

    for file in $files
    do
        printBench $file
    done
else
    usage
fi

if [ "$opt_s" ];then
    cat $tmpfile
    rm $tmpfile
fi

exit 0;









