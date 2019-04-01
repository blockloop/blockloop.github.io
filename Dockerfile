FROM docker.io/jekyll/builder:3 as builder
USER root
ADD . /website
RUN chmod -R 777 /website
WORKDIR /website
RUN jekyll build --trace

FROM docker.io/nginx:stable-alpine
# for HEALTHCHECK
RUN apk add --no-cache curl
COPY --from=builder /website/_site/ /var/www/
RUN chown -R nginx:nginx /var/www \
	&& chmod -R 0744 /var/www

ADD nginx.conf /etc/nginx/nginx.conf
HEALTHCHECK --interval=10s --timeout=30s --start-period=5s --retries=3 CMD [ "curl", "http://127.0.0.1/ping" ]

CMD ["nginx", "-g", "daemon off;"]
