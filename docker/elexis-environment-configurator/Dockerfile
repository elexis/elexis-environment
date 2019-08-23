FROM openjdk:8-jre-alpine

RUN apk add --no-cache curl gettext

COPY assets/* /

WORKDIR /
CMD ["./wait-for.sh", "./initialize.sh"]