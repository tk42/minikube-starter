FROM ubuntu:latest

# https://qiita.com/yuichi1992_west/items/571016084c110d15320e

# Check OS version
RUN cat /etc/os-release

# Install kubectl
RUN sudo apt install curl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN sudo mv ./kubectl /usr/local/bin/kubectl
RUN kubectl version --client

# Install docker
RUN sudo apt update
RUN sudo apt install apt-transport-https ca-certificates software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN sudo apt update
RUN apt-cache policy docker-ce
RUN sudo apt install docker-ce
RUN systemctl status docker
RUN docker version
RUN sudo groupadd docker
RUN sudo usermod -aG docker ${USER}
RUN sudo systemctl restart docker

# Install Minikube
RUN curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
RUN chmod +x minikube
RUN sudo mkdir -p /usr/local/bin/
RUN sudo install minikube /usr/local/bin/

CMD ["minikube", "start", "--driver=docker"]
