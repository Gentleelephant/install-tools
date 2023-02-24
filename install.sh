#!/bin/bash

set -e

# 定义要安装的Go版本号
VERSION=1.20.1

# 读取用户输入
read -p "请输入要安装的Go版本号(默认1.20.1)：" VERSION

# 定义安装包的下载地址
URL=https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz

# 定义安装目录
INSTALL_DIR=~/go

# 下载安装包并解压到指定目录
curl -O ${URL}
tar -C ${INSTALL_DIR} -xzf go${VERSION}.linux-amd64.tar.gz

# 配置环境变量
echo "export PATH=\$PATH:${INSTALL_DIR}/go/bin" >> /etc/profile
source /etc/profile

# 删除安装包
rm -rf go${VERSION}.linux-amd64.tar.gz

# 验证安装
go version

# 安装完成
echo "Golang安装完成"