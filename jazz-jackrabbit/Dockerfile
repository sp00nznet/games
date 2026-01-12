# Jazz Jackrabbit: Holiday Hare 1995 - Self-Hosted DOS Game Container
FROM nginx:alpine
LABEL maintainer="Self-Hosted Games"
LABEL description="Jazz Jackrabbit Holiday Hare 1995 running in browser via js-dos"
RUN apk add --no-cache curl unzip bash
RUN mkdir -p /usr/share/nginx/html/game
COPY index.html /usr/share/nginx/html/
COPY scripts/ /opt/scripts/
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod +x /opt/scripts/*.sh 2>/dev/null || true
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1
CMD ["nginx", "-g", "daemon off;"]
