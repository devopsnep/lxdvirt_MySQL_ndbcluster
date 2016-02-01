#!/bin/bash
cnt=$1
for i in `cat $cnt`;
do 
printf $i" ";
lxc exec $i -- ip ad | grep inet | grep -v "inet6" | grep -v host | awk '{print $2;}'
done
