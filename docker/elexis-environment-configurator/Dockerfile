FROM openjdk:8-jre-alpine

RUN apk add --no-cache curl

COPY wait-for-rocketchat.sh /
COPY RocketchatSetting.jar /
COPY initialize.sh /
WORKDIR /
CMD ["./wait-for-rocketchat.sh","http://rocketchat:3000/chat/api/info", "./initialize.sh"]