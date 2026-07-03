# syntax=docker/dockerfile:1

# 第一个阶段：根据 buildx 目标架构编译二进制
FROM --platform=$BUILDPLATFORM golang:alpine AS builder

WORKDIR /src

ARG TARGETOS
ARG TARGETARCH

COPY cfnat.go ./

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags="-s -w" -o /out/cfnat cfnat.go

# 第二个阶段：运行阶段
FROM alpine:latest

RUN apk add --no-cache ca-certificates \
    && adduser -D -H -u 10001 cfnat \
    && mkdir -p /data \
    && chown cfnat:cfnat /data

WORKDIR /data

COPY --from=builder /out/cfnat ./cfnat
COPY go.sh ./go.sh

RUN chmod +x ./cfnat ./go.sh \
    && chown cfnat:cfnat ./cfnat ./go.sh

# 设置环境变量默认值
ENV colo="SJC,LAX,HKG" \
    delay="300" \
    ipnum="10" \
    ips="4" \
    num="10" \
    port="443" \
    random="true" \
    task="100" \
    tls="true" \
    code="200" \
    domain="cloudflaremirrors.com/debian"

# 暴露 1234 端口
EXPOSE 1234

USER cfnat

# 运行 go.sh 脚本
CMD ["/bin/sh", "./go.sh"]
