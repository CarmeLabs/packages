FROM amd64/ubuntu:16.04

MAINTAINER CarmeLabs

RUN apt -y update && \
    apt -y upgrade && \
    apt-get -y update && \
    apt-get -y upgrade && \

    ## Dependecies for Azure' .NET Core 
    apt-get -y install liblttng-ust0 \
                       libcurl3 \
                       libssl1.0.0 \
                       libkrb5-3 \
                       zlib1g \
                       libicu55 \
                       libunwind8 \
                       libuuid1

COPY bin/azcopy-install.sh   /opt
COPY bin/azure-fileshare.sh  /bin

RUN /opt/azcopy-install.sh