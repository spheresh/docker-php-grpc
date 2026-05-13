ARG PHP_IMAGE=8.4-cli

FROM --platform=${TARGETPLATFORM:-linux/amd64} php:${PHP_IMAGE}

ENV TZ="UTC"

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions

ARG XDEBUG_ENABLED=false
ARG COMPATIBILITY_MODE=ubuntu
ARG PROTOBUF_VERSION="4.29.1"
ARG GRPC_VERSION="1.68.0"

RUN set -eux; \
  case "${COMPATIBILITY_MODE}" in \
    ubuntu|debian|auto) ;; \
    *) \
      echo "Unsupported COMPATIBILITY_MODE: ${COMPATIBILITY_MODE}. Use ubuntu or debian." >&2; \
      exit 1; \
      ;; \
  esac; \
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
  rm -rf /var/lib/apt/lists/*

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
    apt-get purge -y --auto-remove ${PHPIZE_DEPS}; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /tmp/*

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
