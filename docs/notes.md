# FAQ / Hints

* Bookstack startup fails with `The server requested authentication method unknown to the client`: MySQL uses the new authentication method, see https://ma.ttias.be/mysql-8-laravel-the-server-requested-authentication-method-unknown-to-the-client/ for a solution.
* Elexis-Server exception `java.sql.SQLNonTransientConnectionException: Public Key Retrieval is not allowed`: See https://stackoverflow.com/a/50438872/905817 for solution
## MySql 8 Installation on Linux

* Beware the lowercase [change](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_lower_case_table_names): https://geert.vanderkelen.org/2018/mysql8-unattended-dpkg/ `debconf-set-selections <<< "mysql-community-server mysql-server/lowercase-table-names select Enabled"` before installation