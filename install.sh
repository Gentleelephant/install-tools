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
echo "Golang安装完成!"

# 安装docker

# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 验证安装
docker version
docker-compose version

# 安装完成
echo "Docker安装完成!"


# 一键安装miniconda

# 定义要安装的Miniconda版本号和操作系统类型
OS_TYPE=$(uname -s)

# 根据操作系统类型选择Miniconda安装包下载地址

# Linux
PYTHON310=https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh
PYTHON39=https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh
PYTHON38=https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh
PYTHON37=https://repo.anaconda.com/miniconda/Miniconda3-py37_23.1.0-1-Linux-x86_64.sh

MINICONDA_URL=$PYTHON39

# 读取用户输入的python版本
read -p "请输入要安装的python版本号(默认3.9)：" READ_VERSION

if [ $OS_TYPE == "Linux" ]; then
  if [ $READ_VERSION == "3.10" ]; then
    MINICONDA_URL=$PYTHON310
  elif [ $READ_VERSION == "3.9" ]; then
    MINICONDA_URL=$PYTHON39
  elif [ $READ_VERSION == "3.8" ]; then
    MINICONDA_URL=$PYTHON38
  elif [ $READ_VERSION == "3.7" ]; then
    MINICONDA_URL=$PYTHON37
  else
    echo "Unsupported python version"
    exit 1
  fi
#elif [ $OS_TYPE == "Darwin" ]; then
#  MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-py39_${MINICONDA_VERSION}-MacOSX-x86_64.sh
#else
#  echo "Unsupported operating system"
#  exit 1
fi

# 下载Miniconda安装包
curl -O $MINICONDA_URL

# 截取URL
MINICONDA_FILE=$(echo $MINICONDA_URL | cut -d'/' -f 6 | cut -d'-' -f 3)

# 安装Miniconda并设置环境变量
bash MINICONDA_FILE -b -p $HOME/miniconda
echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc

# 验证安装
conda --version


