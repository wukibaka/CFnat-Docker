# cfnat Docker

基于 [fscarmen/cfnat](https://github.com/fscarmen/cfnat) C 版本的 Docker 部署镜像。

glibc 动态链接，`busybox:glibc` 运行时，支持 `linux/amd64` 和 `linux/arm64`。

---

## 快速开始

```bash
docker run -d --restart=always --name cfnat \
  -p 1234:1234 \
  wuki/cfnat:lang-c
```

## 环境变量

| 环境变量 | 对应参数 | 默认值 | 说明 |
|----------|----------|--------|------|
| `direct_listen` | `-direct-listen` | `0.0.0.0:1234` | 直连优选监听地址 |
| `baidu_listen` | `-baidu-listen` | 空 | 百度前置优选监听地址 |
| `baidu_resolver` | `-baidu-resolver` | `auto` | 百度域名解析器 |
| `bind_if` | `-bind-if` | 空 | 出站绑定网络接口 |
| `colo` | `-colo` | 空 | 数据中心过滤，如 `HKG,SJC,LAX` |
| `delay` | `-delay` | `300` | 有效延迟阈值（毫秒） |
| `ipnum` | `-ipnum` | `20` | 保留候选 IP 数量 |
| `ips` | `-ips` | `4` | IPv4 或 IPv6，取值 `4` 或 `6` |
| `num` | `-num` | `5` | 每连接目标尝试次数 |
| `port` | `-port` | `443` | TLS 转发目标端口 |
| `http_port` | `-http-port` | `80` | 非 TLS 转发目标端口 |
| `random` | `-random` | `true` | 是否随机抽样 IP |
| `task` | `-task` | `100` | 扫描并发数 |
| `code` | `-code` | `200` | 探测期望状态码 |
| `domain` | `-domain` | `cloudflaremirrors.com/debian` | 健康检查域名 |
| `health_log` | `-health-log` | `60` | 健康检查日志间隔（秒） |
| `log` | `-log` | `info` | 日志级别 |

---

## 使用示例

### 直连优选

```bash
docker run -d --restart=always --name cfnat \
  -p 1234:1234 \
  wuki/cfnat:lang-c
```

### 指定数据中心

```bash
docker run -d --restart=always --name cfnat \
  -p 1234:1234 \
  -e colo="HKG,SJC,LAX" \
  wuki/cfnat:lang-c
```

### 百度前置优选

```bash
docker run -d --restart=always --name cfnat \
  -p 1235:1235 \
  -e direct_listen="" \
  -e baidu_listen="0.0.0.0:1235" \
  wuki/cfnat:lang-c
```

### 双方案同时监听

```bash
docker run -d --restart=always --name cfnat \
  -p 1234:1234 -p 1235:1235 \
  -e direct_listen="0.0.0.0:1234" \
  -e baidu_listen="0.0.0.0:1235" \
  wuki/cfnat:lang-c
```

### IPv6 模式

```bash
docker run -d --restart=always --name cfnat \
  -p 1234:1234 \
  -e ips="6" \
  wuki/cfnat:lang-c
```

---

## 构建

本地构建：

```bash
docker build -t cfnat .
```

多架构构建：

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t wuki/cfnat:lang-c .
```

---

## 免责声明

本工具仅用于网络测试与学习用途。使用者需自行承担因错误配置、滥用或违反当地法律法规造成的后果。
