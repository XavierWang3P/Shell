#!/bin/sh

ip_1="192.168.154.186"
ip_2="192.168.154.187"
ip_3="192.168.154.190"
ip_4="192.168.154.191"

current_wan_ipaddr=$(uci show network.wan.ipaddr | awk -F '=' '{print $2}' | tr -d "'")
surf_internet_firefox=$(curl -i -s http://detectportal.firefox.com/success.txt | grep 'HTTP' | tr -d "A-Z1./" | tr -d " ")

# Online or not?
if [ $surf_internet_firefox -eq 200 ]; then
    echo "[Status] Online"
else
    echo "[Status] Offline"
    echo "[Current IP] $current_wan_ipaddr"

    # Get current WAN IP
    if [ "$current_wan_ipaddr" = "$ip_1" ]; then
        uci set network.wan.ipaddr=$ip_2
        uci commit network.wan.ipaddr
        echo "[Change IP] $ip_2"
       /sbin/ifup wan
    elif [ "$current_wan_ipaddr" = "$ip_2" ]; then
        uci set network.wan.ipaddr=$ip_3
        uci commit network.wan.ipaddr
        echo "[Change IP] $ip_3"
        /sbin/ifup wan
    elif [ "$current_wan_ipaddr" = "$ip_3" ]; then
        uci set network.wan.ipaddr=$ip_4
        uci commit network.wan.ipaddr
        echo "[Change IP] $ip_4"
        /sbin/ifup wan
    else
        uci set network.wan.ipaddr=$ip_1
        uci commit network.wan.ipaddr
        echo "[Change IP] $ip_1"
        /sbin/ifup wan
    fi

    sleep 3

    # Login Internet
    curl -s -o /dev/null -d '{Dr.com 登录参数}' http://dr.com/a30.html
    sleep 3

    # Send the notice
    notice_text='{"token":"pushplus Token","title":"断网啦断网啦","content":"'"${current_wan_ipaddr}"'","template":"json"}'
    curl -s -o /dev/null -H "Content-Type: application/json" -X POST -d "${notice_text}" https://www.pushplus.plus/send
    
    # Online or not?
    surf_internet_microsoft=$(curl -i -s  http://www.msftconnecttest.com/connecttest.txt | grep 'HTTP')
    if [ $surf_internet_microsoft -eq 200 ]; then
        echo "[Login] Success"
    else
        echo "[Login] Failed"
    fi
fi