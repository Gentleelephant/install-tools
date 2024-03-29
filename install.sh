#!/bin/bash
set -e

OS_TYPE=$(uname -s)
ARCH=$(uname -m)

install_golang() {
  if command -v go >/dev/null 2>&1; then
    echo "golang already exists!Skin golang installation"
    return
  fi
  read -p "Please enter the golang version to be installed(default 1.20.1):" VERSION
  if [ -z $VERSION ]; then
    VERSION=1.20.1
  fi
  ARCH_VERSION="amd64"
  if [ $ARCH == "aarch64" ]; then
    ARCH_VERSION="arm64"
  fi
  if [ $ARCH == "x86_64" ]; then
    ARCH_VERSION="amd64"
  fi
  OS=""
  if [ $OS_TYPE == "Linux" ]; then
      OS="linux"
  elif [ $OS_TYPE == "Darwin" ]; then
      OS="darwin"
  else
      echo "Unsupported OS"
      exit 1
  fi
  URL=https://go.dev/dl/go${VERSION}.${OS}-${ARCH_VERSION}.tar.gz
  INSTALL_DIR=/usr/local
  wget $URL
  sudo tar -C ${INSTALL_DIR} -xzf go${VERSION}.${OS}-${ARCH_VERSION}.tar.gz
  echo "export PATH=\$PATH:${INSTALL_DIR}/go/bin" >>~/.bashrc
  rm -rf go${VERSION}.${OS}-${ARCH_VERSION}.tar.gz
  /usr/local/go/bin/go version
  echo "Golang installed!"
}

install_docker() {
  if command -v docker >/dev/null 2>&1; then
    echo "docker already exists!Skin docker installation"
    return
  fi
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker version
  docker-compose version
  rm -rf get-docker.sh
  echo "Docker installed!"
  echo "================================================"
}

install_miniconda() {
  if command -v conda >/dev/null 2>&1; then
    echo "miniconda already exists!Skin miniconda installation"
    return
  fi
  TYPE="Linux"
  if [[ $OS_TYPE == "Darwin" ]]; then
    TYPE="MacOSX"
  fi
  PYTHON310=https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-${TYPE}-${ARCH}.sh
  PYTHON39=https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-${TYPE}-${ARCH}.sh
  PYTHON38=https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-${TYPE}-${ARCH}.sh
  PYTHON37=https://repo.anaconda.com/miniconda/Miniconda3-py37_23.1.0-1-${TYPE}-${ARCH}.sh
  MINICONDA_URL=$PYTHON39
  read -p "Please enter the python version to be installed(default 3.9):" READ_VERSION
  if [ -z $READ_VERSION ]; then
    READ_VERSION="3.9"
  fi
  if [[ "$READ_VERSION" == "3.10" ]]; then
    MINICONDA_URL=$PYTHON310
  elif [[ "$READ_VERSION" == "3.9" ]]; then
    MINICONDA_URL=$PYTHON39
  elif [[ "$READ_VERSION" == "3.8" ]]; then
    MINICONDA_URL=$PYTHON38
  elif [[ "$READ_VERSION" == "3.7" ]]; then
    MINICONDA_URL=$PYTHON37
  else
    echo "Unsupported python version"
    exit 1
  fi
  curl -O $MINICONDA_URL
  MINICONDA_FILE=$(basename "$MINICONDA_URL")
  sh $MINICONDA_FILE -b -p /usr/local/miniconda
  echo 'export PATH=/usr/local/miniconda/bin:$PATH' >>~/.bashrc
  /usr/local/miniconda/bin/conda --version
  echo "Miniconda installed!"
  rm -rf $MINICONDA_FILE
}

