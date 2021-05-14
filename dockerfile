FROM boomicicd/jenkins:latest

USER root
#install xmllit and jq (Json query) lib
RUN apt-get install -y jq
RUN apt-get install libxml2-utils

