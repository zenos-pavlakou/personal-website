FROM exozet/php-fpm:8.1

# Removed Node v9.11.1 installation here as it's redundant with nvm

RUN apt-get update && apt-get install -y gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3  \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0  \
libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1  \
libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1  \
libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3  \
lsb-release xdg-utils wget python3 iputils-ping git && \
rm -rf /var/lib/apt/lists/* 

RUN mkdir /usr/src/app/personal_website
RUN git clone https://github.com/zenos-pavlakou/personal-website /usr/src/app/personal_website

COPY ./extra_files/git_setup.sh /usr/src/app/git_setup.sh
RUN chmod 777 /usr/src/app/git_setup.sh

COPY .env /usr/src/app/personal_website
COPY ./extra_files/php.ini /usr/local/etc/php/php.ini

WORKDIR /usr/src/app/personal_website

RUN composer update --ignore-platform-reqs
RUN composer install --ignore-platform-reqs
RUN composer require spatie/laravel-cookie-consent
RUN composer require spatie/laravel-server-side-rendering --ignore-platform-reqs

# Removed redundant package-lock.json removal and python3 installation

SHELL ["/bin/bash", "--login", "-c"]

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN nvm install 14 && nvm use 14

# Update npm after using nvm to set the Node version
RUN npm install -g npm@latest

# Uncomment if you want to do other npm operations
# RUN npm cache clear
# RUN npm install

EXPOSE 22
EXPOSE 80

CMD ["php", "artisan", "serve", "--host", "0.0.0.0", "--port", "80"]
