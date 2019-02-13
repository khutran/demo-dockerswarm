FROM khutran/laravel:php7.2

LABEL maintainer="khutran"

RUN apk add --no-cache git

RUN git clone https://khutx:UGJ4nzhpdNQasDtPLsHU@bitbucket.org/vicoderscom/vinaco_laravel_api.git /var/www/workspace/

WORKDIR /var/www/workspace

RUN composer install

RUN chown -R nginx:nginx .
EXPOSE 443 80

CMD ["/start.sh"]