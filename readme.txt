add-apt-repository ppa:ubuntu-lxc/lxd-stable
apt-get update
apt-get dist-upgrade
apt-get install lxd

# Logout and login from shell
# Add public LXD server at https://images.linuxcontainers.org:8443
# That server is an image-only read-only server,
# So all you can do with it is list images, copy images from it or start containers from it.

	lxc remote add images images.linuxcontainers.org

# What the above does is define a new “remote” called “images” which points to images.linuxcontainers.org.

# List images on added remote LXD server.

    lxc image list images:

# Start a local container called “ubuntu-32″ from the ubuntu/trusty/i386 image

    lxc launch images:ubuntu/trusty/i386 ubuntu-32

# Run command in container from host

    lxc exec el2 -- ping google.com
    lxc exec el2 -- apt-get update
    
# location of lxc containers
    ls /var/lib/lxd/containers/
       db2-datanode  db2-sqlnode  lxc-monitord.log  mgmt1
# install numactl and libaio on centos containers

    yum install libaio numactl -y
    yum install perl-Class-MethodMaker    #needed for running perl scripts provided by mysqlcluster
    apt-get install libclass-methodmaker-perl  # on ubuntu

# first run generatevm-name.sh  script to get containers list 

# Backing up mysql cluster
    
    Data and meta data which is held by data nodes of a live NDB cluster can be saved using the native backup functionality of NDB. This is a strict and simple method, that can be initiated from any member of the cluster with the management client.
/usr/bin/ndb_mgm -e "START BACKUP <id>"

where ‘id’ is an integer that identifies the snapshot to be created – it has to be specified on non-interactive runs with the -e parameter.

When this command is issued, every ndbd daemon on the data nodes creates a snapshot of its locally stored database segment. The snapshot is stored in the local file system, under the backup directory path configured on the management node (the default path is /usr/local/mysql/data/BACKUP). For every snapshot a directory is created to contain its binary dump files with the name ‘BACKUP-‘.

A cron job can be defined on e.g. the management node based on the above command to generate regular snapshots.
    
    01 00 * * * root /bin/bash -c "/usr/bin/ndb_mgm -e \"START BACKUP `date +\%s`\""
    OR
    01 01 * * * root /bin/bash -c "/usr/bin/ndb_mgm -e \"START BACKUP `date +\%F`\""


    


# References
https://www.stgraber.org/2016/03/19/lxd-2-0-your-first-lxd-container-312/
https://github.com/lxc/lxd/blob/master/specs/command-line-user-experience.md
https://roots.io/linux-containers-lxd-as-an-alternative-to-virtualbox-for-wordpress-development/

http://www.tokiwinter.com/mysql-cluster-adding-new-data-nodes-online/
https://www.esecuredata.com/install-mysql-cluster-7-3-on-centos-6/
http://letstuxtogether.blogspot.com/2015/03/mysql-cluster-setup-on-centos-6x.html
http://skillachie.com/2014/06/30/mysql-cluster-getting-started-redhatcentos-6/#Management_Nodes_ndb_mgmd

https://dev.mysql.com/doc/refman/5.5/en/mysql-cluster-config-starting.html
http://johanandersson.blogspot.com/2012/12/recommended-mysql-cluster-setup.html
https://www.percona.com/blog/2015/01/02/the-mysql-query-cache-how-it-works-and-workload-impacts-both-good-and-bad/


# Start management node

ndb_mgmd --config-file /root/config.ini  --config-dir /usr/mysql-cluster --initial

# To cluster mysql user login information and privileges:-(On Centos 6.7)
login to the SQL Node , also makesure the other sql nodes are also up

Go to myql command line> and enter below commands
    
    source /usr/share/mysql/ndb_dist_priv.sql;
    call mysql.mysql_cluster_move_privileges();

    flush privileges;  #on all SQL Nodes

Check connections in Management NODE:-

    netstat -ntp | awk '{ print $5; }' | cut -d':' -f1 | sed '/^[a-zA-Z]/d' | sort | uniq
    
    ndb_mgmd --help    # view config dir here
    # shutdown and restart mysql cluster and reload config.ini
    ndb_mgm -e "shutdown"
    ndb_mgmd --config-file /root/config.ini  --config-dir /usr/mysql-cluster --initial

    # on Data NODEs run "ndbd"
    [root@el2 ~]# ndbd
    2016-02-01 05:18:41 [ndbd] INFO     -- Angel connected to '192.168.230.133:1186'
    2016-02-01 05:18:41 [ndbd] INFO     -- Angel allocated nodeid: 2
    
   # On Sql NODE restart mysql
    mysqladmin shutdown
    service mysql start OR  mysqld_safe &

    ndb_config -q MaxNoOfAttributes

#http://johanandersson.blogspot.com/2008/04/great-configini.html

    

# Backup and restore of mysqlcluster :-
1.1 Backup
Goto-> Management Node :- 
    ndb_mgm -e "start backup `date +%s`"

Backup files will be stored in "Data Nodes" on same location ..like here /var/lib/mycluster-data/BACKUP/BACKUP-<TimeStamp>
For example on Node1 - /var/lib/mycluster-data/BACKUP/BACKUP-1455097196 directory.

ls  /var/lib/mycluster-data/BACKUP/BACKUP-1455097196/
  BACKUP-1455097196-0.2.Data  
  BACKUP-1455097196.2.ctl  
  BACKUP-1455097196.2.log
    BACKUP-1455097196-0.2.Data = table records, which are saved on a per-fragment basis 
    BACKUP-1455097196.2.ctl  = control information and metadata file. This file is different on different nodes
    BACKUP-1455097196.2.log = records of committed transactions. Only transactions on tables stored in the backup are stored in the log. Nodes involved in the backup save different records because different nodes host different database fragments. 

Restoring the backup
====================
Shutdown cluster with 

ndb_mgm -e "shutdown"

Now stop the SQL nodes-
<On SQL node>
    #service mysql stop   OR
    #mysqladmin shutdown
    check if any mysql services are still running
    
<On management node>
Start management node
     #ndb_mgmd --config-file /root/config.ini  --config-dir /usr/mysql-cluster --initial
     #ndb_mgm -e "<sqlnode id>  stop"
     eg. ndb_mgm -e "4 stop"
         ndb_mgm -e "5 stop"
         
<On Datanode>
Start with --initial option like below
    #ndbd --initial
    
ndb_restore -m -b 101 -n 2 -r /var/lib/mycluster-data/BACKUP/BACKUP-101/
     -b = backup number
     -n = node number/id
     -m = Restore metadata to NDB Cluster using the NDB API
     -r = Restore table data and logs into NDB Cluster using the NDB API


##### Basic sql to find  database and table size ####
Find all table sizes:-
======================
SELECT TABLE_NAME AS "Table",round(((data_length + index_length) / 1024 / 1024), 2) AS Size_in_MB FROM information_schema.TABLES  WHERE table_schema = 'ctdb' ORDER BY Size_in_MB DESC;

Find database size example ctdb:-
================================
SELECT table_schema  "ctdb", Round(Sum(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM   information_schema.tables 
GROUP  BY table_schema; 
