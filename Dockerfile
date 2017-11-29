FROM armhf/ubuntu:xenial

# required packages
RUN apt-get update && apt-get install vlc-nox git build-essential uuid-dev psmisc -y

# Define the media volume
VOLUME /media

# setup XUPNPD
# build
RUN cd / && git clone https://github.com/anabolyc/xupnpd.git
RUN cd /xupnpd/src && make
RUN mkdir /xupnpd/src/playlists -p

# cleanup
RUN apt-get remove git build-essential uuid-dev psmisc -y && apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

# setup VLC
# Add scripts
COPY ./playlist_gen /usr/sbin/

# vlc limitations
RUN adduser --disabled-password --gecos "" vlc-pal

# Config vlc
RUN mkdir /vlc
ADD ./vlm.conf /vlc/vlm.conf
RUN chown vlc-pal:vlc-pal /vlc -R
RUN chown vlc-pal:vlc-pal /xupnpd -R

ENV FRONTEND_NAME TV3x3
ENV FRONTEND_PORT 4044
ENV VLC_IP localhost
ENV BACKEND_GUID 68e01182-8f81-439c-b36c-3482b6a6eac7

# access stream and upnp control panel
EXPOSE 5000 4044

COPY ./start.sh /usr/sbin/

USER vlc-pal
CMD start.sh
