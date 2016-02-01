#!/bin/bash
cnt=$1

for i in `cat $cnt`;
do 
printf $i" ";
lxc exec $i -- 
done
