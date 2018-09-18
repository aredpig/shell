#!/bin/bash

start(){
    mkdir -p /swap && cd $_
    dd if=/dev/zero of=/swap/swapfile bs=1M count=$1 >/dev/null 2>&1
    mkswap /swap/swapfile > /dev/null 2>&1
    swapon /swap/swapfile
    free -m

    FSTABFLAG="$(grep '/swap/swapfile' /etc/fstab)"
    if [ FSTABFLAG ];then
        echo "/swap/swapfile   swap    swap    defaults 0   0" >>/etc/fstab
    fi

    SWAPFLAG="$(cat /proc/sys/vm/swappiness)"
    if [ SWAPFLAG = "10" ];then
        break
    else
        sysctl vm.swappiness=10 >/dev/null 2>&1
        echo "vm.swapiness=10" >> /etc/sysctl.conf
    fi
}

stop(){
    swapoff /swap/swapfile
    rm -r /swap/swapfile
    FSTABFLAG="$(grep '/swap/swapfile' /etc/fstab)"
    if [ -n FSTABFLAG ];then
        sed -i "/^\/swap\/swapfile/d" /etc/fstab
    fi
    free -m
}

case "$1" in
	start)
	$1 $2
    ;;
    stop)
    $1
	;;
	*)
	echo "使用方法: $0 { start | stop }"
	RETVAL=1
	;;
esac
exit 0