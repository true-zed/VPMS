#!/bin/bash

echo Connecting to adb
adb devices

# If System UI isn't responding
# adb shell input tap 160 335

echo Opening WhatsApp Business App
adb shell am start -n com.whatsapp.w4b/com.whatsapp.Main

# If Warning about memory difference
adb shell input tap 160 410
# Tap to "AGREE AND CONTINUE" at start screen
adb shell input tap 160 525

echo Choosing country
# Tap to "United States" for edit country
adb shell input tap 160 190
# Tap to loupe icon
adb shell input tap 295 50
# Input text for search
adb shell input text "Russia"
# Tap to Russia
adb shell input tap 160 120

# Asking for mobile number
echo "Enter mobile number for login, without country code. \n Example: 9996669966"
read tel

echo Entering mobile number
# Input text for mobile number
adb shell input text $tel
# Tap to "NEXT"
adb shell input tap 160 390
# Waiting for loading
sleep 10
# Tap to "OK" for verifing number
adb shell input tap 260 408

echo Waiting for code. Enter 0 if callback needed:
# Waiting to enter code
read code
if [ $code == "0" ]
	then echo Waiting a minute..
	sleep 70
	adb shell input tap 80 322
	echo Waiting for code. Enter:
	read code
fi

echo Entering code
# Input code for auth
adb shell input text $code

# Skip Network error
sleep 5
adb shell input tap 260 365

echo Setting up..
# Tap to "NOT NOW" to no sync
adb shell input tap 200 460
# Sleeping
sleep 10
# Tap to next to enter name
adb shell input tap 160 370
# Sleeping 
sleep 10
# Tap to "NOT NOW" for "Explore business tools"
adb shell input tap 160 605
# Sleeping
sleep 10
# Tap to canceling update
adb shell input tap 175 385
echo Done!
adb shell am force-stop com.whatsapp.w4b
