#!/bin/bash

echo "Connecting to adb .."
adb devices

echo "Starting WhatsApp Business"
adb shell "su 0 am start com.whatsapp.w4b/com.whatsapp.Main"

sleep 4

echo "Starting Activity .."
adb shell "su 0 am start com.whatsapp.w4b/com.whatsapp.qrcode.DevicePairQrScannerActivity"

# If instructions
adb shell input tap 160 535

echo "Waiting for a code scan .."
sleep 10

echo "Scanning completed!"
