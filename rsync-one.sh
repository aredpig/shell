#!/bin/bash

F_DIR='/home/weti/Git/docker/mdocker/rsync'
T_DIR='/home/weti/Git/docker/mdocker/temp'

NAME_BIN="rsync"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"

check_running(){
	PID="$(ps -C $NAME_BIN -o pid= |head -n1 |grep -o '[0-9]\{1,\}')"
	if [ ! -z ${PID} ]; then
		return 0
	else
		return 1
	fi
}

start(){
    if [[ -d "$F_DIR" && -d "$T_DIR" ]];then
        f_count=`ls $F_DIR |wc -w`
        if [ "$f_count" > "0" ];then
            rsync -av $F_DIR/* $T_DIR >> /dev/null 2>&1 &
        fi
        check_running
        if [ $? -eq 0 ];then
            echo -e "${Info} $NAME_BIN 启动成功 !"
        else
            echo -e "${Error} $NAME_BIN 启动失败 !"
        fi
        RETVAL=1            
    else
        echo -e "${Error} 目录不存在 启动失败 !"
        RETVAL=1
    fi
}
rm(){
    rm -r $F_DIR/* >> /dev/null 2>&1 &
    f_count=`ls $F_DIR |wc -w`
    if [ "$f_count" = "0" ];then
        echo -e "${Info} RM COMMAND 删除成功"
    else
        echo -e "${Error} RM COMMAND 删除失败"
    fi
    RETVAL=1
}

case "$1" in
	start|rm)
	$1
	;;
	*)
	echo "使用方法: $0 { start | rm }"
	RETVAL=1
	;;
esac
exit $RETVAL