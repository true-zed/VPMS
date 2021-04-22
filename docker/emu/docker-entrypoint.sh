#!/bin/sh

set -e

rm -f /opt/android-sdk-linux/.android/avd/bot.avd/*.lock

emulator -avd bot -no-window -no-audio -no-boot-anim -camera-back webcam0 &

adb wait-for-device shell 'while [[ -z $(getprop dev.bootcomplete) ]]; do sleep 1; done;'

echo "Emulator booted!"

sleep 60
if ! adb shell pm list packages | grep com.whatsapp.w4b; then
adb install /opt/android-sdk-linux/apks/wab.apk
adb shell pm grant com.whatsapp.w4b android.permission.CAMERA
fi

echo "WhatsApp Business Installed!"

tail -f /dev/null
