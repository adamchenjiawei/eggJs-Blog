# start eggjs project

PROJECT_PATH=/Users/adam/Documents/private_repo/egg-example
PROC_NAME="EggExample"
NODE_PORT=8000


start() {
	cd "${PROJECT_PATH}"
	PORT=${NODE_PORT} EGG_SERVER_ENV=prod nohup node index.js --${PROC_NAME} > stdout.log 2> stderr.log &

	proc_id=`ps -ef | grep -i ${PROC_NAME} | grep -v "grep"|awk '{print $2}'`
    echo '---------deployed'
	echo ${PROC_NAME} "pid: "
	echo $proc_id
}

stop() {
	proc_id=`ps -ef | grep -i ${PROC_NAME} | grep -v "grep"|awk '{print $2}'`
	if [[ -z $proc_id ]]; then
		echo "The Task is not running!"
	else
		echo ${PROC_NAME}" pid: "
		echo $proc_id
		echo "-------kill the task"
		for id in ${proc_id[*]}
        do
        	echo ${id}
        	thread=`ps -mp ${id}|wc -l`
        	echo "theads number: "${thread}
        	kill ${id}
        if [ $? -eq 0 ]; then
        	echo "task is killed..."
        else
            echo "kill task failed"
        fi
	    done
	fi
}


case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
 restart|reload)
        stop
        start
        ;;
  *)
        echo "Usage: $0 {start|stop|restart|reload}"
        ;;
esac