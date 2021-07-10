FROM ubuntu:latest

ENV KOMPOSE_VERSION=v1.22.0

# Check OS version
RUN cat /etc/os-release

# Install kubectl
RUN apt update
RUN apt install -y curl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN kubectl version --client

# Install docker
RUN apt update
RUN apt install -y apt-transport-https ca-certificates software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN apt update
RUN apt-cache policy docker-ce
RUN apt install -y docker-ce

RUN groupadd docker || exit 0
RUN usermod -aG docker root

# Install Minikube
RUN curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
RUN chmod +x minikube
RUN mkdir -p /usr/local/bin/
RUN install minikube /usr/local/bin/

# Install Kompose
RUN curl -L https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-amd64 -o kompose
RUN chmod +x kompose
RUN mv ./kompose /usr/local/bin/kompose

CMD ["minikube", "start", "--driver=docker"]
