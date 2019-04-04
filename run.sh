#!/bin/bash
# author:zsc

set -e

name="修改下"
findfile=""
if [ ! -n "$1" ]
then
        echo "寻找最新的jar包...";
        findfile=$(ls -t $name-*.jar | head -1)
	if [ "$findfile" == "" ]
        then
                echo "******没有查找到需要的jar包******"
        else
                echo "查找到最新的包文件： $findfile，开始执行..."
        fi
else
        echo "输入的版本为：$1"
        echo "开始查找指定版本的jar包..."
        verfile="$name-"$1".jar"
        findfile=$(find . -name $verfile)
        if [ $findfile == "" ]
        then
                echo "未查找到文件:$verfile"
        else
                echo "查找到指定版本的文件：$findfile,开始执行..."
        fi
fi


if [ "$findfile" != ""  ]
then
        echo "开始删除旧的软连接..."
        rm -rf $name.jar

        echo "删除完成，创建 $findfile 的软连接"
        ln -s $findfile $name.jar

        echo "创建新软连接完成 "
	if [ ! "$(docker ps -q -f name=$name)" ]; then
                echo "容器 $name 不存在，创建该容器..."
                docker run -d --net=host --name=$name -v /data/app/$name:/data docker.17usoft.com/cache/openjdk:11.0.1-jdk /bin/bash -c "cd /data;\
				java \
				-Xms4G \
				-Xmx4G \
				-server \
				-XX:+UseNUMA \
				-XX:+UnlockExperimentalVMOptions \
				-XX:+UseZGC \
				-XX:+AggressiveOpts \
				-Dvertx.disableMetrics=true \
				-Dvertx.disableH2c=true \
				-Dvertx.disableWebsockets=true \
				-Dvertx.flashPolicyHandler=false \
				-Dvertx.threadChecks=false \
				-Dvertx.disableContextTimings=true \
				-Dvertx.disableTCCL=true \
				-Dvertx.disableHttpHeadersValidation=true \
				-jar  $name.jar"
                echo "启动容器 $name 成功！"
        else
                echo "容器 $name 已经存在，重启容器..."
                docker restart $name
                echo "重启 $name 成功..."
        fi
        echo "执行结束!"
else
        echo "执行结束..."
fi

