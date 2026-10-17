FROM nginxinc/nginx-unprivileged:stable-alpine

LABEL org.opencontainers.image.title="CodeAlpha Docker Web Server"
LABEL org.opencontainers.image.authors="Muhammad Sani"

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY site/ /usr/share/nginx/html/

USER nginx
EXPOSE 8080

HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/health || exit 1

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
