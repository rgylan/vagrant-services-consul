#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.101 services.example.com docker
EOF

# Install docker from Docker-ce repository
echo "[TASK 2] Install docker container engine"
yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
yum install -y -q docker-ce >/dev/null 2>&1

# Enable docker service
echo "[TASK 3] Enable and start docker service"
systemctl enable docker >/dev/null 2>&1
systemctl start docker

# Disable SELinux
echo "[TASK 4] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[TASK 5] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Enable ssh password authentication
echo "[TASK 6] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 7] Set root password"
echo "dadmin" | passwd --stdin root >/dev/null 2>&1

# Expose docker API with TLS
echo "[TASK 8] Expose docker API with TLS"
mkdir /etc/systemd/system/docker.service.d
bash -c 'cat >>/etc/systemd/system/docker.service.d/startup_options.conf<<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376 --tlsverify --tlscacert=/vagrant/tls/ca.pem --tlscert=/vagrant/tls/server-cert.pem --tlskey=/vagrant/tls/server-key.pem
EOF'

# Restart docker
echo "[TASK 9] Restart docker"
systemctl daemon-reload
systemctl restart docker.service

# Install OpenJDK 11
echo "[TASK 10] Install OpenJDK 11"
yum install -y -q java-11-openjdk-devel >/dev/null 2>&1

# Set Java ENV Variables
echo "[TASK 11] Set Java ENV Variables"
cat >>/etc/profile.d/java11.sh<<EOF
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=\$PATH:\$JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
EOF
source /etc/profile.d/java11.sh

# Install Git
echo "[TASK 12] Install Git"
yum install -y -q git >/dev/null 2>&1

# Git clone services
echo "[TASK 13] Git clone services"
mkdir services
cd services
git clone https://github.com/rgylan/atm-eureka-service.git
git clone https://github.com/rgylan/atm-zuul-service.git
git clone https://github.com/rgylan/atm-customer-service.git

# Build services
echo "[TASK 14] Build services"
CMDS="cd '{}' && chmod 755 gradlew && ./gradlew clean build"
find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \; >/dev/null 2>&1 

# Run services
echo "[TASK 15] Run services"
JAVA_OPTS="-Xms512m -Xmx512m -XX:+UseG1GC"
CMDS="cd '{}/build/libs' && chmod 755 *.jar && java -Dprofile=eureka $JAVA_OPTS -jar *.jar &"
# Run eureka first.
cd atm-eureka-service/build/libs
chmod 755 atm-eureka-service-1.0-SNAPSHOT.jar
java $JAVA_OPTS -jar atm-eureka-service-1.0-SNAPSHOT.jar &

cd ../../../
find . -mindepth 1 -maxdepth 1 -type d ! -name "atm-eureka-service" -execdir bash -c "$CMDS" \; >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc