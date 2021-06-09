FROM gitpod/workspace-full

# Install custom tools, runtime, etc.
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    sudo apt-get install -y apt-transport-https ca-certificates gnupg && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    sudo apt-get update && sudo apt-get install -y google-cloud-sdk && \
    $ curl -sSL https://cli.openfaas.com | sudo -E sh && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm -rf kubectl

ENV KUBECONFIG $HOME/.kube/kubeconfig.yml