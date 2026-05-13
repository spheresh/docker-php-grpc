# Docker container with PHP based on alpine image

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

The image now supports a compatibility mode toggle for Alpine and Debian/Ubuntu-style package managers:

- `COMPATIBILITY_MODE=auto` (default): detect package manager automatically.
- `COMPATIBILITY_MODE=alpine`: force Alpine package installation.
- `COMPATIBILITY_MODE=ubuntu` (or `debian`): force Debian/Ubuntu package installation.

Examples:

```bash
# Default (Alpine PHP image)
docker build -t php-grpc:alpine .

# Ubuntu-compatible mode (Debian/Ubuntu package manager path)
docker build \
  --build-arg PHP_IMAGE=8.4-cli \
  --build-arg COMPATIBILITY_MODE=ubuntu \
  -t php-grpc:ubuntu-compatible .
```

Compatibility builds are validated in CI on `ubuntu-22.04`, `ubuntu-24.04`, and `ubuntu-latest`.
