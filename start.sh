#!/bin/bash

# DBUS start karna
service dbus start

# Pulseaudio background mein chalana
pulseaudio -D --system --disallow-exit --disable-shm

# XRDP (Screen sharing server) on karna
service xrdp start

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Bore Tunnel start karna (Main App ki Port 5000 ke liye)
echo "Starting Bore Tunnel for Main App (Port 5000)..."
bore local 5000 --to bore.pub > /var/log/bore.log 2>&1 &

# Thora intezar karke link print karna taake logs mein mil jaye
sleep 3
cat /var/log/bore.log

# Container ko band hone se rokne ke liye log stream
tail -f /var/log/xrdp-sesman.log
