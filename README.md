# xmik/php-apache-openshift

A docker image based on [`php:5.6.31-apache`](https://github.com/docker-library/php/blob/master/5.6/apache/Dockerfile), ready to be deployed on OpenShift 3.

## Why this image
Why not just use `php:5.6.31-apache`?
1. Because it was not deployable on OpenShift 3.
1. Because I needed to install mcrypt php extension and git.
1. Because I needed to enable apache module: rewrite.

## Usage

### Local
You may want to initialize some dummy website contents:
```
mkdir -p /tmp/php-apache-openshift-itest
cp ./test/test-files/index.php /tmp/php-apache-openshift-itest/
```

Example, using **docker volume from localhost**:
```
docker run --name php-apache-openshift-itest -d -p 8080:8080\
  -v /tmp/php-apache-openshift-itest:/var/www/html\
  --user=123123\
  xmik/php-apache-openshift:0.2.2
```

Example with **website code from github** and custom apache2 virtual host:
```
docker run --name php-apache-openshift-itest -d -p 8080:8080\
  -v ${PWD}/test/test-files/virtual-host.conf:/etc/apache2/sites-enabled/000-default.conf\
  --user=123123\
  xmik/php-apache-openshift:0.2.2\
  /bin/bash -c "cd /var/www/html && test -d simple-php-website || git clone https://github.com/banago/simple-php-website.git ; apache2-foreground"
```

Example with **website code from github, downloaded over git ssh** (*please do not omit the quotation marks*):
```
docker run --name php-apache-openshift-itest -d -p 8080:8080\
  -v "${PWD}/dev/apache/virtual-host.conf":/etc/apache2/sites-enabled/000-default.conf\
  -v ${HOME}/.ssh/some_id_rsa_readable:/tmp/github_id_rsa\
  --user=123123\
  xmik/php-apache-openshift:0.2.2\
  /bin/bash -c "set -xe ; cp /tmp/github_id_rsa \$HOME/.ssh/id_rsa && chmod 0600 \$HOME/.ssh/id_rsa && cd /var/www/html && test -d simple-php-website || git clone git@github.com:banago/simple-php-website.git ; apache2-foreground"
```

## Development

You need Bash and Bats (for tests).

```
./tasks build
./tasks itest
```
