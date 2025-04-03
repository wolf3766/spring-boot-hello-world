# setting the base image, will be creating the build image
FROM maven:3.8.8-eclipse-temurin-17 AS builder

# setting up the work directory
WORKDIR /app

# Copy the project files
COPY pom.xml .

# run the mvn dependencies 
RUN mvn dependency:go-offline

# copy all the data to work directory
COPY . .

# running mvn clean at build time 
RUN mvn clean package -DskipTests

# Use a lightweight JDK runtime for the final image 
# using multiple from to build multi-stage image 
FROM openjdk:17-jdk-slim

# setting the new work directory
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# exposing port 8080 where java app will run 
EXPOSE 8080

# setting the entry point, to run the application when it comes live
ENTRYPOINT ["java", "-jar", "app.jar"]

