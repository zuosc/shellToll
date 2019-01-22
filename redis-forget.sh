#!/bin/sh
#echo "usage: host port  ip:port "

if [[ ! -n "$1" ]] || [[ ! -n "$2" ]] || [[ ! -n "$3" ]]; then
  echo "参数不合法！"
  exit 2
elif [[ $3 =~ ":" ]]; then
  echo "start..."   
else
  echo "要遗忘的IP_Port不合法！"
  exit 2 
fi



nodes_addrs=$(redis-cli -h $1 -p $2 cluster nodes| awk '{print $2}')
echo -e "获取到集群Node节点信息：\n$nodes_addrs\n"
for addr in ${nodes_addrs[@]}; do
    host=${addr%:*}
    port=${addr#*:}
    ip_port=$host:$port

    if [ "${ip_port%@*}" == "$3" ]
    then 
        echo "pass"
    else
        forget_nodeids=$(redis-cli -h $host -p $port cluster nodes|grep -E $3 | awk '{print $1}')
        echo "从节点$host:$port forget nodeId: $forget_nodeids"
        redis-cli -h $host -p $port cluster forget $forget_nodeids
    fi
done