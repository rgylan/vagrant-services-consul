#!/bin/bash

# Boot consul cluster
echo "[TASK 1] Boot consul cluster ..."
sudo chmod 755 /vagrant/boot-consul-cluster.sh
sudo /vagrant/boot-consul-cluster.sh

# Build services
#echo "[TASK 2] Build services"
#cd /home/vagrant/services
#CMDS="cd '{}' && chmod 755 gradlew && ./gradlew clean build"
#find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \; >/dev/null 2>&1

# Run services
#echo "[TASK 3] Run services"
#JAVA_OPTS="-Xms300m -Xmx300m -XX:+UseG1GC"
#CMDS="cd '{}/build/libs' && chmod 755 *.jar && java $JAVA_OPTS -jar *.jar &"

#find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \; >/dev/null 2>&1