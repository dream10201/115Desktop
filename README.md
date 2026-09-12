# 115Desktop - Web 环境中的 115生活 桌面客户端

在 Docker 中运行 115 官方 Linux 桌面客户端（115生活），通过浏览器 noVNC 访问。

## 快速开始

### Docker CLI
```bash
docker run \
--name 115desktop \
--security-opt seccomp:unconfined \
--user 0:0 \
--network=host -d \
-e PASSWORD=123456 \
-e DISPLAY_WIDTH=1920 \
-e DISPLAY_HEIGHT=1080 \
-e TZ=Asia/Shanghai \
-e LC_ALL=zh_CN.UTF-8 \
-v /path/to/115:/etc/115 \
-v /path/to/download:/opt/Downloads \
--shm-size 1gb \
--restart unless-stopped \
ghcr.io/dream10201/115desktop:latest
```

### Docker Compose
```bash
docker compose up -d
```

### 访问服务
[http://localhost:1150/vnc.html](http://localhost:1150/vnc.html)

## 配置

### 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `PASSWORD` | "" | Web VNC 密码 |
| `AUTO_START` | "true" | 是否随容器自动启动 115生活，设为 `false` 后可在桌面双击图标手动启动 |
| `DISPLAY_WIDTH` | 1366 | 桌面宽度 |
| `DISPLAY_HEIGHT` | 768 | 桌面高度 |

### 数据卷挂载

| 容器路径 | 说明 |
|----------|------|
| `/etc/115` | 客户端配置与数据目录（登录信息、数据库等） |
| `/opt/Downloads` | 下载目录 |

## 许可证

本项目采用 [GPL-3.0 许可证](LICENSE)。

## 免责声明

- 本项目仅供学习和研究使用
- 请遵守相关法律法规和服务条款
- 使用本项目产生的任何问题由用户自行承担

**注意**: 本项目与 115 官方无关，仅为第三方 Docker 化方案。
