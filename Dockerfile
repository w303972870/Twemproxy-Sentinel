FROM alpine:latest
MAINTAINER Eric Wang <wdc-zhy@163.com>

ENV START=redis LISTION=IP SENTINEL_LISTION_SERVER_NAME=master SENTINEL_LISTION_SERVER_IP=master \
    SENTINEL_LISTION_SERVER_IP_PORT=6379 SENTINEL_QUORUM=2 SENTINEL_DOWN_AFTER=1000 \
    SENTINEL_FAILOVER=1000 REDIS_PORT=6370 REDIS_REQUIREPASS=0 REDIS_MASTERAUTH=0 \
    REDIS_SLAVEOF_IP=0  REDIS_SLAVEOF_PORT=0 REDIS_BIND_IP=0.0.0.0 PROTECTED_MODE=no 

RUN mkdir -p /data/ && apk update && apk add redis && apk add tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && apk add --no-cache --virtual .build-deps git autoconf automake libtool gcc g++ make  && \
    git clone https://github.com/twitter/twemproxy.git /data/ && cd /data/ && autoreconf -fvi && \
    ./configure && make && make install &&  rm -rf /data/* && mkdir -p /data/logs && \ 
    apk del .build-deps gcc g++ openssl-dev zlib-dev perl-dev pcre-dev make git autoconf automake libtool && rm -rf /var/cache/apk/* && \
    mkdir -p /data/logs && mkdir -p /data/conf

ADD redis_master.conf /data/conf
ADD sentinel.conf /data/conf
ADD docker-entrypoint.sh /usr/local/bin/

RUN chown redis:redis /data/* && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 26379 22121

ENTRYPOINT ["docker-entrypoint.sh"]




