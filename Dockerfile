FROM alpine:latest
LABEL maintainer="Brandon Butler bmbawb@gmail.com"

COPY ./cloudflare.sh /cloudflare.sh

RUN apk update && \
    apk add --no-cache curl

ENV INTERVAL="300"
CMD /bin/sh /cloudflare.sh
