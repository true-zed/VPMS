# VPMS
![https://img.shields.io/badge/Status-Demo-red](https://img.shields.io/badge/Status-Demo-red)
![https://img.shields.io/badge/Python-3.8.5-green](https://img.shields.io/badge/Python-3.8.5-green)
![https://img.shields.io/badge/Django-3.1.7-green](https://img.shields.io/badge/Django-3.1.7-green)
![https://img.shields.io/badge/WA_Business-2.21.2.18-green](https://img.shields.io/badge/WA_Business-2.21.2.18-green)  
Django based AVD management software.  
Created for [Virtual Office.](https://virtualoff.ru)
> P.S. If you need help you can write [here](http://google.com) or [here](https://t.me/true_zed)  

# <p align="center"> **Instructions** </p>  

## 1. Initial preparations

Install some libs:  
```bash

    sudo apt-get update
    sudo apt-get install git nginx docker-io ffmpeg v4l2loopback-dkms supervisor htop
```  

Configure git:
```bash

    git config --global user.name "Your Name"
    git config --global user.email yourname@example.com
    git config --global core.autocrlf input
```  

Download repo to your computer:  
```bash

    cd /path/to/your/workdir/  
    git clone https://github.com/true-zed/VPMS.git  
```  

Activate project bash-scripts:  
```bash

    cd /path/to/VPMS/  
    chmod +x autorun.sh start_gunicorn.sh
    cd SoftwareController/Scripts/
    chmod +x login.sh logout.sh scan_code.sh
```

## 2. Setup AVD

[v4l2loopback rep](https://github.com/umlaeute/v4l2loopback/)  
[Issue about v4l2 right start](https://github.com/umlaeute/v4l2loopback/issues/151)  
[Docker image of android-28 (AVD setup as container)](https://hub.docker.com/r/androidsdk/android-28)  

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

<p align="center"> YOU NEED CREATE VIRTUAL CAMERA AND RUN FFMPEG BEFORE STARTING AVD </p>

Starting ffmpeg:  
```bash
    sudo ffmpeg -loop 1 -i /path/to/your/image.png -vf scale=800:600 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 /dev/video0 > /dev/null 2>&1 < /dev/null & 
```

<details>
    <summary>Tip</summary>
    
    What is "> /dev/null 2>&1 < /dev/null &" ?
    This thing uses to translate output to /dev/null.      
    Cuz we don't wont stop our console and now output will be ignored (Use Enter for it).
</details>

Download and run image:  
```bash
    docker run -it --name bot --privileged androidsdk/android-28:latest bash // Download and run image.  
    Ctrl + D // To quit.  
    docker start bot // To start, cuz stoped after quited.  
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

    docker exec -it bot bash // Connecting to container
    apt-get update
    apt-get install htop
```

Create AVD (in container):  
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
If you see device in list go next step.  
Elif you don't, then launch htop and find processes `qemu-system-x86_64-headless`  
If no processes in htop, restart container, then try to repeat steps starting from "Run emulator".  

<details>
  <summary>Tips</summary>
    
   Press `F4` then type `qemu-system` and press `Enter`  
   Processes will be filtered by this text.  
   
   ```bash
  
       adb emu kill // Stop AVD  
       adb exec-out screencap -p > /path/to/screen.png // Screen from AVD.  
       scp root@xxx.xxx.xxx.xxx:/path/to/screen.png C:\path\to\save\screen.png // Download screen by ssh from main PC (Windows).  
       adb shell input tap x y // Send tap to AVD. 
       adb shell input text "some text" //  Send text to AVD. Uses when text input focused.  
   ```
</details>


## 2.1 Setup WhatsApp Business  

Download WhatsApp Business (x86) to your main PC:  
[WhatsApp Business V2.21.2.18](https://m.apkpure.com/ru/whatsapp-business/com.whatsapp.w4b/variant/2.21.2.18-APK)  

Then push it (apk) to your VM uses scp:  
```bash

    scp C:\path\to\downloaded\WhatsApp Business_v2.21.2.18_apkpure.com.apk root@xxx.xxx.xxx.xxx:/path/to/save/wab.apk 
```  

Install apk to AVD:
```bash

    adb install /path/to/wab.apk  
```

## 3. Setup ENV & Project settings  

Creating venv:
```bash

    cd /path/to/your/workdir/VPMS/
    python -m venv /venv/
```

Install dependences:
```bash

    pip install -r requirements/prod.txt
```

Edit config for gunicorn:
```bash

    vi gunicorn_config.py  
    __________________________________________________________________________________________________________  
    command = '/path/to/VPMS/venv/bin/gunicorn' // Path to gunicorn in your venv.  
    pythonpath = '/path/to/VPMS' // Path to VPMS workdir.  
    bind = '127.0.0.1:8001' // Bind IP to gunicorn.  
    workers = 5 // Move to cpu_num * 2 + 1  
    timeout = 120 // Seconds until worker stops.  
    user = 'root' // Your username.  
    limit_request_fields = 32000  
    limit_request_field_size = 0  
    // This is where you add your variable to export it to the environment.  
    raw_env = [
            'DJANGO_SETTINGS_MODULE=VPMS.settings.prod', // Var for choose settings file.  
            'SECRET_KEY=SECRET', // Var for setup secret key ^^  
            'AUTH_TOKEN=TOKEN', // Var for setup token. Used to authorize a request.  
            'HOST=*' // Change * to your server IP.
        ]
```

<details>
    <summary>Tips</summary>  

    Press I to edit.  
    Press :wq to save and quit.  
    Press :q! to quit without saving.  
</details>


## 4. Setup Nginx & Gunicorn & Supervisor  

Rewriting nginx config:  
```bash

    cd /etc/nginx/sites-enabled/  
    vi default  
    // Clear all and insert that thing in file.  
    
    ___________________________________________________________________________
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                proxy_pass http://127.0.0.1:8001;
                proxy_set_header X-Forwarded-Host $server_name;
                proxy_set_header X-Real-IP $remote_addr;
                add_header P3P 'CP="ALL DSP COR PSAa OUR NOR ONL UNI COM NAV"';
                add_header Access-Control-Allow-Origin *;
        }

    }
```  

Customize gunicorn start script:  
```bash

    cd /path/to/VPMS/  
    vi start_gunicorn.sh  
    
    ______________________________________________________________  
    #!/bin/bash  
    source /path/to/VPMS/venv/bin/activate  
    exec gunicorn  -c "/path/to/VPMS/gunicorn_config.py" VPMS.wsgi  // Customize your path here.  
```  

Setup supervisor config:  

```bash

    cd /etc/supervisor/conf.d/  
    vi supervisor.VPMS.conf   
    // Insert this code in vim and save.  
    
    ____________________
    [program:vpms_gunicorn]  
    command=/path/to/VPMS/start_gunicorn.sh  
    user=your_user  
    process_name=%(program_name)s  
    numprocs=1  
    autostart=true  
    autorestart=true  
    redirect_stderr=true  
```  

You can now restart the supervisor and the server will work:  

```bash

    service supervisor restart
    service nginx restart
```

## 5. Setup autorun  

Customize autorun file:  

```bash

    cd /path/to/VPMS/  
    vi autorun.sh  
    
    _____________________________  
    echo Creating VirtualWebCam
    sudo modprobe v4l2loopback
    sleep 2
    // Customize path here.
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
```

Create cron-task:  

```bash

    sudo crontab -u root -e  
    // Add to the end  
    @reboot sudo -S /path/to/VPMS/autorun.sh  
```
