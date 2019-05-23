FROM docker.io/jekyll/builder:3 as builder
USER root
ADD . /website
RUN chmod -R 777 /website
WORKDIR /website
RUN jekyll build --trace

FROM docker.io/nginx:stable-alpine
# CVE-2019-5021
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow
COPY --from=builder /website/_site/ /var/www/
RUN chown -R nginx:nginx /var/www \
	&& chmod -R 0744 /var/www
ADD nginx.conf /etc/nginx/nginx.conf
CMD ["nginx", "-g", "daemon off;"]
