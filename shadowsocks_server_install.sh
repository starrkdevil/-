# !/bin/bash
#this is a script to automately install shadowsocks



if [ `id -u` -eq 0 ]
then
    echo '[*] Updating...........'
    sleep 1
    #apt-get update
    echo '[*] Updating finished.Try to install some packages......'
    sleep 1 
    apt-get install python-setuptools m2crypto supervisor -y
    easy_install pip
    pip install shadowsocks
    echo '[*] Installing finished.Try to configure'
    sleep 1
    echo '{
    "server":"0.0.0.0",
    "server_port":8888,
    "local_port":1080,
    "password":"your_password",
    "timeout":600,
    "method":"rc4-md5"
    }'>>/etc/shadowsocks.json

    echo "[program:shadowsocks]
    command=ssserver -c /etc/shadowsocks.json
    autostart=true
    autorestart=true
    user=root
    log_stderr=true
    logfile=/var/log/shadowsocks.log">>/etc/supervisord.conf
    echo 'service supervisor start' >> /etc/rc.local
    /etc/init.d/supervisor start
    ssserver -c /etc/shadowsocks.json &
    echo 'finish'

else
    echo 'Please run this script with root'
    exit 0
fi


