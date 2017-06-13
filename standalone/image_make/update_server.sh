#!/bin/bash
server=$1
if [ $# -lt 1 ];then
    echo error!
else
    scp ../code/hive_shell.sh $server:/usr/local/hive/
    scp ../code/my.cnf $server:/usr/local/mysql/
    scp ../code/mapred-site.xml $server:/usr/local/hadoop/etc/hadoop/
    scp -r ../code/conf.d $server:/etc/confd/
    scp -r ../code/templates $server:/etc/confd/
    scp ../code/mysql.tgz $server:/usr/local/mysql/
    scp ../../app-agent.tar.gz $server:/usr/local/ 
fi
