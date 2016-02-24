#!/bin/bash
export PROVISION_DIR=/tmp/dev-provisioning

#
# System wide adjustments
#
echo "Setting up /swapfile"
dd if=/dev/zero of=/swapfile bs=1M count=1024
mkswap /swapfile
swapon /swapfile

#
# Setup
#
#
echo "Updating package list"
sudo aptitude update
sudo aptitude install -y unzip lubuntu-core file-roller xfce4-terminal chromium-browser python-lxml apt-transport-https ca-certificates

## Install JDK 8
echo "Installing JDK8"
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer

## Install docker
echo "Installing docker"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee --append /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get -y install linux-image-extra-$(uname -r) apparmor linux-image-generic-lts-trusty docker-engine
echo 'DOCKER_OPTS="--selinux-enabled -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"' | sudo tee --append /etc/default/docker
sudo service docker restart
sudo gpasswd -a vagrant docker && newgrp docker
#sudo docker daemon -H localhost:2375 &

## Install dev tools (eclipse, sublime, maven)
echo "Installing dev tools"
$PROVISION_DIR/install-extras.sh

## ENV
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /home/vagrant/.bashrc
echo "export DOCKER_HOST=tcp://localhost:2375" >> /home/vagrant/.bashrc

# set timezone, locale too (for keyboard)?
echo "Setting Swedish locale and timezone"
echo "If you want something else, run 'sudo dpkg-reconfigure tzdata'"
echo "Europe/Stockholm" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
echo "Setting keyboard layout to swedish"
setxkbmap se

# can't rsync files, as the virtualbox share from windows 
# has mode 777 on all files, owned by vagrant:vagrant
echo "Setting up Xfce terminal"
cp -r $PROVISION_DIR/files/home/vagrant/.config /home/vagrant/
echo "Setting autologin to vagrant user (password is vagrant, should you need it)"
mkdir -p /etc/lightdm/lightdm.conf.d
cp $PROVISION_DIR/files/etc/lightdm/lightdm.conf.d/* /etc/lightdm/lightdm.conf.d/
chown vagrant:vagrant -R /home/vagrant

echo "Starting graphical login"
# somehow, autologin isn't kicking in first time
service lightdm start
#sleep 10
service lightdm restart