install_nodejs(){
  if command -v node >/dev/null 2>&1; then
    echo "nodejs already exists!Skin nodejs installation"
    return
  fi
  ARCH_VERSION=""
  URL=""
  OS=""
  if [ $ARCH == "aarch64" ]; then
    ARCH_VERSION="arm64"
  fi
  if [ $ARCH == "x86_64" ]; then
    ARCH_VERSION="x64"
  fi
  if [ $OS_TYPE == "Linux" ]; then
      OS="linux"
      URL=https://nodejs.org/dist/v18.14.2/node-v18.14.2-linux-x64.tar.xz
  elif [ $OS_TYPE == "Darwin" ]; then
      OS="darwin"
      URL=https://nodejs.org/dist/v18.14.2/node-v18.14.2-darwin-${ARCH_VERSION}.tar.gz
  else
      echo "Unsupported OS"
      exit 1
  fi
  INSTALL_DIR=/usr/local
  wget $URL
  # 如果文件格式是tar.xz就用命令解压
  if [[ $URL == *.xz ]]; then
    sudo tar -C ${INSTALL_DIR} -xJf node-v18.14.2-${OS}-${ARCH_VERSION}.tar.xz
  else
    sudo tar -C ${INSTALL_DIR} -xzvf node-v18.14.2-${OS}-${ARCH_VERSION}.tar.gz
  fi
#  sudo tar -C ${INSTALL_DIR} -xzf node-v18.14.2-${OS}-${ARCH_VERSION}.tar.gz
  mv ${INSTALL_DIR}/node-v18.14.2-${OS}-${ARCH_VERSION} ${INSTALL_DIR}/node-v18.14.2
  echo "export PATH=\$PATH:${INSTALL_DIR}/node-v18.14.2/bin" >>~/.bashrc
  rm -rf node-v18.14.2-${OS}-${ARCH_VERSION}.tar.gz
  /usr/local/node-v18.14.2/bin/node -v
  echo "Nodejs installed!"
}


function install_java() {
    # 判断当前用户是否为root用户
    if [ x"$USER" != x"root" ];then
      echo "请使用root用户执行此脚本。"
      exit 1
    fi

    # 设置Java安装路径
    JAVA_HOME=/usr/local/java

    # 创建安装目录
    mkdir -p $JAVA_HOME

    # 下载Java压缩包
    JDK_URL="https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz"
    wget -O /tmp/openjdk-11+28_linux-x64_bin.tar.gz $JDK_URL

    # 解压压缩包
    tar -zxvf /tmp/openjdk-11+28_linux-x64_bin.tar.gz -C $JAVA_HOME --strip-components=1

    # 配置环境变量
    echo "export JAVA_HOME="$JAVA_HOME"" >> ~/.bashrc
    echo "export PATH="$PATH:$JAVA_HOME/bin"" >> ~/.bashrc

    # 验证是否安装成功
    $JAVA_HOME/bin/java -version

    echo "Java安装完成。"
}

echo "OS_TYPE: $OS_TYPE"
echo "ARCH: $ARCH"
echo "Please select the software to be installed:"
echo "1. golang"
echo "2. docker"
echo "3. miniconda"
echo "4. nodejs"
echo "5. java"
echo "6. all"
echo "Please enter the number of the software to be installed:"
read -ra READ_NUM

for element in "${READ_NUM[@]}"; do
  if [[ "$element" == "6" ]]; then
    install_golang
    install_docker
    install_miniconda
    install_nodejs
    break
  elif [[ "$element" == "5" ]]; then
    install_java
  elif [[ "$element" == "4" ]]; then
    install_nodejs
  elif [[ "$element" == "3" ]]; then
    install_miniconda
  elif [[ "$element" == "2" ]]; then
    install_docker
  elif [[ "$element" == "1" ]]; then
    install_golang
  else
    echo "Unsupported software"
    exit 1
  fi
done

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/miniconda/bin
export PATH=$PATH:/usr/local/node-v18.14.2/bin
export JAVA_HOME=$JAVA_HOME
export PATH=$PATH:$JAVA_HOME/bin
source ~/.bashrc