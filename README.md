# xmik/php-apache-openshift

A docker image based on [`php:5.6.31-apache`](https://github.com/docker-library/php/blob/master/5.6/apache/Dockerfile), ready to be deployed on OpenShift 3.

## Why this image
Why not just use `php:5.6.31-apache`?
1. Because it was not deployable on OpenShift 3.
1. Because I needed to install mcrypt php extension and git.
1. Because I needed to enable apache module: rewrite.

## Usage

### Local
Simple example:
```
docker run --name php-apache-openshift-itest -d -p 8080:8080\
  -v /tmp/php-apache-openshift-itest:/var/www/html\
  xmik/php-apache-openshift:0.2.1
```

Example with website code from github and custom apache2 virtual host:
```
docker run --name php-apache-openshift-itest -d -p 8080:8080\
  -v /tmp/php-apache-openshift-itest:/var/www/html\
  -v $(pwd)/test/test-files/virtual-host.conf:/etc/apache2/sites-enabled/000-default.conf\
  xmik/php-apache-openshift:0.2.1\
  /bin/bash -c "cd /var/www/html && test -d simple-php-website || git clone https://github.com/banago/simple-php-website.git ; apache2-foreground"
```

## Development

You need Bash and Bats (for tests).

```
./tasks build
./tasks itest
```
