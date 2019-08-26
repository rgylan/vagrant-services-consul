#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.101 cnslservices.example.com docker
EOF

# Install OpenJDK 11
echo "[TASK 2] Install OpenJDK 11"
yum install -y -q java-11-openjdk-devel >/dev/null 2>&1

# Set Java ENV Variables
echo "[TASK 3] Set Java ENV Variables"
cat >>/etc/profile.d/java11.sh<<EOF
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=\$PATH:\$JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
EOF
source /etc/profile.d/java11.sh

# Install Git
echo "[TASK 4] Install Git"
yum install -y -q git >/dev/null 2>&1

# Git clone services
echo "[TASK 5] Git clone services"
mkdir services
cd services
git clone https://github.com/rgylan/atm-customer-cnsl-service.git

# Build services
echo "[TASK 6] Build services"
CMDS="cd '{}' && chmod 755 gradlew && ./gradlew clean build"
find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \; >/dev/null 2>&1 

# Run services
echo "[TASK 7] Run services"
JAVA_OPTS="-Xms512m -Xmx512m -XX:+UseG1GC"
CMDS="cd '{}/build/libs' && chmod 755 *.jar && java $JAVA_OPTS -jar *.jar &"

find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \; >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc