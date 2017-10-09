import getopt
import json
import logging
import os
import os.path
import sys
import time
import urllib2
from datetime import datetime
from zapv2 import ZAPv2
from zap_common import *

def main(argv):
    
    zap_ip = 'localhost'
    zap_options = ''
    port = 9999
    target = 'https://public-firing-range.appspot.com/reflected/index.html'
    delay=5
    detailed_output=True

    logging.debug('Using host: ' + zap_ip)
    logging.debug('Using port: ' + str(port))
    zap = ZAPv2(proxies={'http': 'http://' + zap_ip + ':' + str(port), 'https': 'http://' + zap_ip + ':' + str(port)})

    # Access the target
    res = zap.urlopen(target)
    if res.startswith("ZAP Error"):
        # errno.EIO is 5, not sure why my atempts to import it failed;)
        raise IOError(5, 'Failed to connect')

    if target.count('/') > 2:
        # The url can include a valid path, but always reset to spider the host
        target = target[0:target.index('/', 8)+1]

    time.sleep(2)
    
    # Spider target
    zap_spider(zap, target)

    if (delay):
        start_scan = datetime.now()
        while ((datetime.now() - start_scan).seconds < delay):
            time.sleep(5)
            logging.debug('Delay active scan ' + str(delay -(datetime.now() - start_scan).seconds) + ' seconds')

    # Print out a count of the number of urls
    num_urls = len(zap.core.urls)
    if num_urls == 0:
        logging.warning('No URLs found - is the target URL accessible? Local services may not be accessible')
    else:
        if detailed_output:
            print('Total of ' + str(num_urls) + ' URLs')

if __name__ == "__main__":
    main(sys.argv[1:])