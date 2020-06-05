FROM medevit/eenv-config
# TODO force pull on build
COPY assets /
# generate default user with id 1000 (debian)
RUN adduser -D debian
# generate default user with id 1001 (elexis)
RUN adduser -D elexis

WORKDIR /
CMD ["./nostageprovided.sh"]