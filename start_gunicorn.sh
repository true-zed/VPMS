#!/bin/bash
source /path/to/VPMS/venv/bin/activate
exec gunicorn  -c "/path/to/VPMS/gunicorn_config.py" VPMS.wsgi
