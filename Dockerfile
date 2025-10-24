This is a multi-stage Dockerfile optimized for a Java application.

Stage 1: Build Stage (Compiler and Packaging)

Using a stable Maven image that includes the Java 17 SDK from Eclipse Temurin.

FROM maven:3.9.6-eclipse-temurin-17 AS build

Set the working directory inside the container

WORKDIR /app

Copy the pom.xml and source code

COPY pom.xml .

Pre-download dependencies to leverage Docker layer caching

RUN mvn dependency:go-offline

COPY src ./src

Build the application - 'clean package' generates the final JAR

Ensure this command matches your project's build process

RUN mvn clean package -DskipTests

--------------------------------------------------------------------------

Stage 2: Create a lightweight runtime image

We use a secure, lightweight JRE image (Temurin 17 JRE on the Ubuntu Jammy base)

FROM eclipse-temurin:17-jre-jammy

Set the working directory for the final image

WORKDIR /app

Copy the generated JAR from the build stage to the final stage

We assume the JAR is named 'app.jar' based on your previous file.

COPY --from=build /app/target/app.jar app.jar

Define the entrypoint to run the JAR

This command executes the JAR file when the container starts

ENTRYPOINT ["java", "-jar", "app.jar"]
