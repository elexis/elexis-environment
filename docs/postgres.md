# PostgreSQL Support for (my)Elexis-Server

To activate PostgreSQL for `myelexis-server`, set the following parameters in the `.env` file:

```
RDBMS_ELEXIS_TYPE=postgresql
RDBMS_ELEXIS_PORT=5432
MYELEXIS_SERVER_IMAGE_TAG_APPEND=-postgres
```

If the host differs from `$RDBMS_HOST`, also set:

```
RDBMS_ELEXIS_HOST=
```

## Testing the connection

To test the configuration, you can connect to the SQL server using:

```
./ee cmd sql elexis-server
```

You shoud see a line like `Connected with driver postgres (PostgreSQL 11.12)`

Then run the command `\dt` to list the tables. Exit with `\q` when finished.