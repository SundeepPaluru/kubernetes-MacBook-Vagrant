# -*- mode: ruby -*-
# vi: set ft=ruby :

##-----------Author--------------
#       Name: Sundeep Paluru
##-------------------------------

#Vagrant.require_plugin "vagrant-reload"
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  ############### ---------------------------------------------------- #############################

  config.vm.box = "ubuntu/focal64"
  config.vm.box_check_update = false
  # Provision core-linux Node
  config.vm.define "master" do |node|
    node.vm.provider "virtualbox" do |h|
        h.memory = 4096
        h.cpus = 3
		    h.name = "master"
        h.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    end

    node.vm.network "private_network", ip: "10.0.0.10"
    node.vm.hostname = "master"

    node.vm.network "forwarded_port", guest: 22, host: 2730
    node.vm.synced_folder ".", "/vagrant", disabled: true
    node.vm.provision "file", source: "./master.sh", destination: "~/"
    node.vm.provision "Running-Kubeadm", type: "shell", :path => "./master.sh", run: "always"
    node.trigger.after :up do |trigger|
          trigger.run = {inline: "scp -i ./.vagrant/machines/master/virtualbox/private_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@10.0.0.10:/home/vagrant/joincluster.sh ./"
          }
    end
  end

NUM_WORKER_NODE=2

  (1..NUM_WORKER_NODE).each do |i|
      config.vm.define "worker#{i}" do |node|
        node.vm.provider "virtualbox" do |h|
            h.memory = 4096
            h.cpus = 3
            h.name = "worker#{i}"
            h.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
        end

        node.vm.network "private_network", ip: "10.0.0.1#{i}"
        node.vm.hostname = "worker#{i}"

        node.vm.network "forwarded_port", guest: 22, host: "273#{i}"
        node.ssh.guest_port = "273#{i}"
        node.vm.synced_folder ".", "/vagrant", disabled: true
        node.vm.provision "file", source: "./worker.sh", destination: "~/"
        node.vm.provision "Running-Kubeadm", type: "shell", :path => "./worker.sh"

        node.vm.provision "Joining to cluster", type: "shell", :path => "joincluster.sh"
      end
    end
  end
