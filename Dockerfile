FROM openjdk:11.0.15-jre-slim
EXPOSE 8080
ARG JAR=spring-petclinic-2.6.0-SNAPSHOT.jar
COPY target/$JAR /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]