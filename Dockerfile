# pull official base image
FROM python:3.8

# set work directory
WORKDIR /usr/src/app

# set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements ./requirements
RUN pip install -r ./requirements/common.txt

# install ffmpeg
RUN apt-get install ffmpeg

# copy docker-entrypoint.sh
COPY ./docker-entrypoint.sh ./docker-entrypoint.sh

# copy project
COPY . .

# give permissions
RUN chmod -x docker-entrypoint.sh

# run docker-entrypoint.sh
ENTRYPOINT ["bash", "docker-entrypoint.sh"]
