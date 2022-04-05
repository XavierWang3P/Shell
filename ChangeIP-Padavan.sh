#!/bin/sh

ip_1="192.168.154.190"
ip_2="192.168.154.189"
current_wan_ipaddr=$(nvram get wan_ipaddr)
surf_internet=$(curl http://detectportal.firefox.com/success.txt)
judge_success="success"

# 判断是否在线
if [ "$surf_internet" = "$judge_success" ]; then
    logger -t "【当前状态】" "在线"
else
    logger -t "【当前状态】" "已掉线"

    # 获取当前 WAN IP
    if [ "$current_wan_ipaddr" = "$ip_1" ]; then
        nvram set wan_ipaddr=$ip_2
        restart_wan
        logger -t "【更改 IP】" "$ip_2"
    else
        nvram set wan_ipaddr=$ip_1
        restart_wan
        logger -t "【更改 IP】" "$ip_1"
    fi
    sleep 3

    # 登录校园网
    curl -d '{Dr.com 登录参数}' http://dr.com/a30.html
    sleep 3
    
    # 判断是否登录成功
    if [ "$surf_internet" = "$judge_success" ]; then
        logger -t "【登录校园网】" "成功"
    else
        logger -t "【登录校园网】" "失败"
    fi
fi