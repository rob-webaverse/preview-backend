FROM node:latest
ARG pm2_secret_key	
ENV LAST_UPDATED 20160605T165400
ENV PM2_PUBLIC_KEY wicmdcymxzyukdq
ENV PM2_SECRET_KEY=$pm2_secret_key
ENV HOSTNAME=0
LABEL description="webaverse-preview-backend"
	
# Copy source code
COPY . /preview-backend
	

# Change working directory
WORKDIR /preview-backend
	

# Install dependencies
RUN apt update -y
RUN apt-get install -y \
    fonts-liberation \
    gconf-service \
    libappindicator1 \
    libasound2 \
    libatk1.0-0 \
    libcairo2 \
    libcups2 \
    libfontconfig1 \
    libgbm-dev \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libicu-dev \
    libjpeg-dev \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpng-dev \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    xdg-utils
RUN npm install -g pm2
RUN npm install
RUN chmod -R o+rwx node_modules/puppeteer/.local-chromium

#RUN date +%s%3N | export HOSTNAME=standin
#RUN pm2 link $PM2_SECRET_KEY $PM2_PUBLIC_KEY $HOSTNAME
	

# Expose API port to the outside
EXPOSE 443
	

	# Launch application
CMD ["pm2-runtime", "index.js", "--secret", "$PM2_SECRET_KEY", "--public", "$PM2_PUBLIC_KEY", "--no-auto-exit", "--instances", "1", "--restart-delay", "60000"]