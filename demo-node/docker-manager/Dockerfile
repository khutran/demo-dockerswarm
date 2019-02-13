FROM php:7.2.4-fpm-alpine

LABEL maintainer="Ric Harvey <ric@ngd.io>"

# resolves #166
ENV NODE_VERSION 9.11.2
ENV php_vars /usr/local/etc/php/conf.d/docker-vars.ini
ENV fpm_conf /usr/local/etc/php-fpm.d/www.conf
ENV php_conf /usr/local/etc/php-fpm.conf

RUN addgroup -g 1000 node \
  && adduser -u 1000 -G node -s /bin/sh -D node \
  && apk add --no-cache \
  libstdc++ \
  && apk add --no-cache --virtual .build-deps \
  binutils-gold \
  curl \
  g++ \
  gcc \
  gnupg \
  libgcc \
  linux-headers \
  make \
  python \
  # gpg keys listed at https://github.com/nodejs/node#release-keys
  && for key in \
  94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
  FD3A5288F042B6850C66B31F09FE44734EB7990E \
  71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
  DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  B9AE9905FFD7803F25714661B63B535A4C206CA9 \
  77984A986EBC2AA786BC0F66B01FBB92821C587A \
  8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
  4ED778F539E3634C779C87C6D7062848A1AB005C \
  A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
  B9E2F5981AA6E0CD28160D9FF13993A75599653C \
  ; do \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
  gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xf "node-v$NODE_VERSION.tar.xz" \
  && cd "node-v$NODE_VERSION" \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && apk del .build-deps \
  && cd .. \
  && rm -Rf "node-v$NODE_VERSION" \
  && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

RUN apk add --no-cache git

ENV YARN_VERSION 1.12.3

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
  6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
  gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn

RUN echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  echo /etc/apk/respositories && \
  apk update && \
  apk add --no-cache bash \
  openssh-client \
  wget \
  supervisor \
  curl \
  libcurl \
  augeas-dev \
  openssl-dev \
  ca-certificates \
  dialog \
  autoconf \
  make \
  gcc \
  musl-dev \
  linux-headers \
  libmcrypt-dev \
  libpng-dev \
  icu-dev \
  libpq \
  libxslt-dev \
  libffi-dev \
  freetype-dev \
  sqlite-dev \
  libjpeg-turbo-dev && \
  docker-php-ext-configure gd \
  --with-gd \
  --with-freetype-dir=/usr/include/ \
  --with-png-dir=/usr/include/ \
  --with-jpeg-dir=/usr/include/ && \
  #curl iconv session
  #docker-php-ext-install pdo_mysql pdo_sqlite mysqli mcrypt gd exif intl xsl json soap dom zip opcache && \
  docker-php-ext-install iconv pdo_mysql pdo_sqlite mysqli gd exif intl xsl json soap dom zip opcache && \
  #pecl install xdebug && \
  docker-php-source delete && \
  mkdir -p /var/log/supervisor && \
  EXPECTED_COMPOSER_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig) && \
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php -r "if (hash_file('SHA384', 'composer-setup.php') === '${EXPECTED_COMPOSER_SIGNATURE}') { echo 'Composer.phar Installer verified'; } else { echo 'Composer.phar Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
  php composer-setup.php --install-dir=/usr/bin --filename=composer && \
  php -r "unlink('composer-setup.php');"  && \
  apk del gcc musl-dev linux-headers libffi-dev augeas-dev python-dev make autoconf
#    ln -s /usr/bin/php7 /usr/bin/php

ADD conf/supervisord.conf /etc/supervisord.conf


RUN echo "cgi.fix_pathinfo=0" > ${php_vars} &&\
  echo "upload_max_filesize = 100M"  >> ${php_vars} &&\
  echo "post_max_size = 100M"  >> ${php_vars} &&\
  echo "variables_order = \"EGPCS\""  >> ${php_vars} && \
  echo "memory_limit = 128M"  >> ${php_vars} && \
  sed -i \
  -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
  -e "s/pm.max_children = 5/pm.max_children = 4/g" \
  -e "s/pm.start_servers = 2/pm.start_servers = 3/g" \
  -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" \
  -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" \
  -e "s/;pm.max_requests = 500/pm.max_requests = 200/g" \
  -e "s/user = www-data/user = 1000/g" \
  -e "s/group = www-data/group = 1000/g" \
  -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
  -e "s/;listen.owner = www-data/listen.owner = 1000/g" \
  -e "s/;listen.group = www-data/listen.group = 1000/g" \
  -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" \
  -e "s/^;clear_env = no$/clear_env = no/" \
  ${fpm_conf}

# RUN mkdir -p /etc/php7/conf.d/
# RUN ln -s /etc/php7/php.ini /etc/php7/conf.d/php.ini && \
#   find /etc/php7/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;


RUN apk add mariadb-client

# Add Scripts
ADD start.sh /start.sh
RUN chmod 755 /start.sh


CMD ["/start.sh"]
