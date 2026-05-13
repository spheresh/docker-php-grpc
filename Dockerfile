ARG PHP_IMAGE=8.1-cli-alpine3.19

FROM --platform=${TARGETPLATFORM:-linux/amd64} php:${PHP_IMAGE}

ENV TZ="UTC"

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions

ARG XDEBUG_ENABLED=false
ARG COMPATIBILITY_MODE=auto
ARG PROTOBUF_VERSION="4.29.1"
ARG GRPC_VERSION="1.68.0"

RUN set -eux; \
  install_alpine_deps() { \
    apk update; \
    apk add --no-cache \
      bash \
      ca-certificates \
      icu-data-full icu-libs \
      libzip \
      linux-headers \
      lz4-libs \
      openssh-client \
      ${PHPIZE_DEPS}; \
  }; \
  install_debian_deps() { \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      bash \
      ca-certificates \
      libicu-dev \
      liblz4-1 \
      libzip-dev \
      linux-libc-dev \
      openssh-client \
      ${PHPIZE_DEPS}; \
    rm -rf /var/lib/apt/lists/*; \
  }; \
  case "${COMPATIBILITY_MODE}" in \
    auto) \
      if command -v apk >/dev/null 2>&1; then \
        install_alpine_deps; \
      elif command -v apt-get >/dev/null 2>&1; then \
        install_debian_deps; \
      else \
        echo "Unsupported base image package manager" >&2; \
        exit 1; \
      fi \
      ;; \
    alpine) \
      install_alpine_deps \
      ;; \
    ubuntu|debian) \
      install_debian_deps \
      ;; \
    *) \
      echo "Unsupported COMPATIBILITY_MODE: ${COMPATIBILITY_MODE}" >&2; \
      exit 1 \
      ;; \
  esac

RUN install-php-extensions grpc-${GRPC_VERSION} \
  && install-php-extensions protobuf-${PROTOBUF_VERSION} \
  && install-php-extensions intl \
  && install-php-extensions zip \
  && install-php-extensions curl \
  && install-php-extensions opcache \
  && install-php-extensions pcntl \
  && install-php-extensions sockets \
  && docker-php-ext-enable grpc protobuf

RUN if [ "${XDEBUG_ENABLED}" == "true" ]; then install-php-extensions xdebug && docker-php-ext-enable xdebug; fi

RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
      apk del --no-cache ${PHPIZE_DEPS}; \
    elif command -v apt-get >/dev/null 2>&1; then \
      apt-get purge -y --auto-remove ${PHPIZE_DEPS}; \
      rm -rf /var/lib/apt/lists/*; \
    fi; \
    rm -rf /tmp/*

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
