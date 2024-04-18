@echo off

rem Wait for the database to be ready
echo Waiting for database connection...
:loop
timeout /t 5 /nobreak >nul
echo Testing database connection...
echo exit | telnet db 5432 | find "Connected" >nul || goto loop

rem Apply database migrations
python manage.py migrate

python manage.py loaddata datadump.json

rem Create a superuser
python manage.py createsuperuser --no-input

rem Start the Django development server
python manage.py runserver 0.0.0.0:8080