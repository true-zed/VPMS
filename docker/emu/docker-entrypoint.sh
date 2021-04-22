#!/bin/sh

set -e

rm -f /opt/android-sdk-linux/.android/avd/bot.avd/*.lock

while [[ "access" =~ $(ls -ltrh /dev/video*) ]]
do
echo "Waiting to start v4l2loopback"
sleep 3
done

emulator -avd bot -no-window -no-audio -no-boot-anim -camera-back webcam0 &

adb wait-for-device shell 'while [[ -z $(getprop dev.bootcomplete) ]]; do sleep 1; done;'

echo "Emulator booted!"

sleep 60
if ! adb shell pm list packages | grep com.whatsapp.w4b; then
adb install /opt/android-sdk-linux/apks/wab.apk
fi

while [[ "granted=true" =~ $(adb shell dumpsys package com.whatsapp.w4b | grep "CAMERA: granted=true") ]]
do
echo "Granting permission to WhatsApp"
adb shell pm grant com.whatsapp.w4b android.permission.CAMERA
done

echo "WhatsApp Business Installed!"

adb shell am start -n com.whatsapp.w4b/com.whatsapp.Main

echo "WhatsApp Started!"

tail -f /dev/null
