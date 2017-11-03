#!/usr/bin/env bash
set -o xtrace
set -o verbose
set -o errexit
#set -o nounset

echo '### uninstall older versions of Docker Engine ###'
sudo apt-get remove --purge docker docker-engine docker.io || true

echo '### setup vmhost ###'
if [ grep -qi ubuntu /etc/lsb-release ] && [ grep -qi "14.04" /etc/lsb-release ]
then
    sudo apt-get update -q && sudo apt-get install -y \
        linux-image-extra-$(uname -r) \
        linux-image-extra-virtual
fi

echo '### install requirements ###'
sudo apt-get update -q && sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl

echo '### setup the Docker repository ###'
#sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
#    && echo "deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-$(lsb_release -c -s) main" |sudo tee -a /etc/apt/sources.list.d/docker.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

#echo '### load aufs module ###'
#echo "aufs" |sudo tee -a /etc/modules
#sudo modprobe aufs

echo '### install Docker ###'
#curl -sSL https://get.docker.com/ | sh
sudo apt-get update -q && sudo apt-get install -y \
    docker-ce

echo '### add user to "docker" group ###'
sudo groupadd docker || true
sudo usermod -aG docker $USER
#sudo DEFAULT_FORWARD_POLICY="DROP" -> "ACCEPT" /etc/default/ufw
#sudo ufw reload
#sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
#sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
#sudo update-rc.d docker.io defaults

