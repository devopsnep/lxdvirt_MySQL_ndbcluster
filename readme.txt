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

# install numactl and libaio on centos containers

    yum install libaio numactl -y

# first run generatevm-name.sh  script to get containers list 


# References
https://github.com/lxc/lxd/blob/master/specs/command-line-user-experience.md
https://roots.io/linux-containers-lxd-as-an-alternative-to-virtualbox-for-wordpress-development/

http://www.tokiwinter.com/mysql-cluster-adding-new-data-nodes-online/
https://www.esecuredata.com/install-mysql-cluster-7-3-on-centos-6/
http://letstuxtogether.blogspot.com/2015/03/mysql-cluster-setup-on-centos-6x.html
http://skillachie.com/2014/06/30/mysql-cluster-getting-started-redhatcentos-6/#Management_Nodes_ndb_mgmd

https://dev.mysql.com/doc/refman/5.5/en/mysql-cluster-config-starting.html
http://johanandersson.blogspot.com/2012/12/recommended-mysql-cluster-setup.html

# To cluster mysql user login information and privileges:-(On Centos 6.7)
login to the SQL Node , also makesure the other sql nodes are also up

Go to myql command line> and enter below commands
    
    source /usr/share/mysql/ndb_dist_priv.sql;
    call mysql.mysql_cluster_move_privileges();

    flush privileges;  #on all SQL Nodes

Check connections in Management NODE:-

    netstat -ntp | awk '{ print $5; }' | cut -d':' -f1 | sed '/^[a-zA-Z]/d' | sort | uniq
    
    
