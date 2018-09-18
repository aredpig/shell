#!/bin/sh

PID="$(ps -C rsync -o pid= |head -n1 |grep -o '[0-9]\{1,\}')"
echo $PID
if [ ! -z ${PID} ];then
    echo "0"
else
    echo "1"
fi
