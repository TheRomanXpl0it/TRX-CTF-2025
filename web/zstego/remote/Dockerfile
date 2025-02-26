FROM php:8.4-cli

RUN apt-get update && apt-get install -y \
    unzip \
    libzip-dev \
 && docker-php-ext-install zip \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY chall /var/www/html/
COPY flag.txt /flag.txt

RUN chown -R www-data:www-data /var/www/html /flag.txt \
 && chmod -R 555 /var/www/html \
 && chmod 444 /flag.txt

USER www-data

CMD ["php", "-S", "0.0.0.0:1337", "-t", "/var/www/html"]
