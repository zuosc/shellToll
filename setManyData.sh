for (( ; ; ))
do
   uuid=$(uuidgen)
   echo $uuid
   redis-cli -c -h 10.100.45.31 -p 10854 set $uuid $uuid
done
