#Base image
FROM tomcat:8.5

#COPY
COPY ./web/target/Power-Cloud-1.war /usr/local/tomcat/webapps/
EXPOSE 8080

WORKDIR /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
