FROM owasp/zap2docker-stable
MAINTAINER Thomas Hartmann <thomas@netcentric.biz>


USER root

# Install Selenium compatible firefox
RUN apt-get -y remove firefox

RUN cd /opt && \
	wget https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz && \
	tar -xvzf geckodriver-v0.18.0-linux64.tar.gz && \
	chmod +x geckodriver && \
	ln -s /opt/geckodriver /usr/bin/geckodriver && \
	export PATH=$PATH:/usr/bin/geckodriver


RUN cd /opt && \
	wget http://ftp.mozilla.org/pub/firefox/releases/56.0b2/linux-x86_64/en-US/firefox-56.0b2.tar.bz2 && \
	bunzip2 firefox-56.0b2.tar.bz2 && \
	tar xvf firefox-56.0b2.tar && \
	ln -s /opt/firefox/firefox /usr/bin/firefox


RUN pip install selenium==3.5.0
RUN pip install pyvirtualdisplay
RUN pip install six

COPY zap_common.py /zap/
COPY zap-baseline-custom.py /zap/
COPY zap-full-scan.py /zap/

RUN chown zap:zap /zap/zap* && chmod +x /zap/zap*
