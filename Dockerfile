# 1. Use an official Maven image with Java 17 as the starting point
FROM maven:3.9.6-eclipse-temurin-17

# 2. Create a working directory inside the container
WORKDIR /app

# 3. Copy all project files from the GitHub server (Outside) into the container (Inside)
COPY . .

# 4. CRITICAL: Bring the generated settings.xml Inside so Maven has the passwords
COPY settings.xml /root/.m2/settings.xml

# 5. Pre-download Maven dependencies to make the actual deployment run faster
# (We use '|| true' so it doesn't crash if the placeholder passwords fail here)
RUN mvn dependency:resolve -s /root/.m2/settings.xml \
    -Danypoint.client_id=placeholder \
    -Danypoint.client_secret=placeholder || true

# 6. Set the default command to execute Maven
ENTRYPOINT ["mvn"]