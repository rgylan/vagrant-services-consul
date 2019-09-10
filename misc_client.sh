#!/bin/bash

# Build services
echo "[TASK 1] Build services"
cd /home/vagrant/services
CMDS="cd '{}' && chmod 755 gradlew && ./gradlew clean build"
#find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \; >/dev/null 2>&1
find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \;

# Run services
#echo "[TASK 2] Run services"
#JAVA_OPTS="-Xms300m -Xmx300m -XX:+UseG1GC"
#CMDS="cd '{}/build/libs' && chmod 755 *.jar && java $JAVA_OPTS -jar *.jar &"

#find . -mindepth 1 -maxdepth 1 -type d -execdir bash -c "$CMDS" \; >/dev/null 2>&1