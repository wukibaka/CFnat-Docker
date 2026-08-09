# syntax=docker/dockerfile:1

# 构建阶段：克隆源码，glibc 动态编译
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc libc6-dev git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone --depth 1 https://github.com/fscarmen/cfnat.git . \
    && mkdir -p /out && gcc -O2 -pipe -std=c11 \
    -Wall -Wextra -Wno-unused-parameter \
    cfnat.c -o /out/cfnat \
    -pthread -s

# 运行阶段
FROM busybox:glibc

RUN adduser -D -H -u 10001 cfnat \
    && mkdir -p /data \
    && chown cfnat:cfnat /data

WORKDIR /data

COPY --from=builder /out/cfnat ./cfnat
COPY run.sh ./run.sh

RUN chmod +x ./cfnat ./run.sh \
    && chown cfnat:cfnat ./cfnat ./run.sh

ENV direct_listen="0.0.0.0:1234" \
    baidu_listen="" \
    baidu_resolver="auto" \
    bind_if="" \
    colo="" \
    delay="300" \
    ipnum="20" \
    ips="4" \
    num="5" \
    port="443" \
    http_port="80" \
    random="true" \
    task="100" \
    code="200" \
    domain="cloudflaremirrors.com/debian" \
    health_log="60" \
    log="info"

EXPOSE 1234

USER cfnat

CMD ["/bin/sh", "./run.sh"]
