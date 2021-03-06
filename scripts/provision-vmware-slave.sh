#!/bin/bash

# switch Ubuntu download mirror to German server
sudo sed -i 's,http://us.archive.ubuntu.com/ubuntu/,http://ftp.fau.de/ubuntu/,' /etc/apt/sources.list
sudo sed -i 's,http://security.ubuntu.com/ubuntu,http://ftp.fau.de/ubuntu,' /etc/apt/sources.list
sudo apt-get update -qq

# set timezone to German timezone
echo "Europe/Berlin" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

# install git
sudo apt-get install -qq git unzip

# install packer
sudo mkdir /opt/packer
pushd /opt/packer
echo "Downloading packer 0.7.1..."
sudo wget --no-verbose https://dl.bintray.com/mitchellh/packer/0.7.1_linux_amd64.zip
echo "Installing packer 0.7.1..."
sudo unzip 0.7.1_linux_amd64.zip
sudo rm 0.7.1_linux_amd64.zip
pushd /usr/bin
sudo ln -s /opt/packer/* .
popd

echo "Downloading packer-post-processor-vagrant-vmware-ovf 0.2.0 ..."
wget --no-verbose https://github.com/gosddc/packer-post-processor-vagrant-vmware-ovf/releases/download/v0.2.0/packer-post-processor-vagrant-vmware-ovf.linux-amd64.tar.gz
tar xzf packer-post-processor-vagrant-vmware-ovf.linux-amd64.tar.gz
sudo ln -s /opt/packer/packer-post-processor-vagrant-vmware-ovf /usr/bin/packer-post-processor-vagrant-vmware-ovf
rm packer-post-processor-vagrant-vmware-ovf.linux-amd64.tar.gz
popd

echo "Downloading Vagrant 1.6.5 ..."
wget --no-verbose -O /tmp/vagrant.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.deb
echo "Installing Vagrant 1.6.5 ..."
sudo dpkg -i /tmp/vagrant.deb
rm /tmp/vagrant.deb

echo "Installing Stefan's varant-serverspec plugin 0.5.0 ..."
wget --no-verbose --no-check-certificate -O vagrant-serverspec-0.5.0.gem https://github.com/StefanScherer/vagrant-serverspec/releases/download/v0.5.0/vagrant-serverspec-0.5.0.gem
vagrant plugin install vagrant-serverspec-0.5.0.gem

echo "Installing Stefan's vagrant-vcloud plugin 0.4.4 ..."
wget --no-verbose --no-check-certificate -O vagrant-vcloud-0.4.4.gem https://github.com/StefanScherer/vagrant-vcloud/releases/download/v0.4.4/vagrant-vcloud-0.4.4.gem
vagrant plugin install vagrant-vcloud-0.4.4.gem

# workaround in box-cutter/ubuntu1404's minimize.sh removes /usr/src/* but does not remove packages
sudo apt-get remove -qq linux-headers-3.13.0-32-generic
sudo apt-get remove -qq linux-headers-3.13.0-32
# sudo apt-get install -qq linux-headers-3.13.0-32
sudo apt-get install -qq linux-headers-$(uname -r)
sudo apt-get install -qq dkms

echo "Downloading VMware Workstation 10 ..."
wget --no-verbose  -O VMware-Workstation.bundle --no-check-certificate http://www.vmware.com/go/tryworkstation-linux-64
sudo sh ./VMware-Workstation.bundle --console --required --eulas-agreed
rm ./VMware-Workstation.bundle
