# Acquiring an HTTPS certificate

A certificate (consisting of two files `certificate.crt`, containing the public and `certificate.key` , containing the private key) is the technological requirement for providing encrypted (not readable by others)
communication.

Certificates are bound to hostnames. That is, if this server's name is `ee.praxismustermann.ch` we have
to acquire an SSL certificate for this hostname.

There exist several [types](https://aboutssl.org/type-of-ssl/) of certificates. Cost and effort to acquire one differ.

## Letsencrypt

The most popular and even free-of-char solution is [letsencrypt](https://letsencrypt.org/de/). 

It however
only works if the hostname, one wants to acquire the certificate for, is publically accessible (to prove domain ownership).
There exists a [solution](https://blog.heckel.io/2018/08/05/issuing-lets-encrypt-certificates-for-65000-internal-servers/) to gather a certificate for an non-internet facing host, but it is not easy to use. 

In addition to this
letsencrypt certificates are only valid for 3 months, before they have to be reacquired.

Due to this, if you install elexis-environment we recommend a solution by a commercial provider.

## Commercial certificates

There exist several providers for commercial certificates. The advantage of these
certificates, is that they are valid for a max of 2 years, before they have to be replaced, and that they can by acquired by proving the ownership of the domain via mail. 

#### Acquiring an HTTPS certificate

https://www.interssl.com/de/ - SECTIGO PositiveSSL DV 

We fix an example for such a certificate, by using the swiss provider [www.hosttech.ch](https://www.hosttech.ch/solutions/ssl-zertifikate/). 

https://ssl-trust.com/SSL-Zertifikate/PositiveSSL

https://www.interssl.com/de/cart.php?gid=4

A SSL standard certificate for `ee.praxismustermann.ch` amounts to CHF 54.

## Hardening

CAA Record (if set to a specific ssl cert provider, only this provider may generate certificates for the specific host)