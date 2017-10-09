
# Zap Docker Setup

## Scan using the baseline scan

Build the docker image

	docker build . -t netcentric/zap-aem

Run the a ZAP scan against a target site.

	docker run --rm -v $(pwd):/zap/wrk/:rw \
	-t netcentric/zap-aem zap-baseline-custom.py -r report.html -d -m 5 \
	-t "https://public-firing-range.appspot.com/reflected/index.html" \
	--active_scan
