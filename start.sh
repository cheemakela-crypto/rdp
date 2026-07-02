#!/bin/bash

service dbus start

# Pulseaudio ka error fix kiya (--start ki jagah -D)
pulseaudio -D --system --disallow-exit --disable-shm
service xrdp start

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# --- BORE TUNNEL START KARNA ---
echo "Starting Bore Tunnel for RDP (Port 3389)..."
# Yeh command port 3389 ko internet par open kar degi
bore local 3389 --to bore.pub > /var/log/bore.log 2>&1 &

# Thora intezar karein aur link print karein
sleep 3
cat /var/log/bore.log

tail -f /var/log/xrdp-sesman.log
