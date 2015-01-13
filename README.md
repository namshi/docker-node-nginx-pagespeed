# Docker Node Nginx Pagespeed

This is a docker container meant for nodejs apps delivering web content and aiming to an high page speed score.
It includes a very simple custom build of nginx that will apply (google's page speed)[https://developers.google.com/speed/pagespeed/] goodies
so you don't need to do it yourself in you node code :)

## How to use it
Simply start your container form this one:

```
#Dockerfile

FROM namshi/node-pagespeed
```

## What it provides

- noodejs
- a simple nginx acting as a transparent proxy and including the page speed module
- gulp
- clusterjs
- browserify
- cdnwhaaat
- casperjs
- phantomjs
- compass
- mocha

## Caches
By default the page speed cache will be written in `/var/pagespeed/cache`, mount your desired directory in that path if you need

## Nginx configuration
Just mount your desired config file into `/etc/nginx/sites-enabled/default`
By default nginx will listen on the 80 port and expect your node app to listen on the 9004 port.

## Examples

# Dockerfile
```
FROM namshi/docker-node-nginx-pagespeed

COPY . /src
WORKDIR /src
RUN npm install

CMD nginx && clusterjs src/path/to/your/app.js
```

#fig.yml
```yml
web:
  build: .
  ports:
   - "80:8080"
  volumes:
   - .:/src
  command: bash -c 'npm install && nginx && gulp <task> && node src/path/to/your/app.js'

```

## SSL
No, there's no SSL support in here. The main purpose is just to be able to use pagepseed in a simple and isolated way for the contained application.
We strongly suggest you to put your very own nginx on top of this supporting SSL and everything else you might need :)