FROM armhf/ubuntu:xenial

# required packages
RUN apt-get update && apt-get install vlc-nox -y && rm -rf /var/lib/apt/lists/*

# Define the media volume
VOLUME /media

# Add scripts
COPY ./playlist_gen /usr/sbin/
COPY ./start.sh /usr/sbin/

# vlc limitations
RUN adduser --disabled-password --gecos "" vlc-pal

# Config vlc
RUN mkdir /vlc
ADD ./vlm.conf /vlc/vlm.conf
RUN chown vlc-pal:vlc-pal /vlc -R

# Expose the required ports:
EXPOSE 5000

USER vlc-pal
CMD start.sh
