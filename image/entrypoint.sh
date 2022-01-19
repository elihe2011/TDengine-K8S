#!/bin/bash

set +e
ulimit -c unlimited
sysctl -w kernel.core_pattern=/corefile/core-%e-%p
set -e

if [ "x$TZ" != "x" ]; then
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
fi


if [ "$TAOS_FQDN" = "" ]; then
    echo "TAOS_FQDN not set"
    exit 1
fi

sed -i "s#.*fqdn.*#fqdn    ${TAOS_FQDN}#" /etc/taos/taos.cfg
if [ $? -ne 0 ]; then
    echo "refreshing fqdn failed"
    exit 1
fi

if [ "x$TAOS_FIRST_EP" != "x" ]; then
    sed -i "s#.*firstEp.*#firstEp     ${TAOS_FIRST_EP}#" /etc/taos/taos.cfg
    if [ $? -ne 0 ]; then
        echo "refreshing firstEp failed"
        exit 1
    fi
fi

if [ "x$TAOS_SERVER_PORT" != "x" ]; then
    sed -i "s#.*serverPort.*#serverPort     ${TAOS_SERVER_PORT}#" /etc/taos/taos.cfg
    if [ $? -ne 0 ]; then
        echo "refreshing serverPort failed"
        exit 1
    fi
fi


CLUSTER=${CLUSTER:=}
FIRST_EP_HOST=${TAOS_FIRST_EP%:*}
SERVER_PORT=${TAOS_SERVER_PORT:-6030}


if [ "$CLUSTER" = "" ]; then
    # single node
    $@
elif [ "$TAOS_FQDN" = "$FIRST_EP_HOST" ] ; then
    # master node
    $@
else
    # follower, wait for master node ready
    while true
    do
        taos -h $FIRST_EP_HOST -n startup > /dev/null
        if [ $? -eq 0 ]; then
            taos -h $FIRST_EP_HOST -s "create dnode \"$TAOS_FQDN:$SERVER_PORT\";"
            break
        fi
        sleep 1s
    done

    $@
fi