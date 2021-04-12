#!/bin/bash

echo "Creating a virtual webcam .."
sudo modprobe v4l2loopback

echo "Waiting for v4l2loopback to load .."
sleep 2

echo "Starting ffmpeg stream .."
sudo ffmpeg -loop 1 -i /path/to/VPMS/SoftwareController/QrCodes/qrcode.png -vf scale=800:600 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 /dev/video0 > /dev/null 2>&1 < /dev/null &

echo "Waiting for ffmpeg to load .."
sleep 2

echo "Running a docker container named \"bot\""
sudo docker start bot

echo "Waiting for docker to load .."
sleep 2

echo "Starting AVD"
sudo docker exec -dt bot emulator @bot -no-window -no-audio -camera-back webcam0


echo "Waiting for AVD to load (3 minutes) .."
sleep 180

echo "Connecting to adb .."
adb devices

echo "Removing UI warning .."
adb shell input tap 160 335

echo "Waiting for 30 seconds .."
sleep 30

echo "Kill all ffmpeg processes .."
sudo killall ffmpeg
