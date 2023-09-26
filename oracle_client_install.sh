#!/bin/bash

mkdir /opt/oracle
# downdload file
wget -O /opt/oracle/oracle_client.zip  "https://download.oracle.com/otn_software/linux/instantclient/1920000/instantclient-basic-linux.x64-19.20.0.0.0dbru.zip"
unzip /opt/oracle/oracle_client.zip -d /opt/oracle/
cd /opt/oracle/instantclient_19_20
ln -s libclntsh.so.12.1 libclntsh.so
ln -s libocci.so.12.1 libocci.so 
sh -c "echo /opt/oracle/instantclient_19_20 > \
      /etc/ld.so.conf.d/oracle-instantclient.conf"
ldconfig