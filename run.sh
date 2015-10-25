#!/bin/bash

cd /home/ckan
Xvfb :99 -screen 0 1024x768x16 &> xvfb.log &
echo "started server"
DISPLAY=:99.0 mono ckan.exe
sleep 3
#./arma3server details
sleep 300
# infinite loop to keep it open for Docker
while true; do echo run; sleep 300; done
