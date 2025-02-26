FROM python:alpine

WORKDIR /app

COPY app /app

RUN pip install flask gunicorn
RUN apk update && apk add supervisor

COPY config/supervisord.conf /etc/supervisord.conf

EXPOSE 3000

CMD ["supervisord", "-c", "/etc/supervisord.conf"]