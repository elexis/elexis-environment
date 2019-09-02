FROM openjdk:8-jre-alpine

RUN apk add --no-cache curl gettext bash bats bind-tools openssl

COPY assets/* /

WORKDIR /
CMD ["./configure.sh"]