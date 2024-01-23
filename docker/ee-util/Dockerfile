FROM medevit/eenv-config:R3
# TODO force pull on build
COPY assets /
# generate default user with id 1000 (debian)
RUN adduser --disabled-password debian
# generate default user with id 1001 (elexis)
RUN adduser --disabled-password elexis

WORKDIR /
CMD ["./nostageprovided.sh"]