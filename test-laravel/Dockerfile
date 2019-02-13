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

RUN cp .env.example .env \
    sed -i \
    -e "s/127.0.0.1/${MYSQL_MASTER_HOST}/g" \
    -e "s/vicoders_vinaco/${MYSQL_DATABASE}/g" \
    -e "s/homestead/${MYSQL_USER}/g" \
    -e "s/secret/${MYSQL_PASSWORD}/g" \
    .env
EXPOSE 443 80

CMD ["/start.sh"]