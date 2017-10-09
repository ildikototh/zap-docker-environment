#/bin/bash

############
# Executes and runs a preconfigured zap baseline scan 
# using zap2docker (based on the ictu selenium enabled docker project).
###########

IMAGE_NAME='netcentric/zap-aem'
HOST_PORT="44444"
CONTAINER_PORT=$HOST_PORT
BASELINESCRIPT="zap-baseline-custom.py"


function dockerid(){
	echo $(docker ps | grep -e $IMAGE_NAME -e "Up" | awk '{print $1}')
}

function zapBaseline(){
	#ARGUMENTS="--rm -v $(pwd):/zap/wrk/:rw -t $IMAGE_NAME $BASELINESCRIPT -r report.html -g rule.conf -d -m 5 -t http://localhost:6201 --active_scan"
 	#echo $(docker run $ARGUMENTS)
 	docker run --rm -v $(pwd):/zap/wrk/:rw -t $IMAGE_NAME $BASELINESCRIPT -r report.html -g base.conf -d -m 5 -t "https://public-firing-range.appspot.com/reflected/index.html" --active_scan
}

function zapPlain(){
	docker run -u zap -p 9999:9999 -i $IMAGE_NAME zap-x.sh -daemon -host 0.0.0.0 -port 9999 -addoninstallall -config api.disablekey=true -config api.incerrordetails=true
}
function info(){
	echo "Usage: `basename $0` {run}"
}

case "$1" in

	build)
		docker build . -t $IMAGE_NAME
		;;
	scan)
		#CONTAINERID=$(zap)
		#echo "running $CONTAINERID"
		echo "$(zapBaseline)"
		;;
	run)
		#CONTAINERID=$(zap)
		#echo "running $CONTAINERID"
		echo "$(zapPlain)"
		;;
	bash)
		RUNNING_CONTAINER_ID=$(dockerid)
		docker exec -it $RUNNING_CONTAINER_ID bash
		;;
	log)
		RUNNING_CONTAINER_ID=$(dockerid)
		docker logs -f $RUNNING_CONTAINER_ID
		;;
	*)
        info
        exit 1
        ;;
esac