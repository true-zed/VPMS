#!/bin/sh

echo "Starting VPMS..."

exec gunicorn VPMS.wsgi:application -b 0.0.0.0:8000
