
# Zap Docker Setup

## Scan using the baseline scan

Build the docker image

	docker build . -t netcentric/zap-aem

Run the a ZAP scan against a target site.

	docker run --rm -v $(pwd):/zap/wrk/:rw \
	-t netcentric/zap-aem zap-baseline-custom.py -r report.html -d -m 5 \
	-t "https://public-firing-range.appspot.com/reflected/index.html" \
	--active_scan


 docker run --rm -v $(pwd):/zap/wrk/:rw -t netcentric/zap-aem zap-baseline-custom.py -r report.html -g base.conf -d -m 5 -t "https://public-firing-range.appspot.com/reflected/index.html" --active_scan
=======
# zap-docker-environment

A zap docker environment for quickly ramping up the baseline scan to a dedicated environment with a minimum of manual configuration effort

!!!Currently early work in progress!!!