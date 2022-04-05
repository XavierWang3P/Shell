#!/bin/sh

ip_1="192.168.154.186"
ip_2="192.168.154.187"
current_wan_ipaddr=$(ifconfig eth0.2 | grep 'inet addr:' | awk '{print $2}' | tr -d "addr:")
surf_internet_firefox=$(curl http://detectportal.firefox.com/success.txt)
judge_success_firefox="success"

# Online or not?
if [ "$surf_internet_firefox" = "$judge_success_firefox" ]; then
    echo "[Status] Online"
else
    echo "[Status] Offline"

    # Get current WAN IP
    if [ "$current_wan_ipaddr" = "$ip_1" ]; then
        sed -i "s/$ip_1/$ip_2/g" /etc/config/network
        /sbin/ifup wan
        echo "[Change IP] $ip_2"
    else
        sed -i "s/$ip_2/$ip_1/g" /etc/config/network
        /sbin/ifup wan
        echo "[Change IP] $ip_1"
    fi
    sleep 5

    # Login Internet
    curl -d '{Dr.com 登录参数}' http://dr.com/a30.html
    sleep 5
    
    # Online or not?
    surf_internet_microsoft=$(curl http://www.msftconnecttest.com/connecttest.txt)
    judge_success_microsoft="Microsoft Connect Test"
    if [ "$surf_internet_microsoft" = "$judge_success_microsoft" ]; then
        echo "[Login] Success"
    else
        echo "[Login] Failed"
    fi
fi