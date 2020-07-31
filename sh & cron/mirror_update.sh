#!/bin/bash
cp /root/update/page/offline.html /etc/nginx/html/index.html
cp /root/update/offline.conf /etc/nginx/nginx.conf
/usr/sbin/nginx -s reload
rm -rf /HDD/archive/skel/
apt-mirror
rm -rf /HDD/archive/mirror/ports.ubuntu.com/ubuntu-ports/dists/focal*/*/cnf
rm -rf /HDD/archive/mirror/archive.ubuntu.com/ubuntu/dists/focal*/*/cnf
cd /HDD/archive/mirror/
./archive.ubuntu.com.cnf.sh
./ports.ubuntu.com.cnf.sh
cd /HDD/archive/mirror/ports.ubuntu.com/ubuntu-ports
rm -f ls-lR.gz
ls -lR > ls-lR
gzip ls-lR
cd /HDD/archive/mirror/archive.ubuntu.com/ubuntu
rm -f ls-lR.gz
ls -lR > ls-lR
gzip ls-lR
cp /root/update/page/online.html /etc/nginx/html/index.html
cp /root/update/online.conf /etc/nginx/nginx.conf
/usr/sbin/nginx -s reload