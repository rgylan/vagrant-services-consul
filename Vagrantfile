# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # consulsvc Server
  config.vm.define "consulsvc" do |consulsvc|
    consulsvc.vm.box = "centos/7"
    consulsvc.vm.hostname = "consulsvc.example.com"
    consulsvc.vm.network "private_network", ip: "172.42.42.103"
    consulsvc.vm.provider "virtualbox" do |v|
      v.name = "consulsvc"
      v.memory = 2048
      v.cpus = 2
    end
    #consulsvc.vm.provision "shell", path: "bootstrap_consulsvc.sh"
  end
end