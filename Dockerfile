FROM dockerfile/nodejs

MAINTAINER Luciano Colosio "luciano.colosio@namshi.com"

RUN apt-get update && apt-get install -y python python-pip python-dev nginx-extras libfreetype6 libfontconfig1 wget build-essential zlib1g-dev libpcre3 libpcre3-dev unzip -y

ENV NGINX_VERSION 1.7.9
ENV NPS_VERSION 1.9.32.3

RUN cd /usr/src
RUN cd /usr/src && wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip
RUN cd /usr/src && unzip release-${NPS_VERSION}-beta.zip
RUN cd /usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && pwd && wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
RUN cd /usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && tar -xzvf ${NPS_VERSION}.tar.gz

RUN cd /usr/src
RUN cd /usr/src && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN cd /usr/src && tar -xvzf nginx-${NGINX_VERSION}.tar.gz
RUN cd /usr/src/nginx-${NGINX_VERSION}/ && ./configure --add-module=/usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta \
  --prefix=/usr/local/share/nginx --conf-path=/etc/nginx/nginx.conf \
  --sbin-path=/usr/local/sbin --error-log-path=/var/log/nginx/error.log
RUN cd /usr/src/nginx-${NGINX_VERSION}/ && make
RUN cd /usr/src/nginx-${NGINX_VERSION}/ && sudo make install

RUN npm install -g clusterjs

COPY ./config/default /etc/nginx/sites-enabled/default

RUN mkdir -p /var/pagespeed/cache