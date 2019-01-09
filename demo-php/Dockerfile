FROM centos:latest
LABEL maintainer="Vicente Zepeda <chente.z.m@gmail.com>"

ENV nginxversion="1.12.2-1" \
    os="centos" \
    osversion="7" \
    elversion="7_4"

RUN yum install -y wget openssl sed &&\
    yum -y autoremove &&\
    yum clean all &&\
    wget http://nginx.org/packages/$os/$osversion/x86_64/RPMS/nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    rpm -iv nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    sed -i '1i\
    daemon off;\
    ' /etc/nginx/nginx.conf

RUN curl 'https://setup.ius.io/' -o setup-ius.sh && \
	bash setup-ius.sh && \
    yum install -y php70u-cli \
        php70u-fpm \
        php70u-mysqlnd \
        php70u-xml \
        php70u-gd \
        php70u-mcrypt \
		php70u-xmlrpc \
		php70u-json \
        php70u-mbstring \
        php70u-pdo \
		php70u-common \
		php70u-cli \
		php70u-devel

# Configure and secure PHP
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini && \
    sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php.ini && \
    sed -i '/^listen = /clisten = 0.0.0.0:${port}' /etc/php-fpm.d/www.conf && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php-fpm.d/www.conf && \
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php-fpm.d/www.conf && \
    sed -i "s/php_admin_flag\[log_errors\] = .*/;php_admin_flag[log_errors] =/" /etc/php-fpm.d/www.conf && \
    sed -i "s/php_admin_value\[error_log\] =.*/;php_admin_value[error_log] =/" /etc/php-fpm.d/www.conf && \
    sed -i "s/php_admin_value\[error_log\] =.*/;php_admin_value[error_log] =/" /etc/php-fpm.d/www.conf && \
    echo "php_admin_value[display_errors] = 'stderr'" >> /etc/php-fpm.d/www.conf

RUN yum -y install python-setuptools && \
	easy_install supervisor && \
	echo_supervisord_conf > /etc/supervisord.conf && \
	mkdir -p /var/log/supervisor && \
	mkdir -p /var/log/supervisor && \
	sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisord.conf && \
	mkdir /etc/supervisord.d && \
	echo [include] >> /etc/supervisord.conf && \
	echo 'files = /etc/supervisord.d/*.ini' >> /etc/supervisord.conf

EXPOSE 80

ADD run-server.sh /run-server.sh
RUN chmod -v +x /run-server.sh

CMD ["/run-server.sh"]