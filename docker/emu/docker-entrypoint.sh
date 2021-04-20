#!/bin/sh

set -e

rm -f /opt/android-sdk-linux/.android/avd/bot.avd/*.lock

emulator -avd bot -no-window -no-audio -no-boot-anim -camera-back webcam0 > /dev/null 2>&1 < /dev/null

adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'

if ! adb shell pm list packages | grep com.whatsapp.w4b
then adb install /opt/android-sdk-linux/apks/wab.apk
fi

