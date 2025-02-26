FROM node:latest

# Install required packages for both Node and Python along with Google Chrome packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip supervisor

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 libx11-xcb1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install flask requests Flask-Limiter --break-system-packages

# Create a user for the bot
RUN useradd -u 1001 botuser && \
    mkdir -p /home/botuser && \
    chown -R botuser:botuser /home/botuser

# Bot things
WORKDIR /bot
COPY bot/ /bot

RUN chown -R botuser:botuser /bot

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome

RUN npm install

# Chall things
WORKDIR /app
COPY src/ /app

RUN chown -R botuser:botuser /app

# supervisor
COPY config/supervisord.conf /etc/supervisord.conf

RUN useradd -u 1002 appuser && \
    chown -R appuser:appuser /app

USER botuser

ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]