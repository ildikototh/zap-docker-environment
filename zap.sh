#/bin/bash

############
# Executes and runs a preconfigured zap baseline scan 
# using zap2docker (based on the ictu selenium enabled docker project).
###########

IMAGE_NAME='netcentric/zap-aem'
HOST_PORT="44444"
CONTAINER_PORT=$HOST_PORT
BASELINESCRIPT="zap-baseline-custom.py"
TARGET1="http://www.webscantest.com/"
TARGET2="https://public-firing-range.appspot.com/reflected/index.html"


function dockerid(){
	echo $(docker ps | grep -e $IMAGE_NAME -e "Up" | awk '{print $1}')
}

function zapBaselineFull(){
	#ARGUMENTS="--rm -v $(pwd):/zap/wrk/:rw -t $IMAGE_NAME $BASELINESCRIPT -r report.html -g rule.conf -d -m 5 -t http://localhost:6201 --active_scan"
 	#echo $(docker run $ARGUMENTS)
 	docker run --rm -v $(pwd):/zap/wrk/:rw -t $IMAGE_NAME zap-full-scan.py -r report.html -g base.conf -d -m 1 -a -t TARGET1
}

function zapBaseline(){
	#ARGUMENTS="--rm -v $(pwd):/zap/wrk/:rw -t $IMAGE_NAME $BASELINESCRIPT -r report.html -g rule.conf -d -m 5 -t http://localhost:6201 --active_scan"
 	#echo $(docker run $ARGUMENTS)
 	docker run --rm -v $(pwd):/zap/wrk/:rw -t $IMAGE_NAME $BASELINESCRIPT -r report.html -g base.conf -d -m 1 -a -t TARGET1
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
	fullscan)
		#CONTAINERID=$(zap)
		#echo "running $CONTAINERID"
		echo "$(zapBaselineFull)"
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