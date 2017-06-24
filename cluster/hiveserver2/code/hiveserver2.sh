#!/bin/bash
HIVE_HOME=/usr/local/hive
PATH="/sbin:/usr/sbin:/bin:/usr/bin:$HIVE_HOME/bin/"
export PATH

CONF_DIR=$HIVE_HOME/conf
LOG_DIR=/data/hive/logs

start_daemon(){
    TIMEOUT=5
    name=$1
    cmd=$2
    PID="$LOG_DIR/${name}.pid"
    if test -r $PID; then
        if kill -0 `cat $PID` > /dev/null 2>&1; then
            echo "start $name: command running as process `cat $PID`.  Stop it first."
        else
            rm $PID*
            echo "start $name: pid file error, please try again!"
        fi
    else 
        daemon_cmd="${cmd} > $LOG_DIR/${name}.log 2>&1 &"
        cmd_pid=""
	    loop=$TIMEOUT
	    force=1
	    while [ $loop -gt 0 ];do
            if kill -0 $cmd_pid > /dev/null 2>&1; then 
	            echo $cmd_pid > $PID
	            force=0
                break
	        else
                eval $daemon_cmd
                cmd_pid=$!
	    	    sleep 3
	    	    loop=`expr $loop - 1`
	        fi
	    done
	    if [ $force -eq 0 ]; then
	        echo "start $name: Success."
	    else
	        echo "start $name: Timeout."
	        #exit 1
        fi
    fi
}
stop_daemon(){
    TIMEOUT=10
    name=$1
    PID="$LOG_DIR/${name}.pid"
    if test -r $PID;then
        if kill -0 `cat $PID` > /dev/null 2>&1;then
	    loop=$TIMEOUT
	    force=1
	    while [ $loop -gt 0 ];do
            if kill -0 `cat $PID` > /dev/null 2>&1;then
                kill -9 `cat $PID`
                sleep 1
    	        loop=`expr $loop - 1`
	        else
                force=0
		        rm $PID
                break
	        fi
	    done
	    if [ $force -eq 0 ]; then
	        echo "stop $name: Success."
	    else
	        echo "stop $name: Timeout."
	        #exit 1
            fi
        else
            rm $PID*
            echo "stop $name: pid file error, please try again!"
        fi
    else
        echo "stop $name: No pid file found."
        #exit 1
    fi    
}
status_daemon(){
    name=$1
    PID="$LOG_DIR/${name}.pid"
    if test -r $PID;then
        echo "$name running. pid=`cat $PID`"
        return 0
    else
        echo "$name not running."
        return 1
    fi
}
init_hive() {
    mkdir -p $LOG_DIR
}
start_hive() {
    start_daemon hiveserver2 "hive --service hiveserver2"
    return $?
}
stop_hive() {
    stop_daemon hiveserver2
    return $?
}
status_hive(){
    status_daemon hiveserver2
    return $?
}
stop() {
    echo "Stoping hive... "
    stop_hive
    if [ $? -ne 0 ];then
        return 1;
    fi
}
start() {
    echo "Starting hive... "
    start_hive
    if [ $? -ne 0 ];then
        return 1;
    fi
}
status() {
    status_hive
    if [ $? -ne 0 ];then
        return 1;
    fi
}
init() {
    init_hive
    if [ $? -ne 0 ];then
        return 1;
    fi
}
case "$1" in
    start)
	start
	;;
    stop)
	stop
	;;
    restart)
	stop
	start
	;;
    init)
    init
    ;;
    status)
    status
    ;;
    *)
	echo $"Usage: $ {start|stop|restart|status|init}"
esac
