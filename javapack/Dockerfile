#Use an official OpenJDK runtime as the base image ...ready image ..ubuntu + jdk
FROM openjdk:17-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the application's JAR file to the container
COPY target/demo-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port that your application runs on (optional, depending on your app configuration) webserver
EXPOSE 8080

# Run the Java application
CMD ["java", "-jar", "/app/app.jar"]
