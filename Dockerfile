# Base image
FROM rockylinux:9

# Install required packages
RUN dnf install -y \
    openssh-server \
    python3 \
    sudo \
    net-tools \
    iproute \
    iputils \
    vim && \
    dnf clean all

# Configure SSH
RUN mkdir -p /var/run/sshd /root/.ssh && \
    ssh-keygen -A && \
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7i0JBlHdjUpcLn1kiY/IxWH8YT9WgADdP9Q0mlv1ik ansible" > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Expose SSH
EXPOSE 22

# Start SSH daemon
CMD ["/usr/sbin/sshd","-D"]

