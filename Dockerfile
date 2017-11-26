FROM node:8.9-stretch

MAINTAINER Florian Fröhlich

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV TZ Europe/Berlin
ENV HOMEBRIDGE_TZ Europe/Berlin

# Install dependencies and tools
RUN apt-get update; \
    apt-get install -y apt-utils apt-transport-https; \
    apt-get install -y curl wget; \
    apt-get install -y libnss-mdns avahi-discover libavahi-compat-libdnssd-dev libkrb5-dev; \
    apt-get install -y ffmpeg; \
    apt-get install -y nano vim htop avahi-daemon avahi-discover libnss-mdns libavahi-compat-libdnssd-dev curl wget git python build-essential make g++ libkrb5-dev vim net-tools nano; \
    apt-get install -y parallel

USER root
# Install latest Homebridge
# -------------------------------------------------------------------------
# You can force a specific version by setting HOMEBRIDGE_VERSION
# See https://github.com/marcoraddatz/homebridge-docker#homebridge_version
# RUN npm install -g homebridge --unsafe-perm
RUN npm install -g https://github.com/lumoc/homebridge-alexa --unsafe-perm


#RUN npm install -g homebridge-platform-lightify
RUN npm install -g https://github.com/Lumoc/homebridge-hue.git
RUN npm install -g homebridge-sonoff-tasmota-http
#RUN npm install -g homebridge-platform-wemo
#RUN npm install -g homebridge-alexa --unsafe-perm

# Final settings
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf

USER root
RUN mkdir -p /var/run/dbus

ADD image/run.sh /root/run.sh

# Run container
EXPOSE 5353 51826 51827 1900
CMD ["/root/run.sh"]
