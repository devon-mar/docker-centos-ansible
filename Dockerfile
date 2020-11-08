FROM centos:8
ENV container docker

# systemd
# https://github.com/docker-library/docs/tree/master/centos
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# Use ansible from the CentOS repo
RUN yum -y update \
    && yum -y install yum-utils git python3 python3-pip epel-release \
    && yum -y install ansible \
    && yum clean all

# Install docker-ce-cli
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
    && yum install -y docker-ce-cli \
    && yum clean all

# Install molecule
RUN pip3 install molecule[docker]

CMD ["/usr/sbin/init"]