#!/bin/bash

echo "Removing old docker installations"
sudo apt-get remove docker docker-engine docker.io containerd runc \
	&& echo "Success" || echo "Failure"

echo "Setting up Repository"
sudo apt-get update || echo "Problem updating repositories"
sudo apt-get install apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common \
	|| echo "Problem installing dependencies"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
	|| echo "Problem adding gpg key"
sudo apt-get fingerprint 0EBFCD88 && "Success" || echo "Failure"

echo "Adding Repository"
sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable" \
	&& echo "Success" || echo "Failure"

echo "Installing Docker Engine"
sudo apt-get update || echo "Problem updating Repositories"
sudo apt-get install docker-ce docker-ce-cli containerd.io \
	&& echo "Success" || echo "Failure"

echo "Verify installation"
sudo docker run hello-world && echo "Success" || echo "Failure"

echo "Add docker sudo privileges"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

echo "Verify privileges"
docker run hello-world && echo "Success" || echo "Failure"

echo "Docker image cleanup"
docker system prune -a -f

echo "Install Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose -v && echo "Success" || echo "Failure"
