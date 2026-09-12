FROM eclipse-temurin:21-jre

WORKDIR /app

# تثبيت الأدوات المطلوبة وتنزيل playit binary
RUN apt-get update && apt-get install -y curl && \
    curl -SsL https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 -o /bin/playit && \
    chmod +x /bin/playit

# تنزيل برنامج Geyser Standalone
RUN curl -L -o Geyser-Standalone.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/standalone

# نسخ ملف الإعدادات
COPY config.yml /app/config.yml

EXPOSE 19132/udp
EXPOSE 19132/tcp

# تشغيل playit بالتزامن مع Geyser
CMD if [ -n "$PLAYIT_SECRET_KEY" ]; then \
      playit --secret "$PLAYIT_SECRET_KEY" run & \
    else \
      playit run & \
    fi && \
    java -Xmx1024M -jar Geyser-Standalone.jar

