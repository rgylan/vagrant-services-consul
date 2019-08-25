# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # services Server
  config.vm.define "services" do |services|
    services.vm.box = "centos/7"
    services.vm.hostname = "services.example.com"
    services.vm.network "private_network", ip: "172.42.42.101"
    services.vm.provider "virtualbox" do |v|
      v.name = "services"
      v.memory = 3000
      v.cpus = 2
    end
    #services.vm.provision "shell", path: "bootstrap_services.sh"
  end
end