#!/bin/bash

cnt=$1
for i in `cat $cnt`;
do 
lxc exec $i -- rpm -Uvh /MySQL-Cluster-server-gpl-7.4.9-1.el6.x86_64.rpm;
lxc exec $i -- rpm -Uvh /MySQL-Cluster-shared-gpl-7.4.9-1.el6.x86_64.rpm;
done
