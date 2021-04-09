#!/bin/bash
source /home/bot/VPMSdev/VPMS/venv/bin/activate
exec gunicorn  -c "/home/bot/VPMSdev/VPMS/gunicorn_config.py" VPMS.wsgi
