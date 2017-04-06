# Private Registry Build

## Host Details

* OS: **CentOS 7**
* User: `root`

## Install Docker

```bash
$ yum update # Update packages.
$ yum install -y htop # Better top, YMMV.
$ rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 # Import EPEL GPG key.
$ yum install -y epel-release # Enable EPEL.
$ curl -sSL https://get.docker.com/ | sh # Install Docker.
$ systemctl start docker # Start Docker.
$ systemctl enable docker # Start Docker on boot.
$ docker run hello-world # Test Docker install.
```

## Configure Registry

**NOTE**: Configured to use AWS S3 for image storage.

Config File Example:

```yaml
# /root/config.yml
version: 0.1
log:
  fields:
    service: registry
storage:
  s3:
    accesskey: # AWS Key ID
    secretkey: # AWS Secret Key
    region: us-west-1
    bucket: your-s3-bucket
http:
    addr: :5000
    headers:
        X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
```

## Authentication

* User: `your-docker-user`
* Pass: `your-docker-password`

```bash
$ mkdir auth
$ docker run --entrypoint htpasswd registry:2 -Bbn your-docker-user your-docker-password > auth/htpasswd
```

## Start and Create Registry Container

```bash
# Auth and TLS information are included in the container as mounted volumes.
$ docker run -d -p 5000:5000 --restart=always --name registry \
  -v `pwd`/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v /root/config.yml:/etc/docker/registry/config.yml \
  -v /root/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/private.registry.com.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/private.registry.com.key \
  registry:2
```

## Add Registry Users

```bash
# Stop the registry container:
$ docker stop registry
# Remove the registry container:
$ docker rm registry
# Add the new user:
docker run --entrypoint htpasswd registry:2 -Bbn newuser newpass >> auth/htpasswd
# Rebuild the registry container:
$ docker run -d -p 5000:5000 --restart=always --name registry \
  -v `pwd`/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v /root/config.yml:/etc/docker/registry/config.yml \
  -v /root/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/private.registry.com.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/private.registry.com.key \
  registry:2
```

## Remove Registry Users

Just remove a given user's entry from the `/root/auth/htpasswd` file.
