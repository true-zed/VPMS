# pull official base image
FROM ubuntu:latest

# set work directory
WORKDIR /usr/src/app

# set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV TZ=Europe/Moscow

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Updating
RUN apt-get update && apt-get -y upgrade && apt-get dist-upgrade

RUN apt-get install -y python3 python3-pip

# install dependencies
COPY . .
RUN pip3 install -r ./requirements/prod.txt

# install ffmpeg
RUN apt-get install -y ffmpeg adb modules-extra-$(uname -r) dkms v4l2loopback-dkms psmisc 

# give permissions
RUN chmod -x docker-entrypoint.sh

# run docker-entrypoint.sh
ENTRYPOINT ["bash", "docker-entrypoint.sh"]

