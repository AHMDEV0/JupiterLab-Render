# Use the latest Ubuntu image
FROM ubuntu:latest

# Update and install required packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openssh-server \
    sudo \
    curl \
    git \
    lsb-release \
    vim

# Set the working directory
WORKDIR /app

# Install JupyterLab
RUN pip3 install jupyterlab

# Configure SSH
RUN mkdir /var/run/sshd \
    && echo 'root:Docker!' | chpasswd \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo 'AllowUsers root' >> /etc/ssh/sshd_config

# Expose ports for SSH (22) and JupyterLab (443)
EXPOSE 22 443

# Start SSH and JupyterLab on port 443
CMD service ssh start && jupyter lab --ip=0.0.0.0 --port=443 --no-browser --allow-root --NotebookApp.token=''
