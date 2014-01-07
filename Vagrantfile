# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_NAME = ENV['BOX_NAME'] || "phusion-docker-vagrant"
BOX_URI = ENV['BOX_URI'] || "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"
VF_BOX_URI = ENV['BOX_URI'] || "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vmwarefusion.box"

SSH_PRIVKEY_PATH = ENV["SSH_PRIVKEY_PATH"]

$script = <<SCRIPT
# The username to add to the docker group will be passed as the first argument
# to the script.  If nothing is passed, default to "vagrant".
user="$1"
if [ -z "$user" ]; then
    user=vagrant
fi

# Adding an apt gpg key is idempotent.
wget -q -O - https://get.docker.io/gpg | apt-key add -

# Creating the docker.list file is idempotent, but it may overrite desired
# settings if it already exists.  This could be solved with md5sum but it
# doesn't seem worth it.
echo 'deb http://get.docker.io/ubuntu docker main' > \
    /etc/apt/sources.list.d/docker.list

# Update remote package metadata.  'apt-get update' is idempotent.
apt-get update -q

# Install docker.  'apt-get install' is idempotent.
apt-get install -q -y lxc-docker-0.7.3

usermod -a -G docker "$user"

cat > /home/vagrant/vagrant-run.sh <<VAGRANT_RUN
#!/bin/bash

set -e

mkdir -p /home/vagrant/pass_other_mountpoint
touch /home/vagrant/pass_other_mountpoint/testfile

mkdir -p /home/vagrant/fail_other_mountpoint
touch /home/vagrant/fail_other_mountpoint/testfile

mkdir -p /home/vagrant/fail_subdir
touch /home/vagrant/fail_subdir/testfile

cd /vagrant
./build.sh
./vagrant-run.sh
VAGRANT_RUN

chmod +x /home/vagrant/vagrant-run.sh
chown vagrant:vagrant /home/vagrant/vagrant-run.sh

SCRIPT


Vagrant.configure("2") do |config|

  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URI
  config.vm.network "private_network", ip: "192.168.51.49"

  if SSH_PRIVKEY_PATH
      config.ssh.private_key_path = SSH_PRIVKEY_PATH
  end

  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb, override|
    override.vm.provision :shell, :inline => $script
    config.vm.synced_folder ".", "/vagrant", :type => "nfs"
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
end
