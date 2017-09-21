# xmik/php-apache-openshift

A docker image based on [`php:5.6.31-apache`](https://github.com/docker-library/php/blob/master/5.6/apache/Dockerfile), ready to be deployed on OpenShift 3.

## Why this image
Why not just use `php:5.6.31-apache`?
1. Because it was not deployable on OpenShift 3.
1. Because I needed to install mcrypt php extension.
1. Because I needed to enable apache module: rewrite.

## Usage

### Local
```
docker run --name php-apache-openshift-itest -d -p 8080:8080\
  -v /tmp/php-apache-openshift-itest:/var/www/html\
  xmik/php-apache-openshift:0.1.0
```

## Development

You need Bash and Bats (for tests).

```
./tasks build
./tasks itest
```
