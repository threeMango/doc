#!/bin/bash

let num=0
let range=0

while read line
do
    num=$(( $num + 1 ))

    if [ $num -gt 6 ]
    then
        range=$(( $range + 1))
    
        # 英文
        if [ $range == 1 ]
        then
            echo $line >> en.md
        fi

        # 中文
        if [ $range == 2 ]
        then
            echo $line >> ch.md
        fi

        # 空行
        if [ $range == 3 ]
        then 
           let range=0
        fi
    fi

done < $1