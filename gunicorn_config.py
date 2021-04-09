command = '/home/bot/VPMSdev/VPMS/venv/bin/gunicorn'
pythonpath = '/home/bot/VPMSdev/VPMS'
bind = '127.0.0.1:8001'
workers = 5
timeout = 120
user = 'root'
limit_request_fields = 32000
limit_request_field_size = 0
raw_env = ['DJANGO_SETTINGS_MODULE=VPMS.settings.prod', 'SECRET_KEY=SECRET', 'AUTH_TOKEN=TOKEN', 'HOST=*']
