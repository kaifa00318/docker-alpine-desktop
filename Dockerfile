FROM alpine:latest

# 1. 安装基础依赖：Bash、Xfce4桌面、终端、虚拟显卡(Xvfb)、VNC服务器(x11vnc)、Git、Python3及字体
RUN apk update && apk add --no-cache \
    bash \
    xfce4 \
    xfce4-terminal \
    xvfb \
    x11vnc \
    git \
    python3 \
    py3-numpy \
    ttf-dejavu \
    adwaita-icon-theme

# 2. 下载并配置 noVNC (网页端 VNC 客户端) 和 websockify 转发器
RUN git clone --depth=1 https://github.com/novnc/noVNC.git /root/noVNC && \
    git clone --depth=1 https://github.com/novnc/websockify.git /root/noVNC/utils/websockify && \
    ln -s /root/noVNC/vnc.html /root/noVNC/index.html

# 3. 复制并配置容器启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 4. 暴露端口：6080 用于网页访问，5901 用于传统 VNC 客户端访问
EXPOSE 6080 5901

# 5. 设置容器启动入口
ENTRYPOINT ["/entrypoint.sh"]
