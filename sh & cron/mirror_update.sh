#!/bin/bash
apt-mirror #Update Package File
cd /HDD/archive/mirror/
./archive.ubuntu.com.cnf.sh & #Update Ubuntu cnf
./ports.ubuntu.com.cnf.sh #Update Ubuntu-Ports cnf
fg #check job
cd /HDD/archive/mirror/archive.ubuntu.com/ubuntu/
ls -lR > /root/update/tmp/ls-lR #Indexing Ubuntu
gzip /root/update/tmp/ls-lR #compression
mv /root/update/tmp/ls-lR.gz /HDD/archive/mirror/archive.ubuntu.com/ubuntu/ls-lR.gz #Update Index File
cd /HDD/archive/mirror/ports.ubuntu.com/ubuntu-ports/
ls -lR > /root/update/tmp/ls-lR #Indexing Ubuntu-ports
gzip /root/update/tmp/ls-lR #compression
mv /root/update/tmp/ls-lR.gz /HDD/archive/mirror/ports.ubuntu.com/ubuntu-ports/ls-lR.gz #Update Index File
