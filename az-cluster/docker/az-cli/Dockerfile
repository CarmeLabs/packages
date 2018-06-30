FROM microsoft/dotnet:latest
MAINTAINER CarmeLabs
FROM microsoft/dotnet:latest
MAINTAINER 'CarmeLabs'
RUN apt-get -y update \
&& apt-get -y install rsync
RUN mkdir /tmp/azcopy \
&& cd /tmp/azcopy \
&& wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64 \
&& tar -xf azcopy.tar.gz \
&& /tmp/azcopy/install.sh
RUN rm -rf /tmp/azcopy
