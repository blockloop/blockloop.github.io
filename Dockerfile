FROM docker.io/jekyll/builder:3 as builder
USER root
ADD . /website
RUN chmod -R 777 /website
WORKDIR /website
RUN jekyll build --trace

FROM docker.io/blockloop/nginx-scratch:1.16.0
COPY nginx.conf /usr/local/nginx/conf/
COPY --from=builder /website/_site/ /var/www/
