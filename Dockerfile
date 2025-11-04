# Use a lightweight OpenJDK image as the base
FROM openjdk:17-jre-slim

# Set build arguments for memory allocation with default values
ARG MIN_MEM="2G"
ARG MAX_MEM="4G"

# Set the working directory inside the container
WORKDIR /app

# Download the latest Minecraft server JAR
# We first fetch the version manifest to get the latest stable release URL
RUN apt-get update && apt-get install -y curl && \
    LATEST_VERSION_URL=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | \
                       jq -r '.latest.release as $latest_release | \
                             .versions[] | select(.id == $latest_release) | \
                             .url') && \
    SERVER_DOWNLOAD_URL=$(curl -s "$LATEST_VERSION_URL" | \
                          jq -r '.downloads.server.url') && \
    wget "$SERVER_DOWNLOAD_URL" -O server.jar && \
    apt-get remove -y curl wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Accept the Minecraft EULA. YOU MUST READ AND AGREE TO THE EULA BEFORE DOING THIS.
# https://aka.ms/MinecraftEULA
RUN echo "eula=true" > eula.txt

# Declare the /app/world directory as a volume point
# This signals that data here should be externalized for persistence.
VOLUME /app/world

# Expose the default Minecraft server port
EXPOSE 25565

# Command to run the Minecraft server, using the build arguments for memory
CMD ["java", "-Xmx${MAX_MEM}", "-Xms${MIN_MEM}", "-jar", "server.jar", "nogui"]