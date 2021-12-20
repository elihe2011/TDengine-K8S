FROM ubuntu:18.04 as builder
RUN apt-get update \
    && apt-get install -y gcc cmake build-essential git wget \
    && apt-get clean \
    && cd /usr/local/src \
    && wget https://github.com/taosdata/TDengine/archive/refs/tags/ver-2.2.2.0.tar.gz \
    && tar zxvf ver-2.2.2.0.tar.gz && cd TDengine-ver-2.2.2.0 \
    && mkdir debug && cd debug \
    && cmake .. && cmake --build . && make install
WORKDIR /root


FROM ubuntu:18.04
LABEL MAINTAINER="hehz@huitone.com>"

COPY ./entrypoint.sh /usr/bin/
COPY --from=0 /usr/local/taos /usr/local/taos
COPY --from=0 /etc/taos /etc/taos

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y apt-utils locales tzdata curl wget net-tools iproute2 iputils-ping sysstat binutils \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && chmod +x /usr/bin/entrypoint.sh \
    && ln -s /usr/local/taos/bin/taos /usr/bin/taos \
    && ln -s /usr/local/taos/bin/taosd       /usr/bin/taosd \
    && ln -s /usr/local/taos/bin/taosdump    /usr/bin/taosdump \
    && ln -s /usr/local/taos/bin/taosdemo    /usr/bin/taosdemo \
    && ln -s /usr/local/taos/bin/remove.sh   /usr/bin/rmtaos \
    && ln -s /usr/local/taos/include/taoserror.h  /usr/include/taoserror.h \
    && ln -s /usr/local/taos/include/taos.h  /usr/include/taos.h \
    && ln -s /usr/local/taos/driver/libtaos.so.2.2.2.0  /usr/lib/libtaos.so.1 \
    && ln -s /usr/lib/libtaos.so.1 /usr/lib/libtaos.so  \
    && mkdir -p /var/lib/taos \
    && mkdir -p /var/log/taos \
    && chmod 777 /var/log/taos

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

WORKDIR /etc/taos
EXPOSE 6030 6031 6032 6033 6034 6035 6036 6037 6038 6039 6040 6041 6042
CMD ["taosd"]
VOLUME [ "/var/lib/taos", "/var/log/taos", "/corefile" ]
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]