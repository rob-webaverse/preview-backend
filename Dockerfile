FROM buildkite/puppeteer:latest
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
RUN npm install -g forever
RUN npm install
RUN chmod -R o+rwx node_modules/puppeteer/.local-chromium

#RUN date +%s%3N | export HOSTNAME=standin
#RUN pm2 link $PM2_SECRET_KEY $PM2_PUBLIC_KEY $HOSTNAME
	

# Expose API port to the outside
EXPOSE 80
	

	# Launch application
CMD forever -a -l /host/forever.log -o stdout.log -e stderr.log index.js