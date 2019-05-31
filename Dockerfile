FROM radial/busyboxplus:curl
LABEL maintainer="Brandon Butler bmbawb@gmail.com"

COPY ./cloudflare.sh /cloudflare.sh

ENV INTERVAL="300"
CMD /bin/sh /cloudflare.sh
