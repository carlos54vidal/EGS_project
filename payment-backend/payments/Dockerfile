FROM python:3.11.3

ENV PYTHONUNBUFFERED 1
RUN mkdir /payments
WORKDIR /payments
COPY . /payments/
RUN pip install -r requirements.txt
EXPOSE 8080