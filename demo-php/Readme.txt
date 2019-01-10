1 : build image php7.2-laravel

docker image build --tag php7.2-laravel docker-php7.2-laravel

2 : push registry

docker image tag php7.2-laravel localhost:5000/php7.2-laravel
docker push localhost:5000/php7.2-laravel

3 : create image of project

docker image build --tag demo-php .

4: push registry

docker image tag php7.2-laravel localhost:5000/demo-php
docker push localhost:5000/demo-php


5 : create container from localhost:5000/demo-php

docker service create --name demo-php --network traefik_web-net --replicas=1 --constraint 'node.role == worker' --label traefik.enable=true --label traefik.port=80 --label traefik.backend="demo-php" --label traefik.docker.network="traefik_web-net" --label traefik.frontend.rule="Host:php.vicoders.com"  localhost:5000/demo-php


 6: test

curl -H Host:php.vicoders.com http://127.0.0.1

