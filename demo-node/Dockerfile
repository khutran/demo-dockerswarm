FROM khutran/node:10.15

RUN mkdir -p /var/www/workspace

WORKDIR /var/www/workspace
ENV TEST_ENV=KHU

COPY ./workspace/ .

RUN yarn install

EXPOSE 3000

CMD ["node", "server.js"]
