#!/bin/bash

echo "Connecting to adb .."
adb devices

echo "Opening the WhatsApp Business .."
adb shell am start -n com.whatsapp.w4b/com.whatsapp.Main

echo "Waiting for WhatsApp Business to load .."
sleep 10

echo "Removing ROM warning .."
adb shell input tap 160 410

sleep 2

echo "AGREE AND CONTINUE .."
adb shell input tap 160 525

sleep 2

echo "Choosing country .."
echo "Tapping to country list for choosing .."
adb shell input tap 160 190

sleep 2

echo "Tapping to loupe icon .."
adb shell input tap 295 50

sleep 2

echo "Entering text to search for a country .."
adb shell input text "Russia"

sleep 2

echo "Tapping to Russia .."
adb shell input tap 160 120

sleep 2

echo -e "Enter mobile number for login, without country code. \nExample: 9996669966"
read tel

echo "Entering mobile number .."
adb shell input text $tel

sleep 2

echo "Tapping on the \"Next\" button  .."
adb shell input tap 160 390

echo "Waiting 20 seconds for loading .."
sleep 20

echo "Tapping the \"OK\" button to confirm the number .."
adb shell input tap 260 408

echo "Waiting for the code .."
echo -e "Enter the code: \n(Enter 0 if you need a call back)"

read code
if [ $code == "0" ]
	then echo "Waiting for 70 seconds .."
	sleep 70
	echo "Tapping the \"Call me\" button .."
	adb shell input tap 80 280
	echo -e "Waiting for the code .. \nEnter:"
	read code
fi

echo "Entering the code .."
adb shell input text $code

echo "Waiting for 30 seconds .."
sleep 30

echo "Clearing a network error message .."
adb shell input tap 260 365

sleep 5

echo "Tapping the \"NOT NOW\" button to cancel synchronization  .."
adb shell input tap 200 460

echo "Waiting for 20 seconds .."
sleep 20

echo "Tapping to \"NEXT\" button to skip entering the name"
adb shell input tap 160 370

echo "Waiting for 20 seconds .."
sleep 20

echo "Tapping to \"NOT NOW\" button for skip the \"Explore business tools\""
adb shell input tap 160 605

echo "Waiting for 20 seconds .."
sleep 20

echo "Tapping to skip updating .."
adb shell input tap 175 385

echo "Waiting for 5 seconds .."
sleep 5

echo "Login completed!"
