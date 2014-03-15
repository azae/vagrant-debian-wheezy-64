#!/bin/bash

# passwordless sudo
echo "%sudo   ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# public ssh key for vagrant user
mkdir /home/vagrant/.ssh
wget -O /home/vagrant/.ssh/authorized_keys "https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub"
chmod 755 /home/vagrant/.ssh
chmod 644 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# speed up ssh
echo "UseDNS no" >> /etc/ssh/sshd_config

# display login promt after boot
sed "s/quiet splash//" /etc/default/grub > /tmp/grub
sed "s/GRUB_TIMEOUT=[0-9]/GRUB_TIMEOUT=0/" /tmp/grub > /etc/default/grub
update-grub

# clean up
apt-get clean

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Switching to testing
cat > /etc/apt/source.list <<EOF
deb http://cdn.debian.net/debian testing main non-free contrib
deb-src http://cdn.debian.net/debian testing main non-free contrib
EOF 
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y
