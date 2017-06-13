#!/bin/bash
server=$1
if [ $# -lt 1 ];then
    echo error!
else
    ssh $server "passwd ubuntu"
    scp ../../app-agent-linux-amd64.tar.gz $server:/usr/local/ 
    ssh $server "tar -zxf /usr/local/app-agent-linux-amd64.tar.gz -C /usr/local"
    ssh $server "rm /usr/local/app-agent-linux-amd64.tar.gz"
    ssh $server "cd /usr/local/app-agent-linux-amd64; ./install.sh"
    ssh $server "rm -r /usr/local/mysql/data"

    scp ../../jar/S3/* $server:/usr/local/hadoop/share/hadoop/common/lib/
    scp ../../jar/mysql-connector-java-5.1.39-bin.jar $server:/usr/local/hive/lib/
    scp code/profile $server:/etc/
    scp -r code/conf.d $server:/etc/confd/
    scp -r code/templates $server:/etc/confd/
    scp code/hive-env.sh $server:/usr/local/hive/conf/
    scp code/hive_shell.sh $server:/usr/local/hive/
    scp code/my.cnf $server:/usr/local/mysql/
    scp code/mapred-site.xml $server:/usr/local/hadoop/etc/hadoop/
    scp code/mysql.tgz $server:/usr/local/mysql/
fi
