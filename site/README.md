# Files unique to this site installation

These files are partially generated out of `../.env` and must not be deleted. Do not manually alter these files.

* `myserver.*` files that can be used to generate an SSL certificate
* `dhparam.pem` Diffie-Hellman parameter for DHE ciphersuites, [self-generated](https://www.howtoforge.com/tutorial/how-to-protect-your-debian-and-ubuntu-server-against-the-logjam-attack/)
* `bootstrap.ldif` LDAP configuration file generated for this site from `bootstrap.ldif.template`
* `keycloak-realm.json` Realm information for keycloak, generated from `realm.template.json`
* `certificate.crt` and `certificate.key` HTTPS certificates used by the webserver, see the main documentation on acquiring this
