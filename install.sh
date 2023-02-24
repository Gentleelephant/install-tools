#!/bin/bash
set -e

read -p "Please enter the golang version to be installed(default 1.20.1):" VERSION

# 如果VERSION为空，则默认为1.20.1
if [ -z $VERSION ]; then
  VERSION=1.20.1
fi

# 定义安装包的下载地址
#https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
URL=https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz

# 定义安装目录
INSTALL_DIR=~

# 下载安装包并解压到指定目录
wget $URL
tar -C ${INSTALL_DIR} -xzf go${VERSION}.linux-amd64.tar.gz

# 配置环境变量
echo "export PATH=\$PATH:${INSTALL_DIR}/go/bin" >> /etc/profile
source /etc/profile
# 删除安装包
rm -rf go${VERSION}.linux-amd64.tar.gz
# 验证安装
go version

# 安装完成
echo "Golang installed!"

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

# 删除不需要的文件
rm -rf get-docker.sh

# 安装完成
echo "Docker installed!"


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
read -p "Please enter the python version to be installed(default 1.20.1):" READ_VERSION

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


