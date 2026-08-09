# CFnat-Docker

CFnat-Docker 是一个基于 Docker 的 Cloudflare IP 优选转发工具，自动寻找并优化 Cloudflare IP 转发，帮助解决广播 IP 路由不稳定的问题，提升网络性能。

## 免责声明

本软件仅供教育、研究和安全测试目的使用。用户必须遵守适用的法律法规，并对其行为承担全部责任。作者建议在学习/研究后 24 小时内删除本软件。

## 快速开始

```bash
docker run -d --name mycfnat --restart always -p 1234:1234 wuki/cfnat:lang-go
```

## 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| colo | 数据中心筛选（IATA 代码，逗号分隔） | SJC,LAX,HKG |
| delay | 有效延迟（毫秒） | 300 |
| ips | IP 类型（4 或 6） | 4 |
| port | 转发目标端口 | 443 |
| tls | 是否为 TLS 端口（true/false） | true |
| random | 随机生成 IP（true/false） | true |
| ipnum | 提取有效 IP 数量 | 10 |
| num | 目标负载 IP 数量 | 10 |
| task | 最大并发请求数 | 100 |
| code | HTTP/HTTPS 响应状态码 | 200 |
| domain | 状态码检查域名地址 | cloudflaremirrors.com/debian |

## 使用示例

**香港数据中心，IPv6，延迟 160ms：**

```bash
docker run -d -e colo="HKG" -e delay=160 -e ips=6 --restart always -p 1234:1234 wuki/cfnat:lang-go
```

**香港数据中心，IPv4，端口 80，非 TLS，本地端口 8080：**

```bash
docker run -d -e colo="HKG" -e delay=160 -e ips=4 -e port=80 -e tls=false --restart always -p 8080:1234 wuki/cfnat:lang-go
```

**SJC/LAX 数据中心，IPv4，延迟 200ms：**

```bash
docker run -d -e colo="SJC,LAX" -e delay=200 -e ips=4 --restart always -p 1234:1234 wuki/cfnat:lang-go
```

## Docker Compose

```yaml
version: '3'
services:
  cfnat:
    container_name: mycfnat
    image: wuki/cfnat:lang-go
    environment:
      - colo=SJC,LAX,HKG
      - delay=300
      - ips=4
      - port=443
      - tls=true
      - random=true
      - ipnum=10
      - num=10
      - task=100
      - code=200
      - domain=cloudflaremirrors.com/debian
    ports:
      - "1234:1234"
    restart: always
```

## 推荐数据中心

| 运营商 | 推荐节点 |
|--------|----------|
| 电信/联通 | SJC, LAX |
| 移动/广播 | HKG |
