#!/bin/bash

set -e

#obtain postgre addres from rancher
postgre_ip=$(curl -s rancher-metadata.rancher.internal/2015-12-19/stacks/$POSTGRE_STACK/services/$POSTGRE_SERVICE/containers/0/primary_ip)


if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="jdbc:postgresql://${postgre_ip}:5432/$POSTGRE_DBNAME" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
