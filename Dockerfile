FROM eclipse-temurin:21-jre

WORKDIR /app

RUN apt-get update && apt-get install -y curl && \
    curl -SsL https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 -o /bin/playit && \
    chmod +x /bin/playit

RUN curl -L -o Geyser-Standalone.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone

COPY config.yml /app/config.yml

EXPOSE 19132/udp
EXPOSE 19132/tcp

# تعديل أمر التشغيل بمسح كلمة run
CMD if [ -n "$PLAYIT_SECRET_KEY" ]; then \
      playit --secret "$PLAYIT_SECRET_KEY" & \
    else \
      playit & \
    fi && \
    java -Xmx1024M -jar Geyser-Standalone.jar
    
