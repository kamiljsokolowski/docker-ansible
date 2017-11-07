# README.md
# Docker: Ansible

Ansible Docker images.

## Requirements
- [Docker](https://www.docker.com/get-docker): 17.09.0+    
*(optional)*    
- [VBox](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html): 5.1+
- [Vagrant](https://www.vagrantup.com/downloads.html): 1.9+

## Available OS platforms
- Ubuntu: 14.04,16.04    
*(comming soon)*    
- *RedHat/CentOS: 6,7*
- *Windows Sever 2016*

## Setup build env
**NOTE**: if running on a machine with Docker already installed, consider setting up Vagrant env as optional 
```
git clone ssh://git@scm-git-eur.misys.global.ad:7999/md/docker-ansible.git docker-ansible
cd docker-ansible
vagrant up
vagrant ssh
```

## Build
**NOTE**: commands found bellow are to be executed inside the build env
Default
```
docker build --no-cache=true -t ansible:ubuntu1604-2.3.0.0 -f ubuntu1604/Dockerfile .
```
Custom Ansible version.
```
docker build --no-cache=true --build-arg ansible_version=2.4.0.0 -t ansible:ubuntu1604-2.4.0.0 -f ubuntu1604/Dockerfile .
```

## Test
```
docker run -it ansible:ubuntu1604-2.3.0.0 /usr/local/bin/ansible all -i "localhost," -c local -m shell -a 'echo hello world'
```

## Push
```
docker login <registry>
docker tag ansible:ubuntu1604-2.3.0.0 <registry>/docker-ansible/ansible:ubuntu1604-2.3.0.0
docker push <registry>/docker-ansible/ansible:ubuntu1604-2.3.0.0
```

## Authors
Kamil Sokolowski (<kamil.sokolowski@misys.com>)
