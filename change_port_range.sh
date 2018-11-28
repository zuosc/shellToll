#!/bin/bash
function echo_blue {
        echo -e "\033[36m$1\033[0m"
}

function checkandshow_sysctl_setting(){
    grep -E $1 /etc/sysctl.conf >> /dev/null
    if [ $? -eq 0 ];then
        range=$(grep -n $1 /etc/sysctl.conf | cut -d "=" -f2)
        echo -e "  $1 = ${range}"        
    else
        echo -e "在/etc/sysctl.conf中没有$1配置项."
        exit 1
    fi
}

cd /etc/
echo '>>当前工作目录：' `pwd`
echo '当前配置参数为：'
checkandshow_sysctl_setting net.ipv4.ip_local_port_range
checkandshow_sysctl_setting net.ipv4.ip_local_reserved_ports

echo_blue 即将修改该配置为：
echo_blue '  net.ipv4.ip_local_port_range = 30000 65535  \n  net.ipv4.ip_local_reserved_ports = 31313,10000-29999'
echo_blue "是否进行修改？(y/n)"
read answer
if [ "$answer" == "y" ]; then
    sed -i '/^net.ipv4.ip_local_port_range*/d' /etc/sysctl.conf
        sed -i '/^net.ipv4.ip_local_reserved_ports*/d' /etc/sysctl.conf
        echo net.ipv4.ip_local_port_range = 30000 65535 >> /etc/sysctl.conf
    echo net.ipv4.ip_local_reserved_ports = 31313,10000-29999 >> /etc/sysctl.conf
    /sbin/sysctl -p /etc/sysctl.conf 
    echo_blue "Done"
else
    echo_blue "告辞！"
    exit
fi
