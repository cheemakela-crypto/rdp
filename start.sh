#!/bin/bash

service dbus start
pulseaudio --start --system --disallow-exit --disable-shm
service xrdp start

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# --- NGROK KO START KARNE KA SYSTEM ---
if [ ! -z "$NGROK_AUTHTOKEN" ]; then
    ngrok config add-authtoken $NGROK_AUTHTOKEN
    ngrok tcp 3389 --log=stdout > /var/log/ngrok.log &
fi

tail -f /var/log/xrdp-sesman.log
