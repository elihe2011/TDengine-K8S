FROM ubuntu:18.04
LABEL MAINTAINER="hehz@huitone.com>"

COPY ./entrypoint.sh /usr/bin/

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -Ei "s#http://.*.ubuntu.com#http://mirrors.aliyun.com#" /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y apt-utils locales tzdata curl wget net-tools iproute2 iputils-ping sysstat binutils \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && cd /tmp \
    && wget -c https://www.taosdata.com/assets-download/TDengine-server-2.2.2.0-Linux-x64.tar.gz \
    && tar xf TDengine-server*.tar.gz && cd TDengine-server-*/ && ./install.sh -e no \
    && rm -rf /tmp/TD* \
    && chmod +x /usr/bin/entrypoint.sh

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

WORKDIR /etc/taos
EXPOSE 6030 6031 6032 6033 6034 6035 6036 6037 6038 6039 6040 6041 6042
CMD ["taosd"]
VOLUME [ "/var/lib/taos", "/var/log/taos", "/corefile" ]
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
