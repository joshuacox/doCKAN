FROM debian:jessie
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

RUN apt-get -y update
# RUN apt-get -y install python-software-properties curl build-essential libxml2-dev libxslt-dev git ruby ruby-dev ca-certificates sudo net-tools vim wget
RUN apt-get -y dist-upgrade

# This block became necessary with the new chef 12
RUN apt-get -y install locales
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install xvfb
RUN apt-get -y install mono-complete
RUN apt-get -y install wget
RUN apt-get -y install x11vnc
RUN apt-get -y install net-tools
# RUN echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen
# RUN echo 'en_US ISO-8859-1'>>/etc/locale.gen
RUN echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8

RUN useradd -m -s /bin/bash ckan
RUN usermod -a -G video,audio,tty ckan
USER ckan
WORKDIR /home/ckan

RUN mozroots --import --sync
RUN wget -c https://github.com/KSP-CKAN/CKAN/releases/download/v1.14.3/ckan.exe
RUN chmod 755 ckan.exe

# VNC
RUN     mkdir ~/.vnc
RUN     x11vnc -storepasswd 1234 ~/.vnc/passwd

ADD run.sh /home/ckan/run.sh

EXPOSE 5900 6099

CMD ["/bin/bash", "/home/ckan/run.sh"]
