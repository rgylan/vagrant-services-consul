#!/bin/bash

# Running client consul...
#echo "[TASK 1] Running client consul..."
#sudo consul agent -ui -data-dir=/tmp/consul -node=agent-client1 -bind=172.42.42.102 -client=172.42.42.102 -enable-script-checks=true -config-dir=/etc/consul.d/ >> /var/log/consul/output.log &

# Install OpenJDK 8
echo "[TASK 1] Install OpenJDK 8"
sudo apt-get install -y -q openjdk-8-jdk >/dev/null 2>&1

# Set Java ENV Variables
echo "[TASK 2] Set Java ENV Variables"
cat >>/etc/profile.d/java8.sh<<EOF
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=\$PATH:\$JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
EOF
source /etc/profile.d/java8.sh

# Install Git
echo "[TASK 3] Install Git"
sudo apt-get install -y -q git >/dev/null 2>&1

# Git clone services
echo "[TASK 4] Git clone services"
cd /home/vagrant
mkdir services
cd services
git clone https://github.com/rgylan/atm-customer-cnsl-service.git
git clone https://github.com/rgylan/atm-account-cnsl-service.git
git clone https://github.com/rgylan/atm-transaction-cnsl-service.git
git clone https://github.com/rgylan/atm-zuul-cnsl-service.git

# Build services
echo "[TASK 5] Build services"
cd /home/vagrant/services
CMDS="cd '{}' && chmod 755 gradlew && ./gradlew clean build"
find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \; >/dev/null 2>&1
