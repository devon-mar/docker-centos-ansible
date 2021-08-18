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
    && yum -y install yum-utils git python38 python38-pip epel-release \
    && yum clean all

# Install docker-ce-cli
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
    && yum install -y docker-ce-cli \
    && yum clean all

# Install python packages
# pip3 install --upgrade pip: https://github.com/Azure/azure-cli/issues/16858
RUN pip3 install --upgrade pip \
    && pip3 install ansible~=4.0 ansible-lint~=5.0 yamllint molecule[docker] docker-compose netaddr

CMD ["/usr/sbin/init"]
