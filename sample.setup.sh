#!/bin/bash
# Script to install upstream_sync.py
# To sync several repositories using reposync
# Tested with Centos 7
# 1. Set variables
destination_path="/opt/mirror/upstream"
executable_destination="/usr/local/bin"
requirements="pyOpenSSL createrepo git"
config_path="/etc/upstream_sync"
file_name="centos"
# 2. Install requirements
yum -y install ${requirements}
# 3. Create the config file
mkdir -p ${config_path}
cat << EOF > ${config_path}/${file_name}.repo
[centos-7-x86_64-os]
url = http://ftp.belnet.be/mirror/ftp.centos.org/7/os/x86_64/
path = centos/7/x86_64/os
createrepo = true

[centos-7-x86_64-extras]
url = http://ftp.belnet.be/mirror/ftp.centos.org/7/extras/x86_64/
path = centos/7/x86_64/extras
createrepo = true

[epel-7-x86_64]
url = https://mirror.23media.com/epel/7/x86_64/
path = centos/7/x86_64/epel
createrepo = true

[centos-7-x86_64-centosplus]
url = http://ftp.belnet.be/mirror/ftp.centos.org/7/centosplus/x86_64/
path = centos/7/x86_64/centosplus
createrepo = true

[centos-7-x86_64-updates]
url = http://ftp.belnet.be/mirror/ftp.centos.org/7/updates/x86_64/
path = centos/7/x86_64/updates
createrepo = true

[centos-7-x86_64-ansible-29]
url = http://ftp.belnet.be/mirror/ftp.centos.org/7/configmanagement/x86_64/ansible-29/
path = centos/7/x86_64/ansible-29
createrepo = true

[centos-7-x86_64-kvm-common]
url = http://ftp.belnet.be/mirror/ftp.centos.org/7/virt/x86_64/kvm-common/
path = centos/7/x86_64/kvm-common
createrepo = true

# php72, php73, rubygem, vagrant, vagrant-libvirt
[centos-7-x86_64-sclo]
url = http://ftp.belnet.be/mirror/ftp.centos.org/7/sclo/x86_64/sclo/
path = centos/7/x86_64/sclo
createrepo = true

[centos-7-x86_64-samba-411]
url = http://ftp.belnet.be/mirror/ftp.centos.org/7/storage/x86_64/samba-411/
path = centos/7/x86_64/samba-411
createrepo = true

# +3500 package at medium speed, more specific choices
# http://remi.mirrors.cu.be/enterprise/7/
#[remi-7-x86_64]
#url = http://remi.mirrors.cu.be/enterprise/7/remi/x86_64/
#path = centos/7/x86_64/remi
#createrepo = true

# Set your mariadb version
# See http://yum.mariadb.org
[mariadb-10.5-centos7-x86_64]
url = http://yum.mariadb.org/10.5/centos7-amd64/
path = centos/7/x86_64/mariadb-10.5
createrepo = true

# See if you want use Docker
[docker-ce-stable-centos7-x86_64]
url = https://download.docker.com/linux/centos/7/x86_64/stable/
path = centos/7/x86_64/docker-ce-stable
createrepo = true
EOF
