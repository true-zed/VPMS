# VPMS
Django based AVD management software.  
Created for [Virtual Office.](https://virtualoff.ru)

# <p align="center">:warning: **Demo version. Poor functionality. Not bad instructions** :warning:</p>  
______________
# Instructions
## 1. Basic setup

Download repo to your computer (Linux only):  
```git clone https://github.com/true-zed/VPMS.git```

Install some libs:  
```sudo apt-get install docker-io ffmpeg v4l2loopback-dkms```

## 2. Setup AVD

[Here you can find docker hub for android-28 (AVD setup as container)](https://hub.docker.com/r/androidsdk/android-28)  

Starting virtual camera:  
```sudo modprobe v4l2loopback```  
_______
> Now you need image for start ffmpeg.  
> 
> (ffmpeg is tool for translate our image to /dev/video0, virtual cam)  
> 
> AVD need available webcam before starting for correct work camera in feature
_______
Starting ffmpeg:  
```sudo ffmpeg -loop 1 -i /path/to/your/image.png -vf scale=800:600 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 /dev/video0 > /dev/null 2>&1 < /dev/null & ```

<details>
  <summary>What is > /dev/null 2>&1 < /dev/null & </summary>
    
    This thing uses to translate output to /dev/null.  
    
    Cuz we don't wont stop our console
</details>

Download and run image:  
```docker run -it --name bot --privileged androidsdk/android-28:latest bash```  

<details>
  <summary>Commands for docker</summary>
  
    ```docker ps``` - View running containers  

    ```docker ps -a``` - View all containers  

    ```docker exec -it "container name" bash``` - Enter to container  
</details>  

Create avd (in container):  
```avdmanager create avd -n bot --abi google_apis/x86_64 -k "system-images;android-28;google_apis;x86_64"```  

Run emulator (in container):  

```emulator @bot -no-window -no-audio -camera-back webcam0 &```  
> Tip: ```command &```  
> that "&" makes it possible to ignore the output. You can type next command and last output (not stopped) will be ignored

## 2.1 Setup WhatsApp Business

## 3. Setup ENV & Project settings
## 4. Setup Gunicorn & Supervisor
## 5. Setup autorun

> P.S. If you need help you can text [here](http://goog.le) or [here](https://t.me/true_zed)
