# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    #
    # Development machine with Eclipse etc
    #
    config.vm.define "dev" do |dev|
        dev.vm.box = "ubuntu/trusty64"
        dev.vm.network "private_network", ip: "192.168.59.104"
        dev.vm.provider "virtualbox" do |vb|
            vb.gui = true
            vb.cpus = 4
            vb.memory = 4096
        end
        dev.vm.provision "file", source: "dev-provisioning", destination: "/tmp/dev-provisioning"
        dev.vm.provision "shell", inline: "/bin/sh /tmp/dev-provisioning/provision.sh"
        dev.vm.synced_folder "shared_folder", "/home/vagrant/share_folder"
    end

end
