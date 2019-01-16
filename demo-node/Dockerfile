FROM localhost:5000/node:10.15

RUN mkdir -p /var/www/workspace

WORKDIR /var/www/workspace

COPY ./workspace/ .

RUN yarn install

EXPOSE 3000

CMD ["node", "server.js"]