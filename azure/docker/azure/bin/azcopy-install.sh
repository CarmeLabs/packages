#!/usr/bin/env bash

## Add fucntions to adhere to Mac or Linux environments
## Check installers
apt -y update
apt -y upgrade
apt-get -y update
apt-get -y upgrade
apt-get -y install rsync

## Check if wget is installed
if ! [ -x "$(command -v wget)" ];then
    apt-get install wget
fi

## Check if if tar is installed
if ! [ -x "$(command -v tar)" ];then
    apt-get install tar
fi

## Install AzCopy for MSFT Azure
mkdir /opt/azure
mkdir /opt/azure/azcopy
cd /opt/azure/azcopy
wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64
tar -xf azcopy.tar.gz

## Check if in root
if [[ "$EUID" -eq 0 ]];then
    ./install.sh
else
    sudo ./install.sh
fi

