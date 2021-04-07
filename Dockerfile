FROM fedora:latest

RUN dnf upgrade -y
RUN dnf install -y \
    wget \
    openssl \
    unzip 

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
chmod +x ./kubectl && \
mv ./kubectl /usr/local/bin/kubectl

RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | sh && \
ibmcloud config --check-version=false

WORKDIR /root
RUN wget https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
bash get-helm-3

WORKDIR /
RUN mkdir /scripts
COPY scripts/run.sh /scripts/run.sh

ENTRYPOINT ["/scripts/run.sh"]
