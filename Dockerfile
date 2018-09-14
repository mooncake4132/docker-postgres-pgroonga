FROM mooncake4132/postgres-pgroonga:latest

ENV PLUGIN_VERSION=v0.9.0.Alpha1

# Compile the plugins from sources and install
RUN echo -e "http://dl-cdn.alpinelinux.org/alpine/edge/main\n" >> /etc/apk/repositories \
    && echo -e "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing\n" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --virtual .debezium-build-deps gcc git make musl-dev pkgconf \
    && apk add --no-cache protobuf-c-dev postgis-dev@testing proj4-dev@testing \
    && git clone https://github.com/debezium/postgres-decoderbufs -b $PLUGIN_VERSION --single-branch \
    && (cd postgres-decoderbufs && make && make install) \
    && rm -rf postgres-decoderbufs \
    && apk del .debezium-build-deps

# Copy the custom configuration which will be passed down to the server (using a .sample file is the preferred way of doing it by 
# the base Docker image)
COPY postgresql.conf.sample /usr/local/share/postgresql/postgresql.conf.sample

# Copy the script which will initialize the replication permissions
COPY init-permissions.sh /docker-entrypoint-initdb.d/
