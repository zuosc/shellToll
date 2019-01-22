#!/bin/sh
#echo "usage: host port  ip/ip:port "

if [[ ! -n "$1" ]] || [[ ! -n "$2" ]] || [[ ! -n "$3" ]]; then
    echo "参数不合法！"
    exit 2   
else
    echo "start..."  
fi

all_count=$(redis-cli -h $1 -p $2 client list| awk 'END{print NR}')
target_count=$(redis-cli -h $1 -p $2 client list| awk '$2 ~ /'''$3'''/'| awk 'END{print NR}')

echo "该redis共有$all_count个客户端，其中目标客户端共有$target_count个，是否进行kill？(y/n)"
read answer
if [ "$answer" == "y" ]; then
    list=$(redis-cli -h $1 -p $2 client list| awk '$2 ~ /'''$3'''/'| awk '{print substr($2,6)}')

    for item in ${list[@]}; do
    redis-cli -h $1 -p $2 client kill  $item
    echo "kill client $item"
    done

    echo "Done"
    exit
else
    echo "告辞！"
    exit
fi
