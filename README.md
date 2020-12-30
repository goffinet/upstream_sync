# upstream_sync
Sync http and https repositories using reposync, rsync repos, and sles using youget.

## Disclaimer
I've had many folks request that I share this script. To comply I am posting as
is. It's certainly not perfect and there is a lot of room for improvement.


## Configuration

Install the software :

```
destination_path="/opt/mirror/upstream"
export MIRROR_DIR="${destination_path}"
executable_destination="/usr/local/bin"
requirements="pyOpenSSL createrepo git"
config_path="/etc/upstream_sync"
yum -y install ${requirements}
git clone https://github.com/goffinet/upstream_sync ~/upstream_sync
cp ~/upstream_sync/upstream_sync.py ${executable_destination}
chmod +x ${executable_destination}/upstream_sync.py
```

Create a configuration file :

```
mkdir -p ${config_path}
cat << EOF > ${config_path}/centos.repo
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

[remi-php72-7-x86_64]
url = http://remi.mirrors.cu.be/enterprise/7/php72/x86_64/
path = centos/7/x86_64/remi-php72
createrepo = true

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
```

Usage example :

```
export MIRROR_DIR="${destination_path}"
upstream_sync.py -v
```

du -h | repo
--- | ---
20M | /opt/mirror/upstream/centos/7/x86_64/ansible-29
161M | /opt/mirror/upstream/centos/7/x86_64/centosplus
102M | /opt/mirror/upstream/centos/7/x86_64/docker-ce-stable
16G | /opt/mirror/upstream/centos/7/x86_64/epel
322M | /opt/mirror/upstream/centos/7/x86_64/extras
561M | /opt/mirror/upstream/centos/7/x86_64/mariadb-10.5
9.0G | /opt/mirror/upstream/centos/7/x86_64/os
16M | /opt/mirror/upstream/centos/7/x86_64/samba-411
223M | /opt/mirror/upstream/centos/7/x86_64/sclo
2.5G | /opt/mirror/upstream/centos/7/x86_64/updates
--- | ---
29G | /opt/mirror/upstream/centos/7/x86_64

### Examples
#### HTTPS with Authentication
/etc/upstream_sync/auth.conf
```
[rhel-server]
sslcacert = /mirror/certs/redhat-uep.pem
sslcert = /mirror/certs/rhel-server.pem
sslkey = /mirror/certs/rhel-server.pem
```

/etc/upstream_sync/redhat.repo
```
[rhel-7-x86_64-os]
auth = rhel-server
url = https://cdn.redhat.com/content/dist/rhel/server/7/7Server/x86_64/os
path = rhel/7/x86_64/os
createrepo = true

[rhel-6-x86_64-os]
auth = rhel-server
url = https://cdn.redhat.com/content/dist/rhel/server/6/6Server/x86_64/os
path = rhel/6/x86_64/os
createrepo = true
```

#### RSYNC with Exclude
/etc/upstream_sync/epel.repo
```
## epel
[epel-5-x86_64]
url = rsync://rsync.gtlib.gatech.edu/fedora-epel/5/x86_64/
path = el/5/x86_64/epel
exclude = /debug/

[epel-6-x86_64]
url = rsync://rsync.gtlib.gatech.edu/fedora-epel/6/x86_64/
path = el/6/x86_64/epel
exclude = /debug/

[epel-7-x86_64]
url = rsync://rsync.gtlib.gatech.edu/fedora-epel/7/x86_64/
path = el/7/x86_64/epel
exclude = /debug/
```


#### RSYNC
/etc/upstream_sync/centos.repo
```
## centos x86_64
[centos-6.6-x86_64-updates]
url = rsync://rsync.gtlib.gatech.edu/centos/6.6/updates/x86_64/Packages/
path = centos/6.6/x86_64/updates
createrepo = true

[centos-5.11-x86_64-updates]
url = rsync://rsync.gtlib.gatech.edu/centos/5.11/updates/x86_64/RPMS/
path = centos/5.11/x86_64/updates
createrepo = true
```

#### HTTP with sync_opts
Override the default reposync options with sync_opts

/etc/upstream_sync/mariadb.repo
```
[mariadb-10.1.12-rhel7]
url = http://yum.mariadb.org/10.1.12/rhel7-amd64/
path = mariadb/rhel7/x86_64
sync_opts = --norepopath --tempcache
createrepo = true

[mariadb-10.1.11-rhel7]
url = http://yum.mariadb.org/10.1.11/rhel7-amd64/
path = mariadb/rhel7/x86_64
sync_opts = --norepopath --tempcache
createrepo = true
```

#### RSYNC with Authentication
/etc/upstream_sync/auth.conf
```
[hp]
user = foo
password = bar
```

/etc/upstream_sync/hp.repo
```
[hp_fwpp-7-x86_64]
auth = hp
url = rsync://rsync.linux.hpe.com/FIRMWARE/repo/fwpp/rhel/7/x86_64/current/
path = el/7/x86_64/hp_fwpp
```

## Usage

List all Repos that are configured
  `./upstream_sync.py -l`

Sync specific repo
  `./upstream_sync.py -r rhel-6-x86_64-updates`

Sync all repos
  `./upsream_sync.py`

Be verbose while syncing
  `./upstream_sync.py -v`

Show sync and createrepo commands
  `./upstream_sync.py -c`

## Mirroring RedHat Repos

RedHat repos use HTTPS with client certificates for authentication. There is no special magic.

Remember, you still must comply with RedHat Licensing!

### Getting the Certificates
The CA can be found on any RHEL system: /etc/rhsm/ca/redhat-uep.pem

To obtain the client certificate and key, you need manually register your
system through the customer portal. You will then assign an entitlement to the
machine. At this point, you can download the entitlement cert/key. This is the
ssl certificate/key that you want to use with this script.

You can test the ssl certificate with this curl command
```$ curl --cacert /etc/rhsm/ca/redhat-uep.pem -E ./rhel.pem --key ./rhel.pem https://cdn.redhat.com/content/dist/rhel/server/7/7Server/x86_64/os```

Of course, adjust the URL as necessary.
