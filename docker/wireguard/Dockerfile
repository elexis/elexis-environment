FROM alpine:3

RUN apk add --no-cache -U wireguard-tools

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"

COPY run /scripts
RUN chmod 755 /scripts/*

VOLUME /etc/wireguard

CMD ["run"]