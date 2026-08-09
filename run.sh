#!/bin/sh

CFNAT='./cfnat'

while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - cfnat 启动 ..."

    ARGS="-delay=$delay \
        -ipnum=$ipnum \
        -ips=$ips \
        -num=$num \
        -port=$port \
        -http-port=$http_port \
        -random=$random \
        -task=$task \
        -code=$code \
        -domain=$domain \
        -health-log=$health_log \
        -log=$log \
        -baidu-resolver=$baidu_resolver"

    [ -n "$colo" ] && ARGS="$ARGS -colo=$(echo "$colo" | tr '[:lower:]' '[:upper:]')"
    [ -n "$direct_listen" ] && ARGS="$ARGS -direct-listen=$direct_listen"
    [ -n "$baidu_listen" ] && ARGS="$ARGS -baidu-listen=$baidu_listen"
    [ -n "$bind_if" ] && ARGS="$ARGS -bind-if=$bind_if"

    eval $CFNAT $ARGS

    echo "$(date '+%Y-%m-%d %H:%M:%S') - cfnat 退出，5 秒后重启..."
    sleep 5
done
