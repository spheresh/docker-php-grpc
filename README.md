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
  --build-arg PHP_IMAGE=8.4-cli \
  -t php-grpc:ubuntu .
```

Alpine image tags in examples are reference-only for legacy context and are not supported build targets.

Compatibility builds are validated in CI on `ubuntu-latest`.
