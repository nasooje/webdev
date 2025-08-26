FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /build

COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline

COPY src ./src

RUN ./mvnw package -DskipTests

FROM openjdk:21-jdk-slim

RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
ENV TZ=Asia/Seoul

RUN useradd -m user

WORKDIR /app

RUN mkdir -p /app/uploads && chown -R user:user /app/uploads
RUN mkdir -p /app/secret
RUN mkdir -p /app/profile && chown -R user:user /app/profile 

COPY --from=build /build/target/demo-0.0.1-SNAPSHOT.war app.war

USER user

RUN mkdir -p /app/uploads/21fa125d-b72f-49f1-99b0-773aba77eb4e
COPY src/main/webapp/resources/image/center.png /app/uploads/21fa125d-b72f-49f1-99b0-773aba77eb4e

ENTRYPOINT ["java", "-jar", "app.war"]

EXPOSE 8080