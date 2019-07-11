FROM adoptopenjdk/openjdk8:slim

ENV RUN_USER            					daemon
ENV RUN_GROUP           					daemon

# https://confluence.atlassian.com/crowd/important-directories-and-files-78676537.html
ENV CROWD_HOME          					/var/atlassian/application-data/crowd
ENV CROWD_INSTALL_DIR   					/opt/atlassian/crowd

VOLUME ["${CROWD_HOME}"]
WORKDIR $CROWD_HOME

# Expose HTTP port
EXPOSE 8095

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/tini", "--"]

RUN apt-get update \
	&& apt-get install -y --no-install-recommends fontconfig \
	&& apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY entrypoint.sh              /entrypoint.sh

ARG CROWD_VERSION
ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/crowd/downloads/atlassian-crowd-${CROWD_VERSION}.tar.gz

RUN mkdir -p                             ${CROWD_INSTALL_DIR} \
    && curl -L --silent                  ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$CROWD_INSTALL_DIR" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${CROWD_INSTALL_DIR}/ \
    && sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms\${JVM_MINIMUM_MEMORY:=\1} -Xmx\${JVM_MAXIMUM_MEMORY:=\2} \${JVM_SUPPORT_RECOMMENDED_ARGS} -Dcrowd.home=\${CROWD_HOME}/g' ${CROWD_INSTALL_DIR}/apache-tomcat/bin/setenv.sh \
    && sed -i -e 's/port="8095"/port="8095" secure="${catalinaConnectorSecure}" scheme="${catalinaConnectorScheme}" proxyName="${catalinaConnectorProxyName}" proxyPort="${catalinaConnectorProxyPort}"/' ${CROWD_INSTALL_DIR}/apache-tomcat/conf/server.xml
