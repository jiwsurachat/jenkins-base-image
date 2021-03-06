#!/bin/bash

set -e

mv settings.xml /usr/share/java/maven-3/conf/settings.xml
mv master /usr/share/ca-certificates/master.crt
mv ca /usr/local/share/ca-certificates/ca.crt

wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk
apk add glibc-2.30-r0.apk

echo '--install vault--'
wget https://releases.hashicorp.com/vault/1.3.2/vault_1.3.2_linux_amd64.zip
unzip vault_1.3.2_linux_amd64.zip
rm -f vault_1.3.2_linux_amd64.zip
mv vault /usr/local/bin

echo '--install sonar-scanner--'
wget -O sonar-scanner-cli-4.2.0.1873.zip  https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873.zip
unzip sonar-scanner-cli-4.2.0.1873.zip -d /home
rm -f sonar-scanner-cli-4.2.0.1873.zip
cd /home
mv sonar-scanner-4.2.0.1873 sonar-scanner

echo '--install dependency check--'
cd /home
wget -O dependency-check-5.3.0-release.zip https://dl.bintray.com/jeremy-long/owasp/dependency-check-5.3.0-release.zip
unzip dependency-check-5.3.0-release.zip
rm -f dependency-check-5.3.0-release.zip

echo '--install openshift cli--'
wget -O openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar xvzf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
cp ./openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin
rm -rf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit*

echo '--install internal cert--'
update-ca-certificates
keytool -import -storepass changeit -file /usr/share/ca-certificates/master.crt -keystore /etc/ssl/certs/java/cacerts -noprompt -alias jenkins_master

echo '--downoad dependency database--'
/home/dependency-check/bin/dependency-check.sh --scan .
