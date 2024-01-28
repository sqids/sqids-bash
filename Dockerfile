ARG VERSION

FROM bash:${VERSION}

COPY ./src /var/tmp/src
COPY ./tests /var/tmp/tests

WORKDIR /var/tmp

# install git and bats
RUN apk update \
    && apk add --no-cache git \
    && git clone https://github.com/bats-core/bats-core.git \
    && cd bats-core \
    && ./install.sh /usr/local
