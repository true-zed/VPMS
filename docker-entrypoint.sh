#!/bin/sh

echo "Starting VPMS..."

modprobe v4l2loopback

ffmpeg -loop 1 -i ./SoftwareController/QrCodes/qrcode.png -vf scale=800:600 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 /dev/video0 > /dev/null 2>&1 < /dev/null &

exec gunicorn VPMS.wsgi:application -b 0.0.0.0:8000 --timeout 90
