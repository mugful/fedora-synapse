FROM quay.io/fedora/fedora:41-x86_64
MAINTAINER Jiri Stransky <jistr@jistr.com>

RUN yum -y update --refresh; yum clean all

COPY build.sh /root/build.sh
RUN /root/build.sh

COPY files /

EXPOSE 8448

USER synapse

CMD ["/usr/local/bin/container_synapse"]
