#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.101 consul.server1.com consulsvr1
172.42.42.102 consul.server2.com consulsvr2
172.42.42.103 client1.example.com client1
172.42.42.104 client2.example.com client2
EOF

# Installing dependencies ...
echo "[TASK 2] Installing dependencies ..."
sudo apt-get update
sudo apt-get install -y unzip curl jq dnsutils

# Determining Consul version to install ...
echo "[TASK 3] Determining Consul version to install ..."
CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"
if [ -z "$CONSUL_DEMO_VERSION" ]; then
    CONSUL_DEMO_VERSION=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
fi

# Fetching Consul version
echo "[TASK 4] Fetching Consul version ${CONSUL_DEMO_VERSION} ..."
cd /tmp/
curl -s https://releases.hashicorp.com/consul/${CONSUL_DEMO_VERSION}/consul_${CONSUL_DEMO_VERSION}_linux_amd64.zip -o consul.zip

# Installing Consul version
echo "[TASK 5] Installing Consul version ${CONSUL_DEMO_VERSION} ..."
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d
sudo mkdir /var/log/consul
sudo chmod 755 /var/log/consul

# Install OpenJDK 8
#echo "[TASK 6] Install OpenJDK 8"
#sudo apt-get install -y -q openjdk-8-jdk >/dev/null 2>&1

# Set Java ENV Variables
#echo "[TASK 7] Set Java ENV Variables"
#cat >>/etc/profile.d/java8.sh<<EOF
#export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
#export PATH=\$PATH:\$JAVA_HOME/bin
#export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
#EOF
#source /etc/profile.d/java8.sh

# Install Git
#echo "[TASK 8] Install Git"
#sudo apt-get install -y -q git >/dev/null 2>&1

# Git clone services
#echo "[TASK 9] Git clone services"
#cd /home/vagrant
#mkdir services
#cd services
#git clone https://github.com/rgylan/atm-customer-cnsl-service.git
#git clone https://github.com/rgylan/atm-account-cnsl-service.git
#git clone https://github.com/rgylan/atm-transaction-cnsl-service.git
#git clone https://github.com/rgylan/atm-zuul-cnsl-service.git