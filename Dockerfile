FROM ubuntu:bionic
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

# you must edit this to match your own user
ENV HOSTUID=1000 \
 VNC_PASS=pass1234 \
 LANG=en_US.UTF-8

# RUN apt-get -y install python-software-properties curl build-essential libxml2-dev libxslt-dev git ruby ruby-dev ca-certificates sudo net-tools vim wget
# RUN echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen
# RUN echo 'en_US ISO-8859-1'>>/etc/locale.gen
# This block became necessary with the new chef 12
RUN apt-get -y update \
  && apt-get -y dist-upgrade \
  && apt-get -y install locales \
  libcurl4-openssl-dev \
  xvfb \
  mono-complete \
  wget \
  x11vnc \
  net-tools \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/* \
  && echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen \
  && locale-gen \
  && useradd --uid $HOSTUID -m -s /bin/bash ckan \
  && usermod -a -G video,audio,tty ckan

RUN apt-get -y update \
  && apt-get -y install \
       gdebi-core \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

RUN wget -c --quiet \
https://github.com/KSP-CKAN/CKAN/releases/download/v1.25.3/ckan_1.25.3_all.deb \
&& gdebi ckan_1.25.3_all.deb \
&& rm ckan_1.25.3_all.deb

USER ckan
WORKDIR /home/ckan

RUN mozroots --import --sync
RUN wget -c --quiet \
https://github.com/KSP-CKAN/CKAN/releases/download/v1.25.3/ckan.exe
RUN chmod 755 ckan.exe

# VNC
RUN mkdir ~/.vnc
#RUN x11vnc -storepasswd 1234 ~/.vnc/passwd

# ADD values.xml /home/ckan/.mono/registry/CurrentUser/software/ckan/values.xml
ADD run.sh /home/ckan/run.sh

EXPOSE 5900 6099

CMD ["/bin/bash", "/home/ckan/run.sh"]
