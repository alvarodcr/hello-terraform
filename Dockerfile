FROM nginx:alpine-slim
COPY ./public_html/ /usr/share/nginx/html/
EXPOSE 80
LABEL org.opencontainers.image.source https://github.com/alvarodcr/hello-2048
