#!/bin/bash
set -e


install_golang(){
   read -p "Please enter the golang version to be installed(default 1.20.1):" VERSION

   if [ -z $VERSION ]; then
     VERSION=1.20.1
   fi

   URL=https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz
   INSTALL_DIR=/usr/local
   wget $URL
   sudo tar -C ${INSTALL_DIR} -xzf go${VERSION}.linux-amd64.tar.gz
   echo "export PATH=\$PATH:${INSTALL_DIR}/go/bin" >> /etc/profile
   source /etc/profile
   rm -rf go${VERSION}.linux-amd64.tar.gz
   go version
   echo "Golang installed!"
}

install_docker(){

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

install_miniconda(){

   OS_TYPE=$(uname -s)
   PYTHON310=https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh
   PYTHON39=https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh
   PYTHON38=https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh
   PYTHON37=https://repo.anaconda.com/miniconda/Miniconda3-py37_23.1.0-1-Linux-x86_64.sh
   MINICONDA_URL=$PYTHON39
   read -p "Please enter the python version to be installed(default 3.9):" READ_VERSION

   if [ -z $READ_VERSION ]; then
     READ_VERSION="3.9"
   fi

    if [[ "$OS_TYPE" == "Linux" ]]; then
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
  #elif [ $OS_TYPE == "Darwin" ]; then
  #  MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-py39_${MINICONDA_VERSION}-MacOSX-x86_64.sh
  #else
  #  echo "Unsupported operating system"
  #  exit 1
   fi
   curl -O $MINICONDA_URL
   MINICONDA_FILE=$(basename "$MINICONDA_URL")
   sh $MINICONDA_FILE -b -p /usr/local/miniconda
   echo 'export PATH="/usr/local/miniconda/bin:$PATH"' >> /etc/profile
   source /etc/profile
   conda --version
   echo "Miniconda installed!"
   rm -rf $MINICONDA_FILE
}

source /etc/profile

if command -v go >/dev/null 2>&1; then
  echo "golang already exists!Skin golang installation"
else
  install_golang
fi


if command -v docker >/dev/null 2>&1; then
  echo "docker already exists!Skin docker installation"
else
  install_docker
fi


if command -v conda >/dev/null 2>&1; then
  echo "miniconda already exists!Skin miniconda installation"
else
  install_miniconda
fi



