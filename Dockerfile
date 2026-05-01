FROM maven:3.9.6-eclipse-temurin-17
WORKDIR /app

# Copy configuration files first
COPY pom.xml .
COPY settings.xml /root/.m2/settings.xml

# Pre-download dependencies (Docker will cache this step!)
RUN mvn dependency:resolve -s /root/.m2/settings.xml \
    -Danypoint.client_id=placeholder \
    -Danypoint.client_secret=placeholder || true

# Copy the rest of your MuleSoft code
COPY . .

ENTRYPOINT ["mvn"]
