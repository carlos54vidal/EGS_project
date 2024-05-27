FROM python:3.11.3

ENV PYTHONUNBUFFERED 1
RUN mkdir /authentication
WORKDIR /authentication
COPY . /authentication/
RUN pip install -r requirements.txt
#RUN apt-get update && \
#    apt-get install -y docker-compose
# RUN docker-compose run authentication python manage.py migrate
# RUN docker-compose run authentication python manage.py loaddata datadump.json
# RUN docker-compose run authentication python manage.py createsuperuser --no-input
# RUN python manage.py createsuperuser --no-input
# RUN docker exec -it authentication-web-1 python manage.py migrate
# Define the command to run your Django server
EXPOSE 8080
CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]