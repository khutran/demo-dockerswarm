FROM khutran/angular:nginx-1.14.2
RUN mkdir -p /var/www/worksapce
WORKDIR /var/www/workspace
COPY ./workspace/* .
EXPOSE 80 443
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]

