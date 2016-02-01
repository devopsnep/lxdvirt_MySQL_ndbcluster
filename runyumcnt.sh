#!/bin/bash
cnt=$1
for i in `cat $cnt`;
do 
lxc exec $i -- yum install libaio numactl -y;
done
