FROM jboss/keycloak:10.0.2
USER jboss
RUN sed -i -e 's/<web-context>auth<\/web-context>/<web-context>keycloak\/auth<\/web-context>/' $JBOSS_HOME/standalone/configuration/standalone.xml &&\
    sed -i -e 's/<web-context>auth<\/web-context>/<web-context>keycloak\/auth<\/web-context>/' $JBOSS_HOME/standalone/configuration/standalone-ha.xml &&\
    sed -i -e 's/name="\/"/name="\/keycloak\/"/' $JBOSS_HOME/standalone/configuration/standalone.xml &&\
    sed -i -e 's/name="\/"/name="\/keycloak\/"/' $JBOSS_HOME/standalone/configuration/standalone-ha.xml &&\
    sed -i -e 's/\/auth/\/keycloak\/auth"/' $JBOSS_HOME/welcome-content/index.html

COPY assets/mytheme.tgz /mytheme.tgz
RUN tar xvzf /mytheme.tgz -C $JBOSS_HOME/themes/ &&\
    mv -v $JBOSS_HOME/themes/mytheme $JBOSS_HOME/themes/elexis