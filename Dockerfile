# Base image ko Debian se Ubuntu latest mein update kar diya gaya hai
FROM ubuntu:latest 

# Installation ke doran aane wale prompts ko rokne ke liye
ENV DEBIAN_FRONTEND=noninteractive 

# Wine 32-bit ke liye architecture add karna
RUN dpkg --add-architecture i386 

# Packages install karna (firefox-esr ki jagah ubuntu ka default firefox aur zaroori dependencies add ki hain)
RUN apt update && apt install -y \
    software-properties-common \
    xrdp \
    xfce4 \
    xfce4-goodies \
    xorg \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    policykit-1 \
    pulseaudio \
    pulseaudio-utils \
    wine \
    wine32 \
    firefox && \
    apt clean && rm -rf /var/lib/apt/lists/* 

# Root password set karna (root:root)
RUN echo "root:root" | chpasswd 

# X11 aur session files ki configuration
RUN sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config || echo "allowed_users=anybody" >> /etc/X11/Xwrapper.config 
RUN echo "startxfce4" > /root/.xsession && chmod 700 /root/.xsession 

# DBUS ke liye machine-id generate karna
RUN mkdir -p /var/run/dbus && dbus-uuidgen > /var/lib/dbus/machine-id 

# XRDP ki security settings update karna (encryption low aur rdp security layer)
RUN sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini && \
    echo "exec startxfce4" > /etc/xrdp/startwm.sh && chmod +x /etc/xrdp/startwm.sh 

# xrdp user ko ssl-cert group mein add karna
RUN adduser xrdp ssl-cert 

# Start script copy karna aur permissions dena
COPY start.sh /start.sh 
RUN chmod +x /start.sh 

# RDP port open karna
EXPOSE 3389 

CMD ["/start.sh"]