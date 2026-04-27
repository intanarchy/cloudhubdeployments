FROM maven:3.9.6-eclipse-temurin-17

# Install MuleSoft's Maven settings template
WORKDIR /app
COPY . .
COPY settings.xml /root/.m2/settings.xml

# Pre-cache dependencies (optional but speeds up builds)
RUN mvn dependency:resolve -s /root/.m2/settings.xml \
    -Danypoint.client_id=placeholder \
    -Danypoint.client_secret=placeholder || true

ENTRYPOINT ["mvn"]