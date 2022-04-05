#!/bin/sh

ip_1="192.168.154.186"
ip_2="192.168.154.187"
ip_3="192.168.154.190"
ip_4="192.168.154.191"
current_wan_ipaddr=$(nvram get wan_ipaddr)
surf_internet_firefox=$(curl -i -s http://detectportal.firefox.com/success.txt | grep 'HTTP' | tr -d "A-Z1./" | tr -d " ")

# Online or not
if [ "$surf_internet" = "$judge_success" ]; then
    logger -t "[Status]" "Online"
else
    logger -t "[Status]" "Offline"

    # Get current WAN IP
    if [ "$current_wan_ipaddr" = "$ip_1"  ]; then
        logger -t "[Change IP]" "$ip_2"
        nvram set wan_ipaddr=$ip_2
        restart_wan
    elif [ "$current_wan_ipaddr" = "$ip_2"  ]; then
        logger -t "[Change IP]" "$ip_3"
        nvram set wan_ipaddr=$ip_3
        restart_wan
    elif [ "$current_wan_ipaddr" = "$ip_3"  ]; then
        logger -t "[Change IP]" "$ip_4"
        nvram set wan_ipaddr=$ip_4
        restart_wan
    else
        logger -t "[Change IP]" "$ip_1"
        nvram set wan_ipaddr=$ip_1
        restart_wan
    fi
    sleep 3

    # Login Internet
    curl -d '{Dr.com 登录参数}' http://dr.com/a30.html
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