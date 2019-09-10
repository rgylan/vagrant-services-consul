# -*- mode: ruby -*-
# vi: set ft=ruby :

$server_script = <<SCRIPT
echo "Running server consul..."
sudo consul agent -server -bootstrap-expect=2 -data-dir=/tmp/consul -node=agent-server2 -bind=172.42.42.102 -enable-script-checks=true -config-dir=/etc/consul.d/ >> /var/log/consul/output.log &
SCRIPT

$client_script = <<SCRIPT
echo "Running client consul..."
sudo consul agent -ui -data-dir=/tmp/consul -node=agent-client1 -bind=172.42.42.103 -client=172.42.42.103 -enable-script-checks=true -config-dir=/etc/consul.d/ >> /var/log/consul/output.log &
SCRIPT

$client_script2 = <<SCRIPT
echo "Running client2 consul..."
sudo consul agent -ui -data-dir=/tmp/consul -node=agent-client2 -bind=172.42.42.104 -client=172.42.42.104 -enable-script-checks=true -config-dir=/etc/consul.d/ >> /var/log/consul/output.log &
SCRIPT

# Specify a Consul version
CONSUL_DEMO_VERSION = ENV['CONSUL_DEMO_VERSION']

# Specify a custom Vagrant box for the demo
DEMO_BOX_NAME = ENV['DEMO_BOX_NAME'] || "debian/stretch64"

# Vagrantfile API/syntax version.
# NB: Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = DEMO_BOX_NAME
  config.vm.provision "shell", path: "bootstrap.sh", env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}

  config.vm.define "client2" do |client2|
    client2.vm.hostname = "client-node2"
    client2.vm.network "private_network", ip: "172.42.42.104"
    client2.vm.provision "shell", path: "bootstrap_client.sh", env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
    client2.vm.provider "virtualbox" do |v|
      v.name = "consulclient2"
      v.memory = 2000
      v.cpus = 2
    end
    client2.vm.provision "shell", inline: $client_script2, env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
  end

  config.vm.define "client" do |client|
    client.vm.hostname = "client-node"
    client.vm.network "private_network", ip: "172.42.42.103"
    client.vm.provision "shell", path: "bootstrap_client.sh", env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
    client.vm.provider "virtualbox" do |v|
      v.name = "consulclient"
      v.memory = 2000
      v.cpus = 2
    end
    client.vm.provision "shell", inline: $client_script, env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
  end

  config.vm.define "server2" do |server2|
    server2.vm.hostname = "server-node2"
    server2.vm.network "private_network", ip: "172.42.42.102"
    server2.vm.provision "shell", inline: $server_script, env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
    server2.vm.provider "virtualbox" do |v|
      v.name = "consulserver2"
      v.memory = 1000
      v.cpus = 1
    end
  end

  config.vm.define "server" do |server|
    server.vm.hostname = "server-node"
    server.vm.network "private_network", ip: "172.42.42.101"
    server.vm.provision "shell", path: "bootstrap_server.sh", env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
    server.vm.provider "virtualbox" do |v|
      v.name = "consulserver"
      v.memory = 1000
      v.cpus = 1
    end
  end

  #client.vm.provision "shell", inline: $client_script, env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}

end