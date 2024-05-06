FROM alpine:3

RUN apk add --no-cache -U wireguard-tools curl jq iptables fping

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"

COPY monitor.sh /scripts
COPY run /scripts
COPY run-iptables-update /scripts
COPY wg-json /scripts
RUN chmod 755 /scripts/*
COPY mis_put.json.template /scripts
COPY mis_post.json.template /scripts

VOLUME /etc/wireguard

CMD ["run"]