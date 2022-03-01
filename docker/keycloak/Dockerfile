FROM jboss/keycloak:16.1.1
USER jboss
RUN sed -i -e 's/<web-context>auth<\/web-context>/<web-context>keycloak\/auth<\/web-context>/' $JBOSS_HOME/standalone/configuration/standalone.xml &&\
    sed -i -e 's/<web-context>auth<\/web-context>/<web-context>keycloak\/auth<\/web-context>/' $JBOSS_HOME/standalone/configuration/standalone-ha.xml &&\
    sed -i -e 's/name="\/"/name="\/keycloak\/"/' $JBOSS_HOME/standalone/configuration/standalone.xml &&\
    sed -i -e 's/name="\/"/name="\/keycloak\/"/' $JBOSS_HOME/standalone/configuration/standalone-ha.xml &&\
    sed -i -e 's/\/auth/\/keycloak\/auth"/' $JBOSS_HOME/welcome-content/index.html
