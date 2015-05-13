FROM philcryer/min-wheezy
MAINTAINER Faisal Puthuparackat <faisal@druva.com>

ADD my_init /sbin/

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
        && mkdir /etc/container_environment \
        && chmod a+x /sbin/my_init && mkdir /etc/service && mkdir /etc/my_init.d \
        && apt-get update && apt-get install -qqy wget \
        && echo "deb http://debian.saltstack.com/debian wheezy-saltstack main" >> /etc/apt/sources.list \
        && echo "deb http://httpredir.debian.org/debian wheezy-backports main" >> /etc/apt/sources.list \
        && wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add - \
        && apt-get update -qq \
        && apt-get install -qqy python3 runit curl procps pciutils salt-minion \
        && apt-get install -qqy -t wheezy-backports linux-image-amd64 \
        && curl -sSL https://get.docker.com/ | sh \
        && apt-get remove -qqy curl git && apt-get clean -qqy && apt-get autoremove -qq && apt-get autoclean -qq

ADD salt-minion.runit /etc/service/salt-minion/run
RUN chmod a+x /etc/service/salt-minion/run

CMD ["/sbin/my_init"]

