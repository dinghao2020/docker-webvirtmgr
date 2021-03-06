
## Webvirtmgr Dockerfile

1. Install [Docker](https://www.docker.com/).

2. Pull the image from Docker Hub

```
docker pull ayaevil/docker-webvirtmgr
sudo groupadd -g 1010 webvirtmgr
sudo useradd -u 1010 -g webvirtmgr -s /sbin/nologin -d /data/vm webvirtmgr
test -d /data/vm || sudo mkdir  -pv /data/vm
sudo chown -R webvirtmgr:webvirtmgr /data/vm
```

### Usage

```
$ docker run -d -p 8080:8080 -p 6080:6080 --name webvirtmgr -v /data/vm:/data/vm ayaevil/docker-webvirtmgr
```

### libvirtd configuration on the host

```
$ cat /etc/default/libvirt-bin
start_libvirtd="yes"
libvirtd_opts="-d -l"
```

```
# 先忽略，如果有问题，请在配置文件里注释
$ cat /etc/libvirt/libvirtd.conf
listen_tls = 0
listen_tcp = 1
listen_addr = "127.0.0.1"  ## Address of docker0 veth on the host
unix_sock_group = "libvirtd"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
auth_unix_ro = "none"
auth_unix_rw = "none"
auth_tcp = "none"
auth_tls = "none"
```

```
$ cat /etc/libvirt/qemu.conf
# This is obsolete. Listen addr specified in VM xml.
# vnc_listen = "0.0.0.0"
vnc_tls = 0
# vnc_password = ""
```
