FROM localhost:5000/php7.2-laravel

# Create app directory
WORKDIR /var/www/workspace

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)

# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . .

EXPOSE 443 80

CMD ["/start.sh"]