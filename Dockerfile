# Stage 1: Build the Java application using a dedicated Maven image
FROM maven:3.8.7-openjdk-17-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the application - 'clean package' generates the final JAR
RUN mvn clean package -DskipTests

# Stage 2: Create a lightweight runtime image
# We use a slim JRE for a smaller final image size
FROM openjdk:17-jre-slim

# Set the working directory for the final image
WORKDIR /app

# Copy the generated JAR from the build stage to the final stage
# The name of the JAR is defined in pom.xml as 'app.jar'
COPY --from=build /app/target/app.jar app.jar

# Define the entrypoint to run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
