# Use a lightweight JRE image as the base
FROM eclipse-temurin:21-jre-jammy

# Set environment variables for memory allocation with default values
ENV MIN_MEM="2G"
ENV MAX_MEM="4G"

# Minecraft version build arguments
ARG MINECRAFT_VERSION="1.21.10"

# Set the working directory inside the container
WORKDIR /app

# Download the latest Minecraft server JAR
# We first fetch the version manifest to get the latest stable release URL
RUN apt-get update && apt-get install -y curl jq wget && \
    LATEST_VERSION_URL=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | \
        jq -r ".versions[] | select(.id == \"${MINECRAFT_VERSION}\") | .url") && \
    SERVER_DOWNLOAD_URL=$(curl -s "$LATEST_VERSION_URL" | \
        jq -r '.downloads.server.url') && \
    wget "$SERVER_DOWNLOAD_URL" -O server.jar && \
    apt-get remove -y curl jq wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Accept the Minecraft EULA. YOU MUST READ AND AGREE TO THE EULA BEFORE DOING THIS.
# https://aka.ms/MinecraftEULA
RUN echo "eula=true" > eula.txt

# This signals that data here should be externalized for persistence.
VOLUME /app

# Expose the default Minecraft server port
EXPOSE 25565

# Command to run the Minecraft server, using the environment variables for memory
CMD java -Xmx$MAX_MEM -Xms$MIN_MEM -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:+DisableExplicitGC -jar server.jar nogui