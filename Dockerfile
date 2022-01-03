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
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
RUN apt install libxshmfence-dev

RUN npm install -g pm2
RUN npm install
RUN chmod -R o+rwx node_modules/puppeteer/.local-chromium

#RUN date +%s%3N | export HOSTNAME=standin
#RUN pm2 link $PM2_SECRET_KEY $PM2_PUBLIC_KEY $HOSTNAME
	

# Expose API port to the outside
EXPOSE 443
	

	# Launch application
CMD ["pm2-runtime", "index.js", "--secret", "$PM2_SECRET_KEY", "--public", "$PM2_PUBLIC_KEY", "--no-auto-exit", "--instances", "1", "--restart-delay", "60000"]