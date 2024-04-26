#!/bin/sh

# Wait for the database to be ready
until nc -z -v -w30 db 5432
do
  echo "Waiting for database connection..."
  # Wait for 5 seconds before trying again
  sleep 5
done

# Apply database migrations
python manage.py migrate

python manage.py loaddata datadump.json

# Create a superuser
python manage.py createsuperuser --no-input

# Start the Django development server
python manage.py runserver 0.0.0.0:8080