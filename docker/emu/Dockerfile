FROM androidsdk/android-28

WORKDIR /opt/android-sdk-linux

RUN apt-get update -y

RUN echo "no" | avdmanager create avd -n bot --abi google_apis/x86_64 -k "system-images;android-28;google_apis;x86_64"

COPY . .

RUN chmod -x docker-entrypoint.sh

ENTRYPOINT ["bash", "docker-entrypoint.sh"]
