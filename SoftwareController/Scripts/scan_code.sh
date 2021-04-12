#!/bin/bash

echo "Connecting to adb .."
adb devices

echo "Opening the WhatsApp Business .."
adb shell am start -n com.whatsapp.w4b/com.whatsapp.Main

echo "Waiting for WhatsApp Business to load .."
sleep 3

echo "Opening the menu .."
adb shell input tap 300 30

echo "Waiting for the menu to open .."
sleep 2

echo "Opening the \"WhatsApp Web\" tab .."
adb shell input tap 160 245

echo "Waiting for the tab to open .."
sleep 2

echo "Adding a new web session .."
adb shell input tap 160 310

echo "Waiting for a web session to be added .."
sleep 1

echo "Tapping the \"OK\" button in the instructions .."
adb shell input tap 160 535

echo "Waiting for a code scan .."
sleep 10

echo "Scanning completed!"

echo "Closing WhatsApp Business .."
adb shell am force-stop com.whatsapp.w4b
