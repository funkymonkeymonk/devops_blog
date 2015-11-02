# based on https://github.com/p0bailey/docker-flask
FROM p0bailey/docker-flask

MAINTAINER Blink Health <shared.services@blinkhealth.com>

RUN rm -rf /var/www/app/* /etc/nginx/sites-available/
COPY . /var/www/app/
COPY flask.conf /etc/nginx/sites-available/

WORKDIR /var/www/app/

RUN python --version && \
    pip install -r requirements.txt

EXPOSE 80
