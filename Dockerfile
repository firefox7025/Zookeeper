FROM ubuntu:trusty

MAINTAINER recursiverighthook alexandermontgomery95@gmail.com

RUN apt-get update; apt-get install -y unzip openjdk-7-jre-headless wget supervisor

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/

ENV ZOOKEEPER_VERSION 3.4.10

#Download Zookeeper
COPY zookeeper.tar.gz zookeeper.tar.gz

#Install

RUN mkdir -p /opt/zookeeper && tar -xzf zookeeper.tar.gz -C /opt

#Configure
RUN mv /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo_sample.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV ZK_HOME /opt/zookeeper-${ZOOKEEPER_VERSION}
RUN sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data

ADD start-zk.sh /usr/bin/start-zk.sh 
EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper
VOLUME ["/opt/zookeeper/conf", "/opt/zookeeper/data"]

CMD /usr/sbin/sshd && bash /usr/bin/start-zk.sh
