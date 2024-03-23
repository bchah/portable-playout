FROM ubuntu:22.04
RUN apt-get update && apt-get install -yq ffmpeg python3 python3-pip
RUN apt-get install -yq wget
RUN mkdir /data
RUN wget https://github.com/ffplayout/ffplayout/releases/download/v0.20.5/ffplayout_0.20.5-1_amd64.deb -O /data/ffplayout_arm.deb
RUN wget https://github.com/ffplayout/ffplayout/releases/download/v0.20.5/ffplayout_0.20.5-1_arm64.deb -O /data/ffplayout_x64.deb
RUN pip3 install watchdog
COPY ./data/ /data
CMD ["/data/start.sh"]
