#!/bin/bash

echo Creating VirtualWebCam
sudo modprobe v4l2loopback 
sleep 2
sudo ffmpeg -loop 1 -i /path/to/VPMS/SoftwareController/QrCodes/qrcode.png -vf scale=800:600 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 /dev/video0 > /dev/null 2>&1 < /dev/null &
sleep 2
echo Starting docker container "bot"
sudo docker start bot
sleep 2
echo Starting AVD
sudo docker exec -dt bot emulator @bot -no-window -no-audio -camera-back webcam0

echo Waiting 3 mins
sleep 180
echo Removing UI warning
adb devices
sleep 5
adb shell input tap 160 335
sudo killall ffmpeg
