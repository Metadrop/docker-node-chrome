# Based in https://github.com/matseee/docker-images/blob/main/node/Dockerfile
ARG OS_VERSION
ARG NODE_VERSION

FROM node:$NODE_VERSION-$OS_VERSION AS node


RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > linux_signing_key.pub \
    && install -D -o root -g root -m 644 linux_signing_key.pub /etc/apt/keyrings/linux_signing_key.pub

RUN  sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/linux_signing_key.pub] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'


RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install google-chrome-stable -y

RUN npx playwright install --with-deps

ENV CHROME_BIN=/usr/bin/google-chrome

