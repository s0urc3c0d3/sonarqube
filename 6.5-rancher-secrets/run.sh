#!/bin/bash

set -e

#obtain postgre addres from rancher
postgre_ip=$(curl -s rancher-metadata.rancher.internal/2015-12-19/stacks/$POSTGRE_STACK/services/$POSTGRE_SERVICE/containers/0/primary_ip)


if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi


exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$(cat /run/secrets/${SONARQUBE_JDBC_USERNAME_FILE})" \
  -Dsonar.jdbc.password="$(cat /run/secrets/${SONARQUBE_JDBC_PASSWORD_FILE})" \
  -Dhttp.proxyUser=$(cat /run/secrets/${SONARQUBE_HTTP_PROXYUSER_FILE})
  -Dhttp.proxyPassword=$(cat /run/secrets/${SONARQUBE_HTTP_PROXYPASSWORD_FILE})
  -Dldap.bindDn=$(cat /run/secrets/${SONARQUBE_LDAP_BINDDN_FILE})
  -Dldap.bindPassword=$(cat /run/secrets/${SONARQUBE_LDAP_BINDPASSWORD_FILE})
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  -Dsonar.jdbc.url="jdbc:postgresql://${postgre_ip}:5432/${SONARQUBE_JDBC_DATABASE}" \
  -Dhttp.proxyHost=$SONARQUBE_HTTP_PROXYHOST \
  -Dhttp.proxyPort=$SONARQUBE_HTTP_PROXYPORT \
  -Dhttp.auth.ntlm.domain=$SONARQUBE_HTTP_AUTH_NTLM_DOMAIN \
  -Dsonar.security.realm=$SONARQUBE_SECURITY_REALM \
  -Dldap.url=$SONARQUBE_LDAP_uRL \
  -Dldap.user.baseDn=$SONARQUBE_LDAP_USER_BASEDN \
  -Dldap.user.request=$SONARQUBE_LDAP_USER_REQUEST \
  -Dldap.group.baseDn=$SONARQUBE_LDAP_GROUP_BASEDN \
  -Dldap.group.request=$SONARQUBE_LDAP_GROUP_REQUEST \
  -Dldap.group.idAttribute=$SONARQUBE_LDAP_GROUP_IDATTRIBUTE \
  "$@"


tail -f /dev/null

#  -Dsonar.jdbc.database=$SOUNARQUBE_JDBC_DATABASE \
