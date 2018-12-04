#echo "usage: host port pwd"

pwd='\''\'
if  [ ! -n "$3" ] ;then
    echo "not input pwd"
else
    pwd=$3
fi

addrs=$(redis-cli -h $1 -p $2 -a $pwd client list | awk '{print $2}'  | cut -d "=" -f 2)
for addr in ${addrs[@]}; do
    redis-cli -h $1 -p $2 -a $pwd client kill  $addr
    echo 'kill client ' $addr
done
