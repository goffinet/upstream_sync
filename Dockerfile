FROM registry.access.redhat.com/rhel7

ARG ARCH=x86_64
RUN (echo "[epel]"; echo "name=epel"; echo "baseurl=https://download.fedoraproject.org/pub/epel/7/${ARCH}/"; \
    echo "enabled=1"; echo "gpgcheck=1") > /etc/yum.repos.d/epel.repo
RUN rpm --import https://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 && \
    yum makecache && yum install -y createrepo_c && \
    yum clean all
RUN curl https://bootstrap.pypa.io/get-pip.py|python && \
    pip install pyOpenSSL

VOLUME /etc/upstream_sync
VOLUME /mirror

ENV CONFD_DIR=/etc/upstream_sync
ENV MIRROR_DIR=/mirror

ENV MODIFYREPO_CMD=modifyrepo_c
ENV CREATEREPO_CMD=createrepo_c

COPY upstream_sync.py /usr/bin/upstream_sync.py
RUN chmod 755 /usr/bin/upstream_sync.py

#ENTRYPOINT [ "/usr/bin/python", "/usr/bin/upstream_sync.py", "--root" ]
CMD [ "/bin/bash"]

