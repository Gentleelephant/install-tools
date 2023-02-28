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

echo "OS_TYPE: $OS_TYPE"
echo "ARCH: $ARCH"
echo "Please select the software to be installed:"
echo "1. golang"
echo "2. docker"
echo "3. miniconda"
echo "4. all"
echo "Please enter the number of the software to be installed:"
read -ra READ_NUM

for element in "${READ_NUM[@]}"; do
  if [[ "$element" == "4" ]]; then
    install_golang
    install_docker
    install_miniconda
    break
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
source ~/.bashrc