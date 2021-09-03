# -*- mode: ruby -*-
# vi: set ft=ruby :
 
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
        # h.customize ['modifyvm', :id, '--nic1', 'natnetwork', '--nat-network1', 'NAT-VB']
        # h.customize ['modifyvm', :id, '--nic1', 'bridged']
    end
    # node.vm.network "private_network", ip: "10.0.2.15", type: "natnetwork"
    node.vm.network "private_network", ip: "10.0.0.10"
    node.vm.hostname = "master"
    # node.vm.provision :shell, :inline => "sudo swapoff -a", run: "always"
    # node.ssh.host "10.0.2.15"
    node.vm.network "forwarded_port", guest: 22, host: 2730
    # node.ssh.guest_port = 2730
    # node.ssh.host = '192.168.1.12'
    node.vm.synced_folder ".", "/vagrant", disabled: true
    node.vm.provision "file", source: "./master.sh", destination: "~/"
    node.vm.provision "Running-Kubeadm", type: "shell", :path => "./master.sh", run: "always"
    # node.vm.provision :reload
#     node.vm.provision :shell, :inline => "sudo swapoff -a", run: "always"
#     node.vm.provision "shell", inline: "echo 'sudo kubectl apply -n kube-system -f /home/vagrant/net.yaml' | at now", privileged: false
#     $script = <<-SCRIPT
# cat >> /home/vagrant/.bashrc <<EOF
# if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
#   source /usr/share/powerline/bindings/bash/powerline.sh
# fi
# EOF
# SCRIPT
#     node.vm.provision "shell", inline: $script
#     node.vm.provision "shell", inline: "echo 'source /usr/share/powerline/bindings/tmux/powerline.conf' > /home/vagrant/.tmux.conf"
    node.trigger.after :provision do |trigger|
          trigger.run = {inline: "scp -i .vagrant/machines/master/virtualbox/private_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@10.0.0.10:/home/vagrant/joincluster.sh ./"}
    end
  end

NUM_WORKER_NODE=2

  (1..NUM_WORKER_NODE).each do |i|
      config.vm.define "worker#{i}" do |node|
        node.vm.provider "virtualbox" do |h|
            h.memory = 2048
            h.cpus = 2
        # h.vm_integration_services = {
        #   guest_service_interface: true
        # }
            h.name = "worker#{i}"
            # h.customize ['modifyvm', :id, '--nic1', 'natnetwork', '--nat-network1', 'NAT-VB']
            # h.customize ['modifyvm', :id, '--nic1', 'bridged']
        end
        # node.vm.network "private_network", ip: "10.0.2.16"
        node.vm.network "private_network", ip: "10.0.0.1#{i}"
        node.vm.hostname = "worker#{i}"
        # node.vm.network "forwarded_port", guest: 22, host: 2222, disabled: true
        node.vm.network "forwarded_port", guest: 22, host: "273#{i}"
        node.ssh.guest_port = "273#{i}"
        node.vm.synced_folder ".", "/vagrant", disabled: true
        node.vm.provision "file", source: "./worker.sh", destination: "~/"
        node.vm.provision "Running-Kubeadm", type: "shell", :path => "./worker.sh"
        # node.vm.provision "file", source: "./joincluster.sh", destination: "~/"
        node.vm.provision "Joining to cluster", type: "shell", :path => "joincluster.sh"
      end
    end
  end
