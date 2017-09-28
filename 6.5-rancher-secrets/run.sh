#!/bin/bash

set -e

#obtain postgre addres from rancher


if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$(cat /run/secrets/${SONARQUBE_JDBC_USERNAME_FILE})" \
  -Dsonar.jdbc.password="$(cat /run/secrets/${SONARQUBE_JDBC_PASSWORD_FILE})" \
  -Dsonar.jdbc.url="jdbc:postgresql://${postgre_ip}:5432/$( cat /run/secrets/${POSTGRE_DBNAME})" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
tail -f /dev/null
