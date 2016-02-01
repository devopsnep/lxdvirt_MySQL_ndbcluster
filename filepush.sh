#!/bin/bash
container=$1
#rpm1="resolv.conf"
#target file to copy
rpm1=/ndb/MySQL-Cluster-server-gpl-7.4.9-1.el6.x86_64.rpm
rpm2=/ndb/MySQL-Cluster-shared-gpl-7.4.9-1.el6.x86_64.rpm
for var in `cat $container`;
do
#file is copied to  $container's "/etc/" directory
#lxc file push $rpm1 $var/etc/;
#file is copied to  $container's "/" root directory
lxc file push $rpm1 $var/ ;  
lxc file push $rpm2 $var/ ;
done

