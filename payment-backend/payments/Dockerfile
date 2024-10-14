FROM python:3.11.3

ENV PYTHONUNBUFFERED 1

RUN mkdir /payments

WORKDIR /payments

COPY . /payments/

RUN pip install -r requirements.txt
#RUN apt-get update && \
#    apt-get install -y docker-compose
# RUN docker-compose run payments python manage.py migrate
# RUN docker-compose run payments python manage.py loaddata datadump.json
# RUN docker-compose run payments python manage.py createsuperuser --no-input
# RUN python manage.py createsuperuser --no-input
# RUN docker exec -it payments-web-1 python manage.py migrate
#kubectl exec -n egs-petcare -it payments-85775f64b9-4fnht -c app -- python manage.py createsuperuser --no-input
#kubectl get pods egs-petcare -o jsonpath='{.spec.containers[*].name}'
# Define the command to run your Django server
EXPOSE 8081
CMD ["python", "manage.py", "runserver", "0.0.0.0:8081"]