# Ubuntu 22.04 base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Wine 32-bit ke liye architecture add karna
RUN dpkg --add-architecture i386

# Packages install karna
RUN apt update && apt install -y \
    software-properties-common \
    xrdp \
    lxde-core \
    lxterminal \
    xorg \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    polkitd \
    pkexec \
    pulseaudio \
    pulseaudio-utils \
    wine \
    wine32 && \
    apt clean && rm -rf /var/lib/apt/lists/*

# --- BORE INSTALLATION (Ngrok ki jagah) ---
RUN wget https://github.com/ekzhang/bore/releases/download/v0.5.1/bore-v0.5.1-x86_64-unknown-linux-musl.tar.gz && \
    tar -xf bore-v0.5.1-x86_64-unknown-linux-musl.tar.gz && \
    mv bore /usr/local/bin/ && \
    rm bore-*.tar.gz

# Root password set karna
RUN echo "root:root" | chpasswd

# X11 permissions
RUN sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config || echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config

# XRDP ko batana ke XFCE ki badle LXDE start karna hai
RUN echo "lxsession -s LXDE -e LXDE" > /root/.xsession && chmod 700 /root/.xsession

# DBUS machine-id generate karna
RUN mkdir -p /var/run/dbus && dbus-uuidgen > /var/lib/dbus/machine-id

# XRDP Security aur Startup settings
RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini && \
    echo "exec startlxde" > /etc/xrdp/startwm.sh && chmod +x /etc/xrdp/startwm.sh

# xrdp user ko ssl-cert group mein add karna
RUN adduser xrdp ssl-cert

# Start script copy karna
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Port 3389 expose karein (RDP)
EXPOSE 3389
# Mobile App connect karne ke liye extra port (Railway TCP proxy ke liye)
EXPOSE 5000

CMD ["/start.sh"]
