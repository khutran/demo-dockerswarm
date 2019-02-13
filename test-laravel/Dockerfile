FROM khutran/laravel:php7.2

LABEL maintainer="khutran"
ARG URL 
ARG MYSQL_USER 
ARG MYSQL_PASSWORD 
ARG MYSQL_DATABASE 
ARG MYSQL_MASTER_HOST 

RUN apk add --no-cache git

RUN git clone ${URL} /var/www/workspace/

WORKDIR /var/www/workspace

RUN composer install

RUN chown -R nginx:nginx .
EXPOSE 443 80

CMD ["/start.sh"]