# Operation Neptune - Self-Hosted DOS Game Container
# Uses nginx to serve the js-dos web emulator

FROM nginx:alpine

LABEL maintainer="Self-Hosted Games"
LABEL description="Operation Neptune DOS game running in browser via js-dos"
LABEL version="1.0"

# Install required tools
RUN apk add --no-cache \
    curl \
    unzip \
    bash

# Create directories
RUN mkdir -p /usr/share/nginx/html/game

# Copy web files
COPY index.html /usr/share/nginx/html/
COPY scripts/ /opt/scripts/

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Make scripts executable
RUN chmod +x /opt/scripts/*.sh

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
