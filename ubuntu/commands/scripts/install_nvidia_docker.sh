#!/bin/bash
sudo apt-get install -y python3-pip
  git clone https://github.com/CarmeLabs/carme
  cd carme
  pip3 install -r requirements.txt
  pip3 install -e .
sudo apt-get install -y python-pip
pip install --upgrade pip
pip install -r requirements.txt
pip install -e .

echo "Checking for CUDA and installing."
# Check for CUDA and try to install.
if ! dpkg-query -W cuda-8-0; then
  #download CUDA and some Docker Prerequisites.
  curl -O https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
  dpkg -i ./cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
  sudo apt-get update
  sudo apt-get install cuda-8-0
fi
echo "Checking for Docker-CE and Installing."
if ! dpkg-query -W docker-ce; then
  #download docker
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  #install prerequisites
  sudo apt-get install apt-transport-https ca-certificates curl software-properties-common python3-pip -y
  sudo apt-get install docker-ce -y
  curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi
echo "Checking for NVIDIA Docker and installing."
if ! dpkg-query -W nvidia-docker2; then
  # Add the package repositories
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
    sudo apt-key add -
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt-get update

  # Install nvidia-docker2 and reload the Docker daemon configuration
  sudo apt-get install -y nvidia-docker2
  sudo pkill -SIGHUP dockerd
fi
# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
