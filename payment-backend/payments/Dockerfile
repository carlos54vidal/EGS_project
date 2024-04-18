FROM python:3.11.3

ENV PYTHONUNBUFFERED 1
RUN mkdir /payments
WORKDIR /payments
COPY . /payments/
RUN pip install -r requirements.txt
# RUN docker-compose run web python manage.py migrate
# RUN docker-compose run web python manage.py loaddata datadump.json
# RUN docker-compose run web python manage.py createsuperuser
# RUN docker exec -it web python manage.py migrate
EXPOSE 8080 