#!/bin/bash
echo "Checking for Docker-CE and Installing."
if ! dpkg-query -W docker-ce; then
  #download docker
  sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   sudo apt-get update
   sudo apt-get -y install docker-ce
   sudo groupadd docker
   sudo usermod -aG docker $USER
   #download compose
   sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   sudo reboot
fi
