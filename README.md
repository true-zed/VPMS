# VPMS
Django based AVD management software.  
Created for [Virtual Office.](https://virtualoff.ru)

<p align="center">
    :warning: **Demo version. Poor functionality.** :warning:  
    :warning: **Not bad instructions** :warning:
</p>  

# Instructions
## 1. Basic setup

Download repo to your computer (Linux only):  
```bash

    git clone https://github.com/true-zed/VPMS.git
```

Install some libs:  
```bash

    sudo apt-get update
    sudo apt-get install docker-io ffmpeg v4l2loopback-dkms htop
```

## 2. Setup AVD

[Here you can find docker hub for android-28 (AVD setup as container)](https://hub.docker.com/r/androidsdk/android-28)  

Starting virtual camera:  
```bash
    sudo modprobe v4l2loopback
```  

_______
> Now you need image for start ffmpeg.  
> 
> (ffmpeg is tool for translate our image to /dev/video0, virtual cam)  
> 
> AVD need available webcam before starting for correct work camera in feature.
_______  

Starting ffmpeg:  
```bash
    sudo ffmpeg -loop 1 -i /path/to/your/image.png -vf scale=800:600 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 /dev/video0 > /dev/null 2>&1 < /dev/null & 
```

<details>
  <summary>What is > /dev/null 2>&1 < /dev/null & </summary>
    
    This thing uses to translate output to /dev/null.      
    Cuz we don't wont stop our console and now output will be ignored.
</details>

Download and run image:  
```bash
    docker run -it --name bot --privileged androidsdk/android-28:latest bash
```  

<details>
  <summary>Tips</summary>
    
        docker ps // Display a list of running machines.  
        docker ps -a // Display a list of ALL machines. 
        docker exec -it your_container_name_or_id bash // Connect to running machine.  
        docker start/restart/stop your_container_name_or_id // I think there is no need to explain :)
        Ctrl + D // Exit from container.
</details>

Connect to container and download htop:  
```bash
    apt-get update
    apt-get install htop
```

Create avd (in container):  
```bash
    avdmanager create avd -n bot --abi google_apis/x86_64 -k "system-images;android-28;google_apis;x86_64"
```  

Run emulator (in container):  

```bash
    emulator @bot -no-window -no-audio -camera-back webcam0 &
```  

> Tip: ```command & + Enter```  
> This "&" sign helps to ignore the output.  

Chech adb after booting (60-120 secs):
```bash
    adb devices
    __________________________
    List of devices attached
    emulator-5554   device
```

Then exit from container and repeat last step.  
If you see device in list go next.  
Elif you don't, then launch htop and find processes `qemu-system-x86_64-headless`  
If no processes in htop, restart container, then try to repeat steps starting from "Run emulator".  
> Tip: Press `F4` then type `qemu-system` and press `Enter`  
> Processes will be filtered by this text.  

## 2.1 Setup WhatsApp Business

## 3. Setup ENV & Project settings
## 4. Setup Gunicorn & Supervisor
## 5. Setup autorun

> P.S. If you need help you can text [here](http://google.com) or [here](https://t.me/true_zed)
