FROM debian:jessie
MAINTAINER  <18001326539@163.com>
RUN apt-get -y update && \
    apt-get -y install git python-pip python-libvirt python-libxml2 supervisor novnc

RUN git clone https://github.com/retspen/webvirtmgr /webvirtmgr
RUN cd /webvirtmgr/
RUN pip install -r /webvirtmgr/requirements.txt
ADD local_settings.py /webvirtmgr/webvirtmgr/local/local_settings.py
RUN sed -i 's/0.0.0.0/127.0.0.1/g' /webvirtmgr/vrtManager/create.py
RUN /usr/bin/python /webvirtmgr/manage.py collectstatic --noinput

ADD supervisor.webvirtmgr.conf /etc/supervisor/conf.d/webvirtmgr.conf
ADD gunicorn.conf.py /webvirtmgr/conf/gunicorn.conf.py

ADD bootstrap.sh /webvirtmgr/bootstrap.sh

RUN groupadd libvirtd
RUN useradd webvirtmgr -g libvirtd -u 1010 -d /data/vm/ -s /sbin/nologin
RUN chown webvirtmgr:libvirtd -R /webvirtmgr

RUN apt-get -ys clean

WORKDIR /
VOLUME /data/vm

EXPOSE 8080
EXPOSE 6080
CMD ["supervisord", "-n"]
