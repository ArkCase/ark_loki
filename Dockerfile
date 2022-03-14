FROM 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_base:latest

RUN yum update -y
RUN yum install -y unzip
LABEL ORG="Armedia LLC" \
      APP="loki" \
      VERSION="1.0" \
      IMAGE_SOURCE="https://github.com/ArkCase/ark_loki" \
      MAINTAINER="Armedia LLC"

#LOKI
ARG LOKI_VERSION="2.4.2"

ENV LOKI_USERID=2000 \
    LOKI_GROUPID=2020 \
    LOKI_GROUPNAME=loki \
    LOKI_USER=loki \
    LOKI_PORT=3100 \
    LOKI_URL="https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
RUN groupadd -g ${LOKI_GROUPID} ${LOKI_GROUPNAME} && \
    useradd -u ${LOKI_USERID} -g ${LOKI_GROUPNAME} ${LOKI_USER}
WORKDIR /opt
ADD ${LOKI_URL} /opt

RUN set -ex;\
    mkdir -p /loki/data;\
    unzip /opt/loki-linux-amd64.zip;\
    rm /opt/loki-linux-amd64.zip;\
    chown -R ${LOKI_USER}:${LOKI_USER} /opt;\
    chown -R ${LOKI_USER}:${LOKI_USER} /loki/data;\
    ln -s $(pwd)/loki-linux-amd64 /usr/local/bin/loki
COPY loki-config.yaml .

USER ${LOKI_USER}

EXPOSE $LOKI_PORT

CMD ["loki", "-config.file=/opt/loki_config.yaml"]