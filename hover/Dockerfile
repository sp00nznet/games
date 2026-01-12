FROM nginx:alpine
LABEL maintainer="Self-Hosted Games"
RUN apk add --no-cache curl unzip bash && mkdir -p /usr/share/nginx/html/game
COPY index.html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1
CMD ["nginx", "-g", "daemon off;"]
