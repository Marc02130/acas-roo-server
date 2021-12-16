ARG 	CHEMISTRY_PACKAGE=bbchem
ARG 	TOMCAT_IMAGE=mcneilco/tomcat-maven:1.4-openjdk8

FROM 	${TOMCAT_IMAGE} as dependencies
ARG     CHEMISTRY_PACKAGE
ENV     CHEMISTRY_PACKAGE=${CHEMISTRY_PACKAGE}

FROM 	dependencies as jchem
ADD 	lib/jchem-16.4.25.0.jar /lib/jchem-16.4.25.0.jar
RUN     mvn install:install-file -Dfile=/lib/jchem-16.4.25.0.jar -DartifactId=jchem -DgroupId=com.chemaxon -Dversion=16.4.25.0 -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true

FROM 	dependencies as bbchem

FROM 	dependencies as indigo

FROM 	${CHEMISTRY_PACKAGE} as compile
ADD 	--chown=runner:runner pom.xml /src/pom.xml
WORKDIR /src
RUN 	mvn dependency:resolve -P ${CHEMISTRY_PACKAGE}
ADD 	. /src
RUN 	mvn clean && \
        mvn compile war:war -P ${CHEMISTRY_PACKAGE}
RUN     mv target/acas*.war $CATALINA_HOME/webapps/acas.war && \
        mv target/acas* $CATALINA_HOME/webapps/acas/

FROM 	${TOMCAT_IMAGE} as build
COPY 	--chown=runner:runner --from=compile /usr/local/tomcat/webapps/acas.war $CATALINA_HOME/webapps/acas.war
COPY 	--chown=runner:runner --from=compile /usr/local/tomcat/webapps/acas $CATALINA_HOME/webapps/acas
WORKDIR $CATALINA_HOME
EXPOSE 	8080
ENV    ACAS_HOME=/home/runner/build
ENV    CATALINA_OPTS="-Xms512M -Xmx1536M -XX:MaxPermSize=512m"
COPY --chown=runner:runner ./PrepareConfigFiles.coffee /home/runner/build/src/javascripts/BuildUtilities/PrepareConfigFiles.coffee
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"] 
CMD 	["catalina.sh", "run"]
