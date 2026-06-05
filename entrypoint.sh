#!/bin/bash

# 如果外部运行没有传入分辨率和密码，则使用默认值
RESOLUTION=${RESOLUTION:-"1280x720x24"}
VNC_PASSWORD=${VNC_PASSWORD:-"alpine"}

echo "1. 正在启动 Xvfb 虚拟显示屏 (Display :1)..."
Xvfb :1 -screen 0 $RESOLUTION &
export DISPLAY=:1

# 等待虚拟显卡初始化完毕
sleep 1

echo "2. 正在启动 Xfce4 桌面环境..."
startxfce4 &

echo "3. 正在启动 x11vnc 服务..."
# 启动 VNC 并配置访问密码
x11vnc -forever -shared -passwd "$VNC_PASSWORD" -display :1 -rfbport 5901 &

echo "4. 正在启动 noVNC 网页代理 (监听 6080 端口)..."
/root/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 6080
