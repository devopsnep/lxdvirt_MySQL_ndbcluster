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
