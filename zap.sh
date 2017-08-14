#/bin/bash

############
# Execute and run preconfigured zap baseline scans using zap2docker 
# 
# 
###########

DOCKER_IMAGE="owasp/zap2docker-weekly"
HOST_PORT="8888"
CONTAINER_PORT="2375"

function zapexperimental(){
	COMMAND="-config api.disablekey=true \ 
		-config scanner.attackOnStart=true \
		-config view.mode=attack \
		-config connection.dnsTtlSuccessfulQueries=-1 \
		-config api.addrs.addr.name=.* \
		-config api.addrs.addr.regex=true"

	echo $(docker run -u zap -p $HOST_PORT:$CONTAINER_PORT -d $DOCKER_IMAGE zap.sh -daemon -port $HOST_PORT -host 127.0.0.1 $COMMAND)
}
#docker run -u zap -p 8080:8080 -i owasp/zap2docker-stable zap-x.sh -daemon -host 0.0.0.0 -port 8080

function zap(){
	ARGUMENTS="-i owasp/zap2docker-stable \
		zap-x.sh -daemon -host 0.0.0.0 -port 8080"
 	echo $(docker run -u zap -p 8080:8080 $ARGUMENTS)
}


function info(){
	echo "Usage: `basename $0` {run}"
}



case "$1" in
	run)
		CONTAINERID=$(zap)
		echo "run"
		;;
	*)
        info
        exit 1
        ;;
esac