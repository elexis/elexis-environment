FROM medevit/eenv-config
# TODO force pull on build
COPY assets /
# generate default user with id 1000
RUN adduser -D myuser

WORKDIR /
CMD ["./nostageprovided.sh"]