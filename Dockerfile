# Adapted from https://github.com/takehiko/docker-pgroonga/blob/2023f5d8e11c62607593c5775e207382960bb1c1/Dockerfile
FROM postgres:10.4-alpine

ENV GROONGA_VERSION=8.0.5 \
    PGROONGA_VERSION=2.1.1

WORKDIR /root

# Build tools and Groonga
RUN apk add --update --no-cache build-base \
    && wget https://packages.groonga.org/source/groonga/groonga-${GROONGA_VERSION}.tar.gz \
    && tar xvzf groonga-${GROONGA_VERSION}.tar.gz \
    && cd groonga-${GROONGA_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd ..

# PGroonga
RUN apk add --update --no-cache libstdc++ \
    && wget https://packages.groonga.org/source/pgroonga/pgroonga-${PGROONGA_VERSION}.tar.gz \
    && tar xvf pgroonga-${PGROONGA_VERSION}.tar.gz \
    && cd pgroonga-${PGROONGA_VERSION} \
    && make \
    && make install \
    && cd ..

# Clean up
RUN apk del build-base \
    && rm -rf \
        groonga-*  \
        pgroonga-* \
        /usr/local/share/doc/groonga \
        /usr/local/share/groonga
