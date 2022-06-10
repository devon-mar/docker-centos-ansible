FROM rockylinux:8
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

# Need GCC and Make for pynacl build
# https://github.com/pyca/pynacl/issues/601
RUN yum -y update \
    && yum -y install yum-utils findutils git unzip  python38 python38-pip python38-wheel epel-release gcc make python38-devel \
    && yum clean all

# Install docker-ce-cli
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
    && yum install -y docker-ce-cli \
    && yum clean all

# Install python packages
# pip3 install --upgrade pip: https://github.com/Azure/azure-cli/issues/16858
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir ansible~=5.0 ansible-lint~=5.0 yamllint molecule[docker] docker-compose netaddr

CMD ["/usr/sbin/init"]
