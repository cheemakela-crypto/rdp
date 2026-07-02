#!/bin/bash

# DBUS start karna
service dbus start

# Pulseaudio background mein chalana
pulseaudio -D --system --disallow-exit --disable-shm

# XRDP (Screen sharing server) on karna
service xrdp start

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Bore Tunnel start karna (Port 3389 ko internet par open karne ke liye)
echo "Starting Bore Tunnel for RDP (Port 3389)..."
bore local 3389 --to bore.pub > /var/log/bore.log 2>&1 &

# Thora intezar karke link print karna taake logs mein mil jaye
sleep 3
cat /var/log/bore.log

# Container ko band hone se rokne ke liye log stream
tail -f /var/log/xrdp-sesman.log
