FROM alpine:3

RUN apk add --no-cache -U wireguard-tools curl jq iptables

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"

COPY run /scripts
RUN chmod 755 /scripts/*
COPY mis_put.json.template /scripts
COPY mis_post.json.template /scripts

VOLUME /etc/wireguard

CMD ["run"]