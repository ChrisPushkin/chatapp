#!/bin/sh
#not using nginx, so not removing the static files.
#rm -rf web/static 
#. venv/bin/activate
while ! nc -z -v -w 3 db 3306; do sleep 5; done
flask db init
exec gunicorn -b :5000 --access-logfile - --error-logfile - chat:app
