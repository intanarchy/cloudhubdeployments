FROM maven:3.9.6-eclipse-temurin-17

# Install basic tools
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Maven settings template
COPY settings.xml /root/.m2/settings.xml

# Default command
CMD ["mvn", "--version"]