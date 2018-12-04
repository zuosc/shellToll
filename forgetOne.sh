#echo "usage: host port nodeId"
echo 'forget ' $3
nodes_addrs=$(redis-cli -h $1 -p $2 cluster nodes|grep -v $3 | awk '{print $2}')
for addr in ${nodes_addrs[@]}; do
    host=${addr%:*}
    port=${addr#*:}
    echo '-' $host $port 
    redis-cli -h $host -p $port cluster forget $3
done
