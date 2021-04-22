FROM androidsdk/android-28

WORKDIR /opt/android-sdk-linux

RUN apt-get update -y

RUN echo "no" | avdmanager create avd -n bot --abi google_apis/x86_64 -k "system-images;android-28;google_apis;x86_64" \
    && echo 'hw.keyboard=yes' >> /opt/android-sdk-linux/.android/avd/bot.avd/config.ini

COPY . .

RUN chmod +x /opt/android-sdk-linux/docker-entrypoint.sh

CMD /opt/android-sdk-linux/docker-entrypoint.sh
