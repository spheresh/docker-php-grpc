# Docker container with PHP based on Debian image

[![Downloads](https://img.shields.io/docker/pulls/spiralscout/php81-grpc.svg)](https://hub.docker.com/repository/docker/spiralscout/php81-grpc)

---

PHP version: 8.1.3

Enabled extensions:
- opcache
- zip
- xsl
- dom
- exif
- intl
- pcntl
- bcmath
- sockets
- protobuf
- grpc

## Ubuntu compatibility mode

The image build is Ubuntu-compatible only (Debian/Ubuntu package manager path).

Examples:

```bash
# Default Ubuntu-compatible build
docker build \
  --build-arg UBUNTU_VERSION=22.04 \
  --build-arg PHP_VERSION=8.4 \
  -f Dockerfile.ubuntu \
  -t php-grpc:ubuntu .
```

Alpine image tags in examples are reference-only for legacy context and are not supported build targets.

Compatibility builds are validated in CI on `ubuntu-latest`.

Your project Dockerfile then becomes:

  FROM ghcr.io/<your-org>/php-grpc-ubuntu:8.4 AS grpc

  FROM docksal/cli:php8.4-3.9 AS base

  ARG PHP_VERSION=8.4
  ARG ENABLE_CRON=false

  COPY --from=grpc /grpc-extensions/grpc.so /tmp/grpc-ext/
  COPY --from=grpc /grpc-extensions/protobuf.so /tmp/grpc-ext/
  COPY --from=grpc /grpc-extensions/grpc.ini /tmp/grpc-ext/
  COPY --from=grpc /grpc-extensions/protobuf.ini /tmp/grpc-ext/

  RUN PHP_EXT_DIR=$(php${PHP_VERSION} -r "echo ini_get('extension_dir');") \
      && cp /tmp/grpc-ext/grpc.so /tmp/grpc-ext/protobuf.so "${PHP_EXT_DIR}/" \
      && cp /tmp/grpc-ext/grpc.ini /tmp/grpc-ext/protobuf.ini /etc/php/${PHP_VERSION}/mods-available/ \
      && phpenmod -v ${PHP_VERSION} grpc protobuf \
      && rm -rf /tmp/grpc-ext

  # ... your cron block etc